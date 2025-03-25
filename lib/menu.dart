import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final SupabaseClient supabase;

  MenuScreen({Key? key, required this.restaurant})
      : supabase = Supabase.instance.client,
        super(key: key);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Restaurant Menu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.brown[700],
                  fontWeight: FontWeight.bold,
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
          FutureBuilder<List<Map<String, dynamic>>>(
            future: supabase
                .from('restaurants')
                .select('item, price')
                .eq('id', restaurant['id'] ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.brown),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        'Failed to load menu',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final menuItems = snapshot.data ?? [];

              if (menuItems.isEmpty) {
                return Center(
                  child: Text(
                    'No menu items available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.brown[400],
                    ),
                  ),
                );
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['item']?.toString() ?? 'Item',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                              item['price']?.toString() ?? 'Price',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.brown[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}