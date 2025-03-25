import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantReviewScreen extends StatefulWidget {
  final Function(bool, String?) onSubmit;

  const RestaurantReviewScreen({super.key, required this.onSubmit});

  @override
  _RestaurantReviewScreenState createState() => _RestaurantReviewScreenState();
}

class _RestaurantReviewScreenState extends State<RestaurantReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  int _rating = 0;
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_nameController.text.isEmpty) {
      widget.onSubmit(false, "Name is required");
      return;
    }

    if (_rating == 0) {
      widget.onSubmit(false, "Please select a rating");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _supabase.from('reviews').insert({
        'reviewer_name': _nameController.text,
        'remark': _remarkController.text,
        'rating': _rating,
        'created_at': DateTime.now().toIso8601String(),
      });

      widget.onSubmit(true, "Review submitted successfully!");
    } catch (e) {
      widget.onSubmit(false, "Failed to submit review: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          Text(
            "Add New Restaurant Review",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _remarkController,
            decoration: InputDecoration(
              labelText: "Remark",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),

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
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}