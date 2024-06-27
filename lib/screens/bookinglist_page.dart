import 'package:flutter/material.dart';
import 'package:hotelhub/database/booking_database_service.dart';

class BookingListPage extends StatefulWidget {
  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    List<Map<String, dynamic>> bookings =
        await BookingDatabaseService.getItems();
    setState(() {
      _bookings = bookings;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? Center(child: Text('No bookings yet'))
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(booking['UrlToImage'] ??
                              'https://via.placeholder.com/150'),
                        ),
                        title: Text(booking['title'] ?? 'Unknown Hotel'),
                        subtitle: Text(
                          'Check-in: ${booking['checkIn'] ?? 'N/A'}\n'
                          'Check-out: ${booking['checkOut'] ?? 'N/A'}',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
