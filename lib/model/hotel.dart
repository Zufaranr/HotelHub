class Hotel {
  final int id;
  final String title;
  final String lokasi;
  final String urlToImage;
  final String price;

  Hotel({
    required this.id,
    required this.title,
    required this.lokasi,
    required this.urlToImage,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'lokasi': lokasi,
      'urlToImage': urlToImage,
      'price': price,
    };
  }

  // Static method to create Hotel object from Map
  static Hotel fromMap(Map<dynamic, dynamic> map) {
    return Hotel(
      id: map['id'],
      title: map['title'],
      lokasi: map['lokasi'],
      urlToImage: map['urlToImage'],
      price: map['price'],
    );
  }
}
