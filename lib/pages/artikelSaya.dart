import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/theme/appColors.dart';
import 'package:http/http.dart' as http;

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

  String formatTime(String date) {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 25,
              height: 25,
            ),

            const SizedBox(width: 6),

            const Text(
              "Lintas Kata",
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            const Icon(
              Icons.search,
              color: Colors.black,
              size: 23,
            ),

            const SizedBox(width: 18),

            const CircleAvatar(
              radius: 13,
              backgroundImage: AssetImage(
                "assets/images/profile.jpg",
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // TAB
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
                    padding: const EdgeInsets.all(15),
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(7),
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
                              child: post["imageUrl"] != null
                                  ? Image.network(
                                      post["imageUrl"],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.image_outlined,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),

                            const SizedBox(width: 8),

                            // ISI CARD
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // KATEGORI
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.amber,
                                            width: 0.8,
                                          ),
                                        ),
                                        child: Text(
                                          "Kategori ${post["categoryId"]}",
                                          style: const TextStyle(
                                            fontSize: 8,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ),

                                      const Spacer(),

                                      // TITIK TIGA
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        iconSize: 19,
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        ),
                                        onSelected: (value) {
                                          if (value == "edit") {
                                            print(
                                              "Edit artikel ${post["id"]}",
                                            );
                                          }

                                          if (value == "delete") {
                                            print(
                                              "Delete artikel ${post["id"]}",
                                            );
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem<String>(
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
                                          const PopupMenuItem<String>(
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

                                  const SizedBox(height: 2),

                                  // JUDUL
                                  Text(
                                    post["title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 1),

                                  // CONTENT
                                  Text(
                                    post["content"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  // USERNAME + WAKTU
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 7,
                                        backgroundImage: AssetImage(
                                          "assets/images/profile.jpg",
                                        ),
                                      ),

                                      const SizedBox(width: 4),

                                      const Text(
                                        "Anggita",
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: AppColors.navy,
                                        ),
                                      ),

                                      const SizedBox(width: 6),

                                      const Text(
                                        "•",
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(width: 6),

                                      Text(
                                        formatTime(post["createdAt"]),
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Colors.grey,
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
    );
  }
}