import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';
import '../providers/widget_provider.dart';

class DirectShareScreen extends StatefulWidget {
  const DirectShareScreen({super.key});

  @override
  State<DirectShareScreen> createState() => _DirectShareScreenState();
}

class _DirectShareScreenState extends State<DirectShareScreen> {
  final List<String> _selectedFriends = [];
  String? _selectedPhoto;

  @override
  Widget build(BuildContext context) {
    final friendProvider = Provider.of<FriendProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Share'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _selectedFriends.isEmpty ? null : () {
              // Share logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Shared with ${_selectedFriends.length} friends'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            child: Text(
              'Send',
              style: TextStyle(
                color: _selectedFriends.isEmpty
                    ? Colors.grey
                    : const Color(0xFF64B5F6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Selected photos preview
          if (_selectedPhoto != null)
            Container(
              height: 100,
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF64B5F6),
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(_selectedPhoto!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Friends list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'CLOSE FRIENDS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ...friendProvider.closeFriends.map((friend) => _buildFriendSelector(friend.name)),
                const SizedBox(height: 24),
                const Text(
                  'ALL FRIENDS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ...friendProvider.allFriends
                    .where((f) => !friendProvider.closeFriends.contains(f))
                    .map((friend) => _buildFriendSelector(friend.name)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedFriends.isEmpty
                    ? 'Select friends to share with'
                    : 'Sharing with ${_selectedFriends.length} ${_selectedFriends.length == 1 ? 'friend' : 'friends'}',
                style: TextStyle(
                  color: _selectedFriends.isEmpty ? Colors.grey : const Color(0xFF2C3E50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendSelector(String name) {
    final isSelected = _selectedFriends.contains(name);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF64B5F6)
              : Colors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedFriends.remove(name);
            } else {
              _selectedFriends.add(name);
            }
          });
        },
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF64B5F6)
                      : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  name[0],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? const Color(0xFF64B5F6)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF64B5F6),
              ),
          ],
        ),
      ),
    );
  }
}