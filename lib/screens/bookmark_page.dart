import 'package:flutter/material.dart';
import 'package:hotelhub/database/database_service.dart';
import 'package:hotelhub/screens/hotel_detail_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late List<Map<String, dynamic>> bookmarks;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshHotelList();
  }

  Future<void> _refreshHotelList() async {
    setState(() {
      _isLoading = true;
    });
    List<Map<String, dynamic>> data = await DatabaseService.getItems();
    setState(() {
      bookmarks = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteItem(Map<String, dynamic> data) async {
    await DatabaseService.deleteItem(data['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmark berhasil dihapus'),
      ),
    );
    _refreshHotelList();
  }

  void goToDetailPage(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailPage(data, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> data = bookmarks[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(data['UrlToImage'] ?? "ini kosong"),
                    ),
                    title: Text(data['title'] ?? "ini kosong"),
                    subtitle: Text(data['lokasi'] ?? "ini kosong"),
                    onTap: () {
                      goToDetailPage(data);
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteItem(data);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
