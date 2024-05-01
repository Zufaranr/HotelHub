import 'package:flutter/material.dart';

class FacilityIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  FacilityIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
