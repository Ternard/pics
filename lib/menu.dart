import 'package:flutter/material.dart';

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

  void _addMenuItem() {
    setState(() {
      _menuItems.add({"item": "", "price": ""});
    });
  }

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
            "Add New Restaurant",
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