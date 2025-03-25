import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File class


class NewMealScreen extends StatefulWidget {
  final Function(bool) onSubmit;

  const NewMealScreen({super.key, required this.onSubmit});

  @override
  _NewMealScreenState createState() => _NewMealScreenState();
}

class _NewMealScreenState extends State<NewMealScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  void _submit() async {
    if (_image != null) {
      final file = File(_image!.path);
      // Upload the file to Supabase or another server
      // Example: Supabase storage upload
      // final response = await Supabase.instance.client.storage.from('bucket-name').upload('path/to/upload', file);
      // if (response.error == null) {
      //   widget.onSubmit(true); // Success
      // } else {
      //   widget.onSubmit(false); // Failure
      // }
    } else {
      widget.onSubmit(false); // No image selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            "Add New Meal",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 20),

          // Image Picker
          if (_image != null)
            Image.file(
              File(_image!.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text("Pick Image"),
          ),

          // Name Field
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          // Location Field
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: "Location URL",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          // Price Field
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: "Price",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),

          // Description Field
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
            maxLines: 3, // Slightly bigger text area
          ),
          const SizedBox(height: 20),

          // Submit Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _submit,
            child: Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );;
  }
}