import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  State<DetailCategoryPage> createState() =>
      _DetailCategoryPageState();
}

class _DetailCategoryPageState extends State<DetailCategoryPage> {
  List posts = [];

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ),
            ),
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final itemPost = posts[index];

          return Container(
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

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    itemPost['imageUrl'] ?? '',
                    width: 85,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        width: 85,
                        height: 85,
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

                      Row(
                        children: [
                          Text(
                            itemPost['categoryName'] ?? '',
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.navy,
                            ),
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.bookmark_border,
                            color: AppColors.navy,
                            size: 19,
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

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

                      Text(
                        itemPost['content'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [

                          CircleAvatar(
                            radius: 8,
                            backgroundImage: NetworkImage(
                              itemPost['userImage'] ?? '',
                            ),
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
          );
        },
      ),
    );
  }
}