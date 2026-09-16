import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/detailArtikel.dart';
import 'package:http/http.dart' as http;
import '../theme/appColors.dart';
import '../widgets/navigation.dart';
import 'detailCategoryPage.dart';
import '../widgets/mobileStatusBar.dart';

class JelajahiPage extends StatefulWidget {
  const JelajahiPage({super.key});

  @override
  State<JelajahiPage> createState() => _JelajahiPageState();
}

class _JelajahiPageState extends State<JelajahiPage> {
  List categories = [];
  List posts = [];
  List allPosts = [];
  Map user = {};

  Set<int> savedPostIds = {};

  final TextEditingController searchController = TextEditingController();

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
        Uri.parse("http://localhost:3000/api/v1/bookmarks"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": 31, "postId": postId}),
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
      Uri.parse("http://localhost:3000/api/v1/bookmarks/user/31"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        savedPostIds = {
          for (var item in data['data']['bookmarks']) item['id'] as int,
        };
      });
    } else {
      print("Data bookmark gagal diambil");
    }
  }

  Future<void> getCategories() async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/api/v1/categories"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        categories = data['data'];
      });
    } else {
      print("Kategori gagal diambil");
    }
  }

  Future<void> getPosts() async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/api/v1/posts"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        allPosts = data['data']['posts'];
        posts = allPosts;
      });
    } else {
      print("Data gagal diambil");
    }
  }

  void searchPosts(String keyword) {
    setState(() {
      posts = allPosts.where((post) {
        return post['title'].toString().toLowerCase().contains(
          keyword.toLowerCase(),
        );
      }).toList();
    });
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
      return "${createdAt.day} ${["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"][createdAt.month - 1]} ${createdAt.year}";
    }
  }

  Future<void> getUser() async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/api/v1/users/31"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        user = data['data'];
      });
    } else {
      print("Data user gagal diambil");
    }
  }

  @override
  void initState() {
    super.initState();

    getCategories();
    getPosts();
    getBookmarks();
    getUser();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 20,

              title: Row(
                children: [
                  Image.asset('assets/images/logo.png', width: 30, height: 30),

                  const SizedBox(width: 8),

                  const Text(
                    'Jelajahi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                      fontSize: 16,
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(width: 18),

                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: user['imageUrl'] != null
                        ? NetworkImage(user['imageUrl'])
                        : null,
                    child: user['imageUrl'] == null
                        ? const Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ],
              ),
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const SizedBox(height: 10),

                  // SEARCH
                  TextField(
                    controller: searchController,
                    onChanged: searchPosts,

                    decoration: InputDecoration(
                      hintText: "Cari artikel...",

                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),

                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: AppColors.navy,
                      ),

                      filled: true,
                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // KATEGORI
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: categories.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2.6,
                        ),

                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailCategoryPage(
                                categoryId: category['id'],
                                categoryName: category['name'],
                              ),
                            ),
                          );
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                            image: DecorationImage(
                              image: AssetImage(
                                category['name'] == 'Teknologi'
                                    ? 'assets/images/teknologi.png'
                                    : category['name'] == 'Pendidikan'
                                    ? 'assets/images/pendidikan.png'
                                    : category['name'] == 'Gaya Hidup'
                                    ? 'assets/images/gayahidup.png'
                                    : category['name'] == 'Olahraga'
                                    ? 'assets/images/olahraga.png'
                                    : category['name'] == 'Kesehatan'
                                    ? 'assets/images/kesehatan.png'
                                    : 'assets/images/tipsTutorial.png',
                              ),

                              fit: BoxFit.cover,

                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.10),
                                BlendMode.darken,
                              ),
                            ),
                          ),

                          alignment: Alignment.center,

                          child: Text(
                            category['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Semua",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ARTIKEL
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final itemPost = posts[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailArtikel(postId: itemPost['id']),
                              ),
                            );
                          },
                          child: Container(
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

                                SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.navy.withOpacity(
                                                0.08,
                                              ),
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

                                          Spacer(),

                                          IconButton(
                                            onPressed: () {
                                              toggleBookmark(itemPost['id']);
                                            },
                                            icon: Icon(
                                              savedPostIds.contains(
                                                    itemPost['id'],
                                                  )
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,

                                              color: AppColors.navy,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 2),

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

                                      SizedBox(height: 3),

                                      Text(
                                        itemPost['content'] ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: "Lora",
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
                ],
              ),
            ),

            bottomNavigationBar: const CustomNavBar(currentIndex: 1),
          ),
        ),
      ],
    );
  }
}
