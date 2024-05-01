import 'package:flutter/material.dart';
import 'package:hotelhub/screens/hotel_detail_page.dart';

class HotelList extends StatelessWidget {
  final List<dynamic> hotelList;

  HotelList(this.hotelList);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Tambahkan SingleChildScrollView di sini
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true, // Tambahkan shrinkWrap: true
            physics:
                NeverScrollableScrollPhysics(), // Tambahkan physics: NeverScrollableScrollPhysics()
            itemCount: hotelList.length,
            itemBuilder: (context, index) {
              return NewHotelList(hotelList[index]);
            },
          ),
        ],
      ),
    );
  }
}

class NewHotelList extends StatelessWidget {
  final dynamic data;

  NewHotelList(this.data);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailPage(data),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                data['UrlToImage'], 
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'], // Menggunakan hotelName dari data
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data['lokasi'], // Menggunakan city dari data
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mulai dari \$${double.parse(data['price'].replaceAll('Rp', '').replaceAll('.', '')).toStringAsFixed(2)}/malam', // Menggunakan price dari data
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Action when button is pressed
                        },
                        child: Text('Pesan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
