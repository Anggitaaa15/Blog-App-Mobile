import 'package:flutter/material.dart';
import '../theme/appColors.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,

      selectedItemColor: AppColors.navy,
      unselectedItemColor: AppColors.grey,

      onTap: (value) {
        if (value == currentIndex) return;

        if (value == 0) {
          Navigator.pushReplacementNamed(context, "/home");
        }

        if (value == 1) {
          Navigator.pushReplacementNamed(context, "/jelajahi");
        }

        if (value == 2) {
          Navigator.pushReplacementNamed(context, "/buat");
        }

        if (value == 3) {
          Navigator.pushReplacementNamed(context, "/artikel-saya");
        }

        if (value == 4) {
          Navigator.pushReplacementNamed(context, "/profil");
        }
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Beranda",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: "Jelajahi",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          activeIcon: Icon(Icons.add),
          label: "Buat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          activeIcon: Icon(Icons.article),
          label: "Artikel Saya",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }
}