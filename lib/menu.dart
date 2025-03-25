import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'name': 'Shawarma Plate', 'price': '850 Ksh'},
    {'name': 'Beef Burger', 'price': '650 Ksh'},
    {'name': 'Chicken Wings', 'price': '750 Ksh'},
    {'name': 'French Fries', 'price': '350 Ksh'},
    {'name': 'Vegetable Salad', 'price': '450 Ksh'},
    {'name': 'Soft Drinks', 'price': '150 Ksh'},
    {'name': 'Mineral Water', 'price': '100 Ksh'},
    {'name': 'Fruit Juice', 'price': '250 Ksh'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Restaurant Menu',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.brown),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: Colors.brown, thickness: 1),
          const SizedBox(height: 10),

          // Menu Items List
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          menuItems[index]['name'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          menuItems[index]['price'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );;
  }
}
