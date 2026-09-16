import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/artikelSaya.dart';
import 'package:frontend/pages/registerPage.dart';
import 'package:frontend/pages/tersimpan.dart';
import 'package:frontend/theme/appColors.dart';
import 'package:http/http.dart' as http;
import '../widgets/navigation.dart';
import '../widgets/mobileStatusBar.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Map user = {};
  int jumlahArtikel = 0;
  int jumlahTersimpan = 0;

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

  Future<void> getMyPosts() async {
    print("getMyPosts dijalankan");

    final response = await http.get(
      Uri.parse("http://localhost:3000/api/v1/posts/user/31"),
    );

    print("Status: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        jumlahArtikel = data['data']['posts'].length;
      });
    } else {
      print("Data artikel gagal diambil");
    }
  }

  Future<void> getBookmarks() async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/api/v1/bookmarks/user/31"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final bookmarks = data['data']['bookmarks'] ?? [];

      setState(() {
        jumlahTersimpan = bookmarks.length;
      });
    } else {
      print("Data tersimpan gagal diambil");
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getMyPosts();
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
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 20,

              title: Row(
                children: [
                  Image.asset('assets/images/logo.png', width: 30, height: 30),

                  const SizedBox(width: 8),

                  const Text(
                    'Profil',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey,
                    backgroundImage: user['imageUrl'] != null
                        ? NetworkImage(user['imageUrl'])
                        : null,
                    child: user['imageUrl'] == null
                        ? Icon(Icons.person, size: 55, color: Colors.white)
                        : null,
                  ),

                  SizedBox(height: 15),

                  Text(
                    user['username'] ?? "",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),

                  Text(
                    "Berbagi ide, cerita, dan informasi",
                    style: TextStyle(color: Colors.grey),
                  ),

                  SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            jumlahArtikel.toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          Text("Artikel"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            jumlahTersimpan.toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          Text("Tersimpan"),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text("Edit Profil"),
                    trailing: Icon(Icons.chevron_right),
                  ),

                  ListTile(
                    leading: Icon(Icons.article_outlined),
                    title: Text("Artikel Saya"),
                    trailing: Icon(Icons.chevron_right),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Artikelsaya()),
                      );
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.bookmark_outline),
                    title: Text("Tersimpan"),
                    trailing: Icon(Icons.chevron_right),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TersimpanPage(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text("Bantuan"),
                    trailing: Icon(Icons.chevron_right),
                  ),

                  ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text("Pengaturan"),
                    trailing: Icon(Icons.chevron_right),
                  ),

                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      "Keluar",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right),

                    onTap: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => Register()
                        )
                      );
                    },
                  ),
                ],
              ),
            ),

            bottomNavigationBar: CustomNavBar(currentIndex: 4),
          ),
        ),
      ],
    );
  }
}
