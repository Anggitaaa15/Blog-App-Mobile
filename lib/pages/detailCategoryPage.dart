import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/detailArtikel.dart';
import 'package:http/http.dart' as http;
import '../widgets/mobileStatusBar.dart';
import '../theme/appColors.dart';

class DetailCategoryPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const DetailCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<DetailCategoryPage> createState() => _DetailCategoryPageState();
}

class _DetailCategoryPageState extends State<DetailCategoryPage> {
  List posts = [];

  Set<int> savedPostIds = {};

  Future<void> toggleBookmark(int postId) async {
    if (savedPostIds.contains(postId)) {
      final response = await http.delete(
        Uri.parse(
          "http://localhost:3000/api/v1/bookmarks/user/31/post/$postId",
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          savedPostIds.remove(postId);
        });

        print("Artikel dihapus dari tersimpan");
      } else {
        print(response.body);
      }
    } else {
      final response = await http.post(
        Uri.parse(
          "http://localhost:3000/api/v1/bookmarks",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "userId": 31,
          "postId": postId,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          savedPostIds.add(postId);
        });

        print("Artikel berhasil disimpan");
      } else {
        print(response.body);
      }
    }
  }

  Future<void> getBookmarks() async {
    final response = await http.get(
      Uri.parse(
        "http://localhost:3000/api/v1/bookmarks/user/31",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        savedPostIds = {
          for (var item in data['data']['bookmarks'])
            item['id'] as int,
        };
      });
    } else {
      print("Data bookmark gagal diambil");
    }
  }

  Future<void> getPosts() async {
    final response = await http.get(
      Uri.parse(
        "http://localhost:3000/api/v1/posts?categoryId=${widget.categoryId}",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        posts = data['data']['posts'];
      });
    } else {
      print("Data gagal diambil");
    }
  }

  String formatTimeAgo(String date) {
    final createdAt = DateTime.parse(date);
    final diff = DateTime.now().difference(createdAt);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} menit yang lalu";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} jam yang lalu";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} hari yang lalu";
    } else {
      return "${createdAt.day} ${[
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "Mei",
        "Jun",
        "Jul",
        "Agu",
        "Sep",
        "Okt",
        "Nov",
        "Des"
      ][createdAt.month - 1]} ${createdAt.year}";
    }
  }

  @override
  void initState() {
    super.initState();

    getPosts();
    getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MobileStatusBar(),

        Expanded(
          child: Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,

              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.navy,
                ),
              ),

              title: Text(
                widget.categoryName,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            body: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),

              itemCount: posts.length,

              itemBuilder: (context, index) {
                final itemPost = posts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailArtikel(
                          postId: itemPost['id'],
                        ),
                      ),
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // GAMBAR ARTIKEL
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),

                          child: Image.network(
                            itemPost['imageUrl'] ?? '',
                            width: 85,
                            height: 115,
                            fit: BoxFit.cover,

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                width: 85,
                                height: 115,
                                color: Colors.grey.shade200,

                                child: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              // KATEGORI + BOOKMARK
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),

                                    decoration: BoxDecoration(
                                      color: AppColors.navy
                                          .withOpacity(0.08),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),

                                    child: Text(
                                      itemPost['categoryName'] ?? '',
                                      style: const TextStyle(
                                        color: AppColors.navy,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  const Spacer(),

                                  IconButton(
                                    onPressed: () {
                                      toggleBookmark(
                                        itemPost['id'],
                                      );
                                    },

                                    icon: Icon(
                                      savedPostIds.contains(
                                        itemPost['id'],
                                      )
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,

                                      color: AppColors.navy,
                                      size: 19,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),

                              // JUDUL
                              Text(
                                itemPost['title'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // CONTENT
                              Text(
                                itemPost['content'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),

                              const SizedBox(height: 7),

                              // AUTHOR + WAKTU
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundColor:
                                        Colors.grey.shade200,

                                    backgroundImage:
                                        itemPost['userImage'] != null
                                            ? NetworkImage(
                                                itemPost['userImage'],
                                              )
                                            : null,

                                    child:
                                        itemPost['userImage'] == null
                                            ? const Icon(
                                                Icons.person_outline,
                                                size: 11,
                                                color: Colors.grey,
                                              )
                                            : null,
                                  ),

                                  const SizedBox(width: 5),

                                  Text(
                                    itemPost['username'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.navy,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    formatTimeAgo(
                                      itemPost['createdAt'],
                                    ),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}