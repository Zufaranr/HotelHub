import 'package:flutter/material.dart';
import 'package:hotelhub/screens/category/apartcategorypage.dart';
import 'package:hotelhub/screens/category/guesthcategorypage.dart';
import 'package:hotelhub/screens/category/hotelcategorypage.dart';
import 'package:hotelhub/screens/category/villacategorypage.dart';

class CategoryButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HotelCategoryPage(),
                ),
              );
            },
            child: CategoryButton(icon: Icons.hotel_outlined, title: 'Hotel'),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApartCategoryPage(),
                ),
              );
            },
            child: CategoryButton(
                icon: Icons.apartment_outlined, title: 'Apartemen'),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuestHousePage(),
                ),
              );
            },
            child: CategoryButton(
                icon: Icons.cottage_outlined, title: 'Guest House'),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VillaCategoryPage(),
                ),
              );
            },
            child: CategoryButton(icon: Icons.villa_outlined, title: 'Villa'),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String title;

  CategoryButton({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 30,
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
