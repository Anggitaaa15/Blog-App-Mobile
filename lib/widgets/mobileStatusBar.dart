import 'package:flutter/material.dart';

class MobileStatusBar extends StatelessWidget {
  const MobileStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 38),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "00.00",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),

          Row(
            children: const [
              Icon(
                Icons.signal_cellular_alt,
                size: 16,
                color: Colors.black,
              ),
              SizedBox(width: 12),
              Icon(
                Icons.wifi,
                size: 16,
                color: Colors.black,
              ),
              SizedBox(width: 12),
              Icon(
                Icons.battery_full,
                size: 16,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}