import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/detailArtikel.dart';
import 'package:http/http.dart' as http;
import '../theme/appColors.dart';

class TersimpanPage extends StatefulWidget {
  const TersimpanPage({super.key});

  @override
  State<TersimpanPage> createState() => _TersimpanPageState();
}

class _TersimpanPageState extends State<TersimpanPage> {
  List bookmarks = [];

  Future<void> getBookmarks() async {
    final response = await http.get(
      Uri.parse(
        "http://localhost:3000/api/v1/bookmarks/user/31",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        bookmarks = data['data']['bookmarks'];
      });
    } else {
      print("Artikel tersimpan gagal diambil");
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
    getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Tersimpan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: bookmarks.isEmpty
          ? const Center(
              child: Text(
                "Belum ada artikel tersimpan",
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final itemPost = bookmarks[index];

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

                                  const Icon(
                                    Icons.bookmark,
                                    color: AppColors.navy,
                                    size: 20,
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
                                  color: Colors.black,
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
                                  color: Colors.black87,
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
                                    itemPost['createdAt'] != null
                                        ? formatTimeAgo(
                                            itemPost['createdAt'],
                                          )
                                        : '',
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
    );
  }
}