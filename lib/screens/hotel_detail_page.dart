import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotelhub/components/facility_cattegory_icon.dart';
import 'package:hotelhub/model/hotel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  HotelDetailPage(this.data, {Key? key}) : super(key: key);

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  bool isBookmarked = false;
  SharedPreferences? _prefs; // Shared Preferences instance

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  // Initialize shared preferences
  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Function to add bookmark
  void addBookmark(Map<String, dynamic> data) {
    List<Map<String, dynamic>> bookmarks = [];
    if (_prefs!.containsKey('bookmarks')) {
      bookmarks = List<Map<String, dynamic>>.from(
          json.decode(_prefs!.getString('bookmarks')!));
    }
    bookmarks.add(data);
    _prefs!.setString('bookmarks', json.encode(bookmarks));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.data['UrlToImage']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.data['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: Colors.pink,
                              size: 35.0,
                            ),
                            onPressed: () {
                              setState(() {
                                isBookmarked = !isBookmarked;
                                if (isBookmarked) {
                                  addBookmark(widget
                                      .data); // Add data to bookmark when bookmark icon is pressed
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 20),
                          SizedBox(width: 8),
                          Text(
                            widget.data['lokasi'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Fasilitas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FacilityIcon(
                              icon: Icons.local_parking, label: 'Parkir'),
                          FacilityIcon(icon: Icons.wifi, label: 'Wi-Fi'),
                          FacilityIcon(icon: Icons.pool, label: 'Kolam Renang'),
                          FacilityIcon(
                              icon: Icons.restaurant, label: 'Restoran'),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Deskripsi Hotel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Deskripsi hotel ini akan diisi di sini. Anda dapat menambahkan informasi tentang fasilitas, lokasi, dan lainnya.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Harga per Malam',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${double.parse(widget.data['price'].replaceAll('Rp', '').replaceAll('.', '')).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Action when book button is pressed
                      },
                      icon: Icon(Icons.add_shopping_cart,
                          color: Colors.white, size: 50),
                      label: Text(
                        'Book Now',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.blueAccent, size: 35),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}