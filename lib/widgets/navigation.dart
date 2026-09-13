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
    return SizedBox(
      height: 85,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Navbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore,
                    label: "Jelajahi",
                  ),

                  const SizedBox(width: 65),

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
            ),
          ),

          // Tombol +
          Positioned(
            top: -10,
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 2) {
                  Navigator.pushReplacementNamed(
                    context,
                    "/buat",
                  );
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
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
            Navigator.pushReplacementNamed(
              context,
              "/beranda",
            );
          }

          if (value == 1) {
            Navigator.pushReplacementNamed(
              context,
              "/jelajahi",
            );
          }

          if (value == 3) {
            Navigator.pushReplacementNamed(
              context,
              "/artikelSaya",
            );
          }

          if (value == 4) {
            Navigator.pushReplacementNamed(
              context,
              "/profil",
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 26,
                color: isSelected
                    ? AppColors.navy
                    : Colors.grey.shade400,
              ),

              const SizedBox(height: 2),

              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: isSelected
                      ? AppColors.navy
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}