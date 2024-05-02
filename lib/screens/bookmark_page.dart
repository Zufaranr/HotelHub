import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotelhub/database/database_service.dart';
import 'package:hotelhub/screens/hotel_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late List<Map<String, dynamic>> bookmarks;
  bool _isLoading = true;
  // late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    // initPrefs();
    _refreshHotelList();
  }

  Future<void> _refreshHotelList() async {
    setState(() {
      _isLoading = true; // Set loading menjadi true
    });
    // Panggil metode untuk mengambil data dari SQLite
    List<Map<String, dynamic>> data = await DatabaseService.getItems();
    setState(() {
      bookmarks = data; // Simpan data doa ke variabel lokal
      _isLoading = false; // Set loading menjadi false
    });
  }
  // void initPrefs() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   loadBookmarks();
  // }

  // void loadBookmarks() {
  //   setState(() {
  //     bookmarks = _prefs.containsKey('bookmarks')
  //         ? List<Map<String, dynamic>>.from(
  //             json.decode(_prefs.getString('bookmarks')!))
  //         : [];
  //   });
  // }

  // void removeBookmark(int index) {
  //   setState(() {
  //     bookmarks.removeAt(index);
  //     _prefs.setString('bookmarks', json.encode(bookmarks));
  //   });
  // }

  Future<void> _deleteItem(Map<String, dynamic> data) async {
    // Hapus data dari SQLite
    await DatabaseService.deleteItem(data['id']);
    // Refresh halaman untuk memperbarui tampilan
    _refreshHotelList();
  }

  void goToDetailPage(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailPage(data,false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          // Center(
          //     child: Text('No bookmarks yet'),
          //   )
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
                      goToDetailPage(
                          data); // Navigate to detail page when tapped
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
