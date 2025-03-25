import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class NewRestaurantScreen extends StatefulWidget {
  final Function(bool, String?) onSubmit;

  const NewRestaurantScreen({super.key, required this.onSubmit});

  @override
  State<NewRestaurantScreen> createState() => _NewRestaurantScreenState();
}

class _NewRestaurantScreenState extends State<NewRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<Map<String, String>> _menuItems = [];
  XFile? _image;
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;

  void _addMenuItem() {
    setState(() {
      _menuItems.add({"item": "", "price": ""});
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ${e.toString()}')),
        );
      }
    }
  }

  bool _isValidMapUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasAbsolutePath &&
          (uri.host.contains('google.com') ||
              uri.host.contains('goo.gl') ||
              uri.host.contains('maps.apple.com') ||
              uri.host.contains('google.co'));
    } catch (_) {
      return false;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      widget.onSubmit(false, "Restaurant image is required");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final locationUrl = _locationController.text;
      if (!_isValidMapUrl(locationUrl)) {
        throw Exception("Please enter a valid Google Maps or Apple Maps URL");
      }

      // Upload image
      final imageFile = File(_image!.path);
      final imageExt = _image!.path.split('.').last;
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.$imageExt';
      final imagePath = 'images/$imageName';

      await _supabase.storage
          .from('restaurant')
          .upload(imagePath, imageFile, fileOptions: FileOptions(
        contentType: 'image/$imageExt',
        upsert: false,
      ));

      final imageUrl = _supabase.storage
          .from('restaurant')
          .getPublicUrl(imagePath);

      // Save restaurant
      final restaurantResponse = await _supabase
          .from('restaurants')
          .insert({
        'res.name': _nameController.text,
        'location.url': locationUrl,
        'image.url': imageUrl,
      })
          .select();

      if (restaurantResponse.isEmpty) throw Exception("Failed to create restaurant");

      // Save menu items
      for (var item in _menuItems) {
        if (item['item']?.isNotEmpty ?? false) {
          await _supabase.from('restaurants').update({
            'item': item['item'],
            'price': item['price'] ?? '',
          }).eq('id', restaurantResponse.first['id']);
        }
      }

      widget.onSubmit(true, "Restaurant added successfully!");
    } catch (e) {
      widget.onSubmit(false, "Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add New Restaurant",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Image Picker
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_image!.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Pick Restaurant Image"),
            ),
            const SizedBox(height: 20),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Restaurant Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
              value?.isEmpty ?? true ? "Name is required" : null,
            ),
            const SizedBox(height: 16),

            // Location URL Field
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: "Google Maps URL",
                hintText: "https://maps.app.goo.gl/... or https://goo.gl/maps/...",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return "Map URL is required";
                if (!_isValidMapUrl(value!)) {
                  return "Please enter a valid Google Maps or Apple Maps URL";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Menu Items Section
            Text(
              "Menu Items",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Menu Items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Item Name",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) =>
                            _menuItems[index]["item"] = value,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Price",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                            _menuItems[index]["price"] = value,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),

            // Add Menu Item Button
            ElevatedButton(
              onPressed: _addMenuItem,
              child: const Text("Add Menu Item"),
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                "Submit Restaurant",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}