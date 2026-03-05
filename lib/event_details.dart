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
                restaurant['res.name'] ?? 'Restaurant Menu',
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
            future: _fetchMenuItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.brown),
                );
              }

              if (snapshot.hasError) {
                return _buildErrorState(context, snapshot.error.toString());
              }

              final menuItems = snapshot.data ?? [];

              if (menuItems.isEmpty) {
                return _buildEmptyState(context);
              }

              return _buildMenuList(context, menuItems);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchMenuItems() async {
    try {
      final response = await supabase
          .from('menu_items')
          .select('item, price')
          .eq('res_id', restaurant['id'] ?? '')
          .order('item');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load menu: ${e.toString()}');
    }
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          Text(
            'Failed to load menu',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              (context as Element).markNeedsBuild();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book, size: 50, color: Colors.brown),
          const SizedBox(height: 16),
          Text(
            'No menu items available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Check back later or contact the restaurant',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, List<Map<String, dynamic>> menuItems) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['item']?.toString() ?? 'Unnamed Item',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.brown[800],
                        fontWeight: FontWeight.bold,
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
                      '\Ksh ${item['price']?.toString() ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.brown[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}