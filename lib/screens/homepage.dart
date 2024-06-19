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
  List<Map<String, dynamic>> allhoteldata = [];
  List<Map<String, dynamic>> filteredHotelData = [];
  bool isLoading = false; // New variable to track loading state
  TextEditingController searchController = TextEditingController();

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

        setState(() {
          filteredHotelData = allhoteldata;
        });
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

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredHotelData = allhoteldata;
      });
      return;
    }

    List<Map<String, dynamic>> tempList = [];
    allhoteldata.forEach((hotel) {
      if (hotel['title'].toLowerCase().contains(query.toLowerCase())) {
        tempList.add(hotel);
      }
    });

    setState(() {
      filteredHotelData = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Header(
                  searchController: searchController,
                  onChanged: filterSearchResults),
              SizedBox(height: 10),
              searchController.text.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(),
              searchController.text.isEmpty ? SizedBox(height: 8) : Container(),
              searchController.text.isEmpty ? CategoryButtons() : Container(),
              searchController.text.isEmpty
                  ? SizedBox(height: 10)
                  : Container(),
              searchController.text.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Rekomendasi Hotel',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(),
              searchController.text.isEmpty ? SizedBox(height: 5) : Container(),
              // Check if data is loading, if true show CircularProgressIndicator
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredHotelData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Handle hotel item click here
                            // For now, just print a message
                            print(
                                'Hotel clicked: ${filteredHotelData[index]['title']}');
                          },
                          child: NewHotelList(filteredHotelData[index]),
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
  final TextEditingController searchController;
  final Function(String) onChanged;

  const Header({
    Key? key,
    required this.searchController,
    required this.onChanged,
  }) : super(key: key);

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
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Hotel',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
