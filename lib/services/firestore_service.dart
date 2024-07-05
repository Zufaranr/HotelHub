import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabaseService {
  final CollectionReference bookings =
      FirebaseFirestore.instance.collection('Bookings');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  // Create booking
  Future<void> createBooking(
      String title,
      String urlToImage,
      String checkInDate,
      String checkOutDate,
      String name,
      String email,
      String phone) async {
    await bookings.add({
      'title': title,
      'urlToImage': urlToImage,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'name': name,
      'email': email,
      'phone': phone,
    });
  }

  // Get all bookings. sql lite
  // Future<List<Map<String, dynamic>>> getBookings() async {
  //   QuerySnapshot querySnapshot = await bookings.get();
  //   return querySnapshot.docs.map((doc) {
  //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //     data['id'] = doc.id;
  //     return data;
  //   }).toList();
  // }

  // Delete booking by id
  Stream<QuerySnapshot> getBookings() {
    return bookings.snapshots();
  }

  Future<void> deleteBooking(String id) async {
    await bookings.doc(id).delete();
  }

  // Get users stream
  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }
}
