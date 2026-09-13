import 'package:flutter/material.dart';
import 'package:frontend/theme/appColors.dart';
import '../widgets/navigation.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Anggita",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),

            const Text(
              "Penulis di Lintas Kata",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "12",
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
                      "5",
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

            const SizedBox(height: 30),

            ListTile(
              tileColor: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const Icon(
                Icons.bookmark_outline,
                color: AppColors.navy,
              ),
              title: const Text(
                "Artikel Tersimpan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pengaturan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),

            const ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text("Edit Profil"),
              trailing: Icon(Icons.chevron_right),
            ),

            const ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text("Pengaturan"),
              trailing: Icon(Icons.chevron_right),
            ),

            const ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 4),
    );
  }
}