import 'package:flutter/material.dart';

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

  void _submit() {
    // Simulate submission logic
    bool success = true; // Replace with actual submission logic
    widget.onSubmit(success); // Notify the parent about the submission result
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
    );
  }
}