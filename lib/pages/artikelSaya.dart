import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/theme/appColors.dart';
import 'package:http/http.dart' as http;
import '../widgets/navigation.dart';

class Artikelsaya extends StatefulWidget {
  const Artikelsaya({super.key});

  @override
  State<Artikelsaya> createState() => _ArtikelsayaState();
}

class _ArtikelsayaState extends State<Artikelsaya> {
  int selectedTab = 0;

  List posts = [];

  Future<void> getPosts() async {
    final response = await http.get(
      Uri.parse(
        "http://localhost:3000/api/v1/posts/user/31",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        posts = data['data']['posts'];
      });
    } else {
      print("Data artikel gagal diambil");
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
    List filteredPosts = [];

    for (var post in posts) {
      if (selectedTab == 0 && post["status"] == "Published") {
        filteredPosts.add(post);
      }

      if (selectedTab == 1 && post["status"] == "Draft") {
        filteredPosts.add(post);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,

      // APP BAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,

        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),

            const SizedBox(width: 8),

            const Text(
              'Lintas Kata',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
                fontSize: 16,
              ),
            ),

            const Spacer(),

            const Icon(
              Icons.search,
              color: AppColors.navy,
              size: 23,
            ),

            const SizedBox(width: 18),

            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // TAB PUBLISHED & DRAFT
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 14,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedTab == 0
                              ? AppColors.navy
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      "Published",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: selectedTab == 0
                            ? AppColors.navy
                            : Colors.grey,
                        fontWeight: selectedTab == 0
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 14,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedTab == 1
                              ? AppColors.navy
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      "Draft",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: selectedTab == 1
                            ? AppColors.navy
                            : Colors.grey,
                        fontWeight: selectedTab == 1
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // LIST ARTIKEL
          Expanded(
            child: filteredPosts.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada artikel",
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final itemPost = filteredPosts[index];

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
                            // GAMBAR
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                itemPost['imageUrl'] ?? '',
                                width: 85,
                                height: 115,
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

                            // ISI CARD
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // KATEGORI + TITIK TIGA
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

                                      // TITIK TIGA
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        constraints:
                                            const BoxConstraints(),
                                        iconSize: 20,
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: AppColors.navy,
                                        ),

                                        onSelected: (value) {
                                          if (value == "edit") {
                                            print(
                                              "Edit artikel ${itemPost['id']}",
                                            );
                                          }

                                          if (value == "delete") {
                                            print(
                                              "Delete artikel ${itemPost['id']}",
                                            );
                                          }
                                        },

                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: "edit",
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text("Edit"),
                                              ],
                                            ),
                                          ),

                                          const PopupMenuItem(
                                            value: "delete",
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_outline,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text("Delete"),
                                              ],
                                            ),
                                          ),
                                        ],
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

                                  // USER + WAKTU
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
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 3),
    );
  }
}