import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';

class CloseFriendsScreen extends StatefulWidget {
  const CloseFriendsScreen({super.key});

  @override
  State<CloseFriendsScreen> createState() => _CloseFriendsScreenState();
}

class _CloseFriendsScreenState extends State<CloseFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final friendProvider = Provider.of<FriendProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Close Friends'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF64B5F6).withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search friends...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF64B5F6)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
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
                ...friendProvider.closeFriends.map((friend) => _buildFriendTile(
                  name: friend.name,
                  isCloseFriend: true,
                  onToggle: () {},
                )),
                const SizedBox(height: 24),
                const Text(
                  'SUGGESTIONS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ...friendProvider.allFriends
                    .where((f) => !friendProvider.closeFriends.contains(f))
                    .map((friend) => _buildFriendTile(
                  name: friend.name,
                  isCloseFriend: false,
                  onToggle: () {},
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendTile({
    required String name,
    required bool isCloseFriend,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCloseFriend
              ? const Color(0xFF64B5F6).withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCloseFriend
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
                  color: isCloseFriend
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
          Switch(
            value: isCloseFriend,
            onChanged: (value) => onToggle(),
            activeColor: const Color(0xFF64B5F6),
          ),
        ],
      ),
    );
  }
}