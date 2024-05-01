import 'package:flutter/material.dart';
import 'package:hotelhub/components/hotel_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GuestHousePage extends StatefulWidget {
  const GuestHousePage({Key? key}) : super(key: key);

  @override
  State<GuestHousePage> createState() => _HotelCategoryPageState();
}

class _HotelCategoryPageState extends State<GuestHousePage> {
  List<Map<String, dynamic>> guesthousecategory = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final responseguesthousecategory = await http.get(
        Uri.parse(
            'https://hotelhub-7be75-default-rtdb.firebaseio.com/guesthousecategory.json'),
      );

      if (responseguesthousecategory.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(responseguesthousecategory.body);
        data.forEach((key, value) {
          guesthousecategory.add(value);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest House Category'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: guesthousecategory.length,
              itemBuilder: (context, index) {
                return NewHotelList(guesthousecategory[index]);
              },
            ),
    );
  }
}
