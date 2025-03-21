import 'package:flutter/material.dart';

class MealReviewScreen extends StatefulWidget {
  final Function(bool) onSubmit;

  const MealReviewScreen({super.key, required this.onSubmit});

  @override
  _MealReviewScreenState createState() => _MealReviewScreenState();
}

class _MealReviewScreenState extends State<MealReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  int _rating = 0; // Track the selected rating

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
            "Add New Meal Review",
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

          // Remark Field
          TextField(
            controller: _remarkController,
            decoration: InputDecoration(
              labelText: "Remark",
              border: OutlineInputBorder(),
            ),
            maxLines: 3, // Slightly bigger text area
          ),
          const SizedBox(height: 10),

          // Rating Section
          Text(
            "Rating",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color: index < _rating ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1; // Update the rating
                  });
                },
              );
            }),
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