import 'package:flutter/material.dart';
import 'package:hotelhub/components/bottnavbar.dart';
import 'package:hotelhub/database/booking_database_service.dart';
import 'package:hotelhub/services/notif.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> data;

  BookingPage(this.data, {Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  @override
  void initState() {
    super.initState();
    Noto.init(); // Initialize notifications
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDateSelected) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      onDateSelected(date);
    }
  }

  Future<void> _confirmBooking() async {
    if (_formKey.currentState!.validate() &&
        _checkInDate != null &&
        _checkOutDate != null) {
      // Save the booking to the database
      try {
        final id = await BookingDatabaseService.createItem(
          widget.data['title'],
          widget.data['UrlToImage'],
          _checkInDate!.toLocal().toString().split(' ')[0],
          _checkOutDate!.toLocal().toString().split(' ')[0],
        );
        print('Booking saved with id: $id');

        // Show notification
        Noto.showNoto(
          title: 'Booking Confirmed',
          body: 'Your booking has been confirmed.',
          payload: 'booking_confirmed',
        );

        // Navigate to Booking List Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottNavBar(),
          ),
        );
      } catch (error) {
        print('Failed to save booking: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save booking. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields and select dates')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous page
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                widget.data['title'] ?? 'Hotel Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildTextFormField(
                controller: _nameController,
                label: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextFormField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextFormField(
                controller: _phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Check-in Date'),
                subtitle: Text(_checkInDate == null
                    ? 'Select Date'
                    : _checkInDate!.toLocal().toString().split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, _checkInDate, (date) {
                  setState(() {
                    _checkInDate = date;
                  });
                }),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Check-out Date'),
                subtitle: Text(_checkOutDate == null
                    ? 'Select Date'
                    : _checkOutDate!.toLocal().toString().split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (date != null) {
                    setState(() {
                      _checkOutDate = date;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _confirmBooking,
                child: Text('Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
