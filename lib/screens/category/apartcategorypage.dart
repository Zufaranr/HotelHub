import 'package:flutter/material.dart';
import 'package:hotelhub/components/hotel_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApartCategoryPage extends StatefulWidget {
  const ApartCategoryPage({Key? key}) : super(key: key);

  @override
  State<ApartCategoryPage> createState() => _ApartCategoryPageState();
}

class _ApartCategoryPageState extends State<ApartCategoryPage> {
  List<Map<String, dynamic>> apartemencategory = [];

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
      final responseapartemencategory = await http.get(
        Uri.parse(
            'https://hotelhub-7be75-default-rtdb.firebaseio.com/apartemencategory.json'),
      );

      if (responseapartemencategory.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(responseapartemencategory.body);
        data.forEach((key, value) {
          apartemencategory.add(value);
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
        title: Text('Apartement Category'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: apartemencategory.length,
              itemBuilder: (context, index) {
                return NewHotelList(apartemencategory[index]);
              },
            ),
    );
  }
}
