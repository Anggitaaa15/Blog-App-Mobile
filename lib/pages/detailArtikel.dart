import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/appColors.dart';
import '../widgets/mobileStatusBar.dart';

class DetailArtikel extends StatefulWidget {
  final int postId;

  const DetailArtikel({
    super.key,
    required this.postId,
  });

  @override
  State<DetailArtikel> createState() => _DetailArtikelState();
}

class _DetailArtikelState extends State<DetailArtikel> {
  Map<String, dynamic>? post;

  Future<void> getPost() async {
    final response = await http.get(
      Uri.parse(
        "http://localhost:3000/api/v1/posts/${widget.postId}",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print(data['data']['post']);

      setState(() {
        post = data['data']['post'];
      });
    } else {
      print("Artikel gagal diambil");
    }
  }

  String formatDate(String date) {
    final createdAt = DateTime.parse(date);

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

  @override
  void initState() {
    super.initState();
    getPost();
  }

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.navy,
          ),
        ),
      );
    }

    return Column(
      children: [
        const MobileStatusBar(),

        Expanded(
          child: Scaffold(
            backgroundColor: Colors.white,

            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOTO + TOMBOL
                  Stack(
                    children: [
                      Image.network(
                        post!['imageUrl'] ?? '',
                        width: double.infinity,
                        height: 320,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 320,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),

                      // BACK
                      Positioned(
                        top: 20,
                        left: 15,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // BOOKMARK + SHARE
                      Positioned(
                        top: 20,
                        right: 10,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.bookmark_border,
                                color: Colors.white,
                              ),
                            ),

                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // GRADIENT
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black87,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // KATEGORI + JUDUL
                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post!['categoryName'] ?? "Artikel",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              post!['title'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // INFORMASI ARTIKEL
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      22,
                      18,
                      22,
                      0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post!['title'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                formatDate(post!['createdAt']),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),

                        CircleAvatar(
                          radius: 19,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: post!['userImage'] != null
                              ? NetworkImage(post!['userImage'])
                              : null,
                          child: post!['userImage'] == null
                              ? const Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    height: 25,
                    indent: 22,
                    endIndent: 22,
                  ),

                  // ISI ARTIKEL
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      22,
                      0,
                      22,
                      30,
                    ),
                    child: Text(
                      post!['content'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}