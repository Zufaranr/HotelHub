import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotelhub/screens/hotel_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map<String, dynamic>> bookmarks = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    loadBookmarks();
  }

  void loadBookmarks() {
    setState(() {
      bookmarks = _prefs.containsKey('bookmarks')
          ? List<Map<String, dynamic>>.from(
              json.decode(_prefs.getString('bookmarks')!))
          : [];
    });
  }

  void removeBookmark(int index) {
    setState(() {
      bookmarks.removeAt(index);
      _prefs.setString('bookmarks', json.encode(bookmarks));
    });
  }

  void goToDetailPage(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailPage(data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: bookmarks.isEmpty
          ? Center(
              child: Text('No bookmarks yet'),
            )
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> data = bookmarks[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['UrlToImage']),
                    ),
                    title: Text(data['title']),
                    subtitle: Text(data['lokasi']),
                    onTap: () {
                      goToDetailPage(
                          data); // Navigate to detail page when tapped
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeBookmark(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
