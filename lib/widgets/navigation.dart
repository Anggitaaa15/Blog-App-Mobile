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
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          _navItem(
            context,
            value: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: "Beranda",
          ),

          _navItem(
            context,
            value: 1,
            icon: Icons.search_outlined,
            activeIcon: Icons.search,
            label: "Jelajahi",
          ),

          _navItem(
            context,
            value: 2,
            icon: Icons.add,
            activeIcon: Icons.add,
            label: "Buat",
          ),

          _navItem(
            context,
            value: 3,
            icon: Icons.article_outlined,
            activeIcon: Icons.article,
            label: "Artikel Saya",
          ),

          _navItem(
            context,
            value: 4,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: "Profil",
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required int value,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = value == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () {
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
            Navigator.pushReplacementNamed(
              context,
              "/artikel-saya",
            );
          }

          if (value == 4) {
            Navigator.pushReplacementNamed(
              context,
              "/profil",
            );
          }
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.navy.withOpacity(0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 22,
                color: isSelected
                    ? AppColors.navy
                    : AppColors.grey,
              ),

              const SizedBox(height: 4),

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: isSelected
                      ? AppColors.navy
                      : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}