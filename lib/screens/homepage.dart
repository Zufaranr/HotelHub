import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotelhub/components/category_buttons.dart';
import 'package:hotelhub/components/hotel_list.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> allhoteldata = [];
  bool isLoading = false; // New variable to track loading state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading state to true when fetching data
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://hotelhub-7be75-default-rtdb.firebaseio.com/allhoteldata.json',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data.forEach((key, value) {
          allhoteldata.add(value);
        });

        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading =
            false; // Set loading state to false when data fetching is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Header(),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              CategoryButtons(),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Rekomendasi Hotel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              // Check if data is loading, if true show CircularProgressIndicator
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allhoteldata.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Handle hotel item click here
                            // For now, just print a message
                            print(
                                'Hotel clicked: ${allhoteldata[index]['title']}');
                          },
                          child: NewHotelList(allhoteldata[index]),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.lightBlueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 35),
          Text(
            'Temukan penginapan terbaik untuk perjalanan Anda.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Hotel',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
