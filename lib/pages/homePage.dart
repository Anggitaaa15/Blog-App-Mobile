import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/appColors.dart';
import 'package:http/http.dart' as http;
import '../widgets/navigation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List posts = [];

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
        "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
        "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
      ][createdAt.month - 1]} ${createdAt.year}";
    }
  }

  Future<void> getPosts() async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/api/v1/posts"),
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,

        leadingWidth: 140,

        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Image.asset('assets/images/logo.png', width: 30, height: 30),

              const SizedBox(width: 8),

              const Text(
                'Blog App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.navy),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 5),

              const Text(
                "Halo, Anggita 👋",
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Yuk, temukan artikel menarik hari ini.",
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),

              const SizedBox(height: 12),

              // BANNER
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/imageHome.png',
                      width: double.infinity,
                      height: 185,
                      fit: BoxFit.cover,
                    ),

                    Container(
                      width: double.infinity,
                      height: 185,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.65),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: Text(
                        'Tulis Ceritamu,\nBagikan Gagasanmu!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 14,
                      bottom: 14,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_outward,
                          color: AppColors.navy,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Artikel Terbaru",
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final itemPost = posts[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            itemPost['imageUrl'] ?? '',
                            width: 85,
                            height: 115,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.navy.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20),
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
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 4),

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
                                    formatTimeAgo(itemPost['createdAt']),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomNavBar(currentIndex: 0,),
    );
  }
}
