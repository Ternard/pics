import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class NewRestaurantScreen extends StatefulWidget {
  final Function(bool, String?) onSubmit;

  const NewRestaurantScreen({
    super.key,
    required this.onSubmit,
  });

  @override
  State<NewRestaurantScreen> createState() => _NewRestaurantScreenState();
}

class _NewRestaurantScreenState extends State<NewRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<Map<String, String>> _menuItems = [];
  XFile? _image;
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = false;

  bool _isValidMapUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return uri.host.contains('google.com/maps') ||
        uri.host.contains('maps.apple.com') ||
        uri.host.contains('openstreetmap.org') ||
        uri.host.contains('maps.app.goo.gl');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      widget.onSubmit(false, "Restaurant image is required");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Validate location URL
      final locationUrl = _locationController.text;
      if (!_isValidMapUrl(locationUrl)) {
        throw Exception('Please enter a valid Google Maps or Apple Maps URL');
      }

      // Upload image (public bucket doesn't require auth)
      final imageFile = File(_image!.path);
      final imageExt = _image!.path.split('.').last;
      final imageName = 'restaurants/${DateTime.now().millisecondsSinceEpoch}.$imageExt';

      await supabase.storage
          .from('restaurant')
          .upload(imageName, imageFile, fileOptions: FileOptions(
        contentType: 'image/$imageExt',
        upsert: false,
      ));

      final imageUrl = supabase.storage
          .from('restaurant')
          .getPublicUrl(imageName);

      // Insert restaurant (no auth required)
      final restaurantResponse = await supabase
          .from('restaurants')
          .insert({
        'res.name': _nameController.text,
        'location.url': locationUrl,
        'image.url': imageUrl,
        'owner_id': null, // No owner since no auth
      }).select();

      if (restaurantResponse.isEmpty) {
        throw Exception('Failed to create restaurant');
      }

      // Save menu items
      for (var item in _menuItems) {
        if (item['item']?.isNotEmpty ?? false) {
          await supabase.from('menu_items').insert({
            'restaurant_id': restaurantResponse.first['id'],
            'name': item['item'],
            'price': item['price'] ?? '',
          });
        }
      }

      widget.onSubmit(true, "Restaurant added successfully!");
    } catch (e) {
      widget.onSubmit(false, "Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = pickedFile);
    }
  }

  void _addMenuItem() {
    setState(() {
      _menuItems.add({'item': '', 'price': ''});
    });
  }

  void _removeMenuItem(int index) {
    setState(() {
      _menuItems.removeAt(index);
    });
  }

  void _updateMenuItem(int index, String field, String value) {
    setState(() {
      _menuItems[index][field] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Restaurant Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a restaurant name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Google Maps/Apple Maps URL',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a map URL';
                }
                if (!_isValidMapUrl(value)) {
                  return 'Please enter a valid Google Maps or Apple Maps URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _image == null
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40),
                      Text('Add Restaurant Image'),
                    ],
                  ),
                )
                    : Image.file(File(_image!.path)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Menu Items', style: TextStyle(fontSize: 16)),
            ..._menuItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: item['item'],
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _updateMenuItem(index, 'item', value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: item['price'],
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _updateMenuItem(index, 'price', value),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeMenuItem(index),
                    ),
                  ],
                ),
              );
            }).toList(),
            TextButton(
              onPressed: _addMenuItem,
              child: const Text('+ Add Menu Item'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
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