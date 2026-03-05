import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class NewMealScreen extends StatefulWidget {
  final Function(bool) onSubmit;

  const NewMealScreen({super.key, required this.onSubmit});

  @override
  _NewMealScreenState createState() => _NewMealScreenState();
}

class _NewMealScreenState extends State<NewMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseClient supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isUploading = false;
  String? _selectedCategory;
  final List<String> _categories = [
    "Drinks",
    "Meals",
    "Snacks",
    "Combo Meals"
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(_imageFile!.path);
      final fileExt = _imageFile!.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      await supabase.storage
          .from('meals')
          .upload(filePath, file);

      return supabase.storage
          .from('meals')
          .getPublicUrl(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _insertIntoCategoryTable() async {
    if (_selectedCategory == null) return;

    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0;
    final description = _descriptionController.text;
    final imageUrl = await _uploadImage();

    try {
      switch (_selectedCategory) {
        case "Drinks":
          await supabase.from('drinks').insert({
            'drinks_name': name,
            'drinks_price': price,
            'drinks_desc': description,
            'image.url': imageUrl,
            'location.url': _locationController.text,
            'created_at': DateTime.now().toIso8601String(),
          });
          break;
        case "Meals":
          await supabase.from('food').insert({
            'food_name': name,
            'food_price': price,
            'food_desc': description,
            'image.url': imageUrl,
            'location.url': _locationController.text,
            'created_at': DateTime.now().toIso8601String(),
          });
          break;
        case "Snacks":
          await supabase.from('snacks').insert({
            'snacks_name': name,
            'snacks_price': price,
            'snacks_desc': description,
            'image.url': imageUrl,
            'location.url': _locationController.text,
            'created_at': DateTime.now().toIso8601String(),
          });
          break;
        case "Combo Meals":
          await supabase.from('combo').insert({
            'combo_name': name,
            'combo_price': price,
            'combo_desc': description,
            'image.url': imageUrl,
            'location.url': _locationController.text,
            'created_at': DateTime.now().toIso8601String(),
          });
          break;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to category table: $e')),
      );
      rethrow;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a category')),
      );
      return;
    }

    try {
      final imageUrl = await _uploadImage();

      // Insert into meals table
      await supabase.from('meals').insert({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'desc': _descriptionController.text,
        'image.url': imageUrl,
        'location.url': _locationController.text,
        'category': _selectedCategory,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Insert into specific category table
      await _insertIntoCategoryTable();

      widget.onSubmit(true);
    } catch (e) {
      widget.onSubmit(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add meal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              validator: (value) => value == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price (Ksh)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location URL',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? Image.file(File(_imageFile!.path), fit: BoxFit.cover)
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 50),
                    Text('Add Meal Photo'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _submitForm,
              child: _isUploading
                  ? CircularProgressIndicator()
                  : Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}