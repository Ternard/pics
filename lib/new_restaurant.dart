
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File class

class NewRestaurantScreen extends StatefulWidget {
  final Function(bool) onSubmit;

  const NewRestaurantScreen({super.key, required this.onSubmit});

  @override
  _NewRestaurantScreenState createState() => _NewRestaurantScreenState();
}

class _NewRestaurantScreenState extends State<NewRestaurantScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<Map<String, String>> _menuItems = [];
  XFile? _image;

  // Add menu item
  void _addMenuItem() {
    setState(() {
      _menuItems.add({"item": "", "price": ""});
    });
  }

  // Pick image function
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedFile;
      });
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Submit function
  void _submit() {
    if (_nameController.text.isEmpty || _locationController.text.isEmpty || _image == null) {
      widget.onSubmit(false); // Submission failed
    } else {
      // Simulate submission logic (e.g., upload data to a server)
      widget.onSubmit(true); // Submission successful
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
            "Add New Restaurant",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 20),

          // Image Picker Section
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

          const SizedBox(height: 10),

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
          const SizedBox(height: 20),

          // Menu Section
          Text(
            "Menu",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 10),

          // Editable Menu Items
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Item",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _menuItems[index]["item"] = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Price",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _menuItems[index]["price"] = value;
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),

          // Add Menu Item Button
          ElevatedButton(
            onPressed: _addMenuItem,
            child: Text("Add Menu Item"),
          ),

          const SizedBox(height: 20),

          // Submit Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              padding:
              EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape:
              RoundedRectangleBorder(borderRadius:
              BorderRadius.circular(8)),
            ),
            onPressed: _submit,
            child: Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}