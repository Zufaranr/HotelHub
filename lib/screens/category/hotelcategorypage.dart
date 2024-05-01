import 'package:flutter/material.dart';
import 'package:hotelhub/components/hotel_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelCategoryPage extends StatefulWidget {
  const HotelCategoryPage({Key? key}) : super(key: key);

  @override
  State<HotelCategoryPage> createState() => _HotelCategoryPageState();
}

class _HotelCategoryPageState extends State<HotelCategoryPage> {
  List<Map<String, dynamic>> hotelcategory = [];

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
      final responsehotelcategory = await http.get(
        Uri.parse(
            'https://hotelhub-7be75-default-rtdb.firebaseio.com/hotelcategory.json'),
      );

      if (responsehotelcategory.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(responsehotelcategory.body);
        data.forEach((key, value) {
          hotelcategory.add(value);
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
        title: Text('Hotel Category'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: hotelcategory.length,
              itemBuilder: (context, index) {
                return NewHotelList(hotelcategory[index]);
              },
            ),
    );
  }
}
