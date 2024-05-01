import 'package:flutter/material.dart';
import 'package:hotelhub/components/hotel_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VillaCategoryPage extends StatefulWidget {
  const VillaCategoryPage({Key? key}) : super(key: key);

  @override
  State<VillaCategoryPage> createState() => _VillaCategoryPageState();
}

class _VillaCategoryPageState extends State<VillaCategoryPage> {
  List<Map<String, dynamic>> villacategory = [];

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
      final responsevillacategory = await http.get(
        Uri.parse(
            'https://hotelhub-7be75-default-rtdb.firebaseio.com/villacategory.json'),
      );

      if (responsevillacategory.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(responsevillacategory.body);
        data.forEach((key, value) {
          villacategory.add(value);
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
        title: Text('Villa Category'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: villacategory.length,
              itemBuilder: (context, index) {
                return NewHotelList(villacategory[index]);
              },
            ),
    );
  }
}
