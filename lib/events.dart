import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'new_event.dart'; // renamed from new_meal.dart
import 'package:qr_flutter/qr_flutter.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDurationController = TextEditingController();
  bool _isCreating = false;
  List<Map<String, dynamic>> _myEvents = [];

  @override
  void initState() {
    super.initState();
    _loadMyEvents();
  }

  Future<void> _loadMyEvents() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final events = await supabase
          .from('event_members')
          .select('events(*)')
          .eq('user_id', user.id)
          .order('joined_at', ascending: false);

      if (mounted) {
        setState(() {
          _myEvents = events.map((e) => e['events'] as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
    }
  }

  String _generateEventCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[(random + i) % chars.length];
    }
    return code;
  }

  Future<void> _createEvent() async {
    if (_eventNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter event name')),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Not logged in');

      final eventCode = _generateEventCode();

      // Parse duration (in hours)
      int durationHours = 24; // default
      if (_eventDurationController.text.isNotEmpty) {
        durationHours = int.tryParse(_eventDurationController.text) ?? 24;
      }

      final expiryDate = DateTime.now().add(Duration(hours: durationHours));

      // Create event
      final eventResponse = await supabase.from('events').insert({
        'name': _eventNameController.text,
        'event_code': eventCode,
        'created_by': user.id,
        'created_at': DateTime.now().toIso8601String(),
        'expires_at': expiryDate.toIso8601String(),
        'is_permanent': durationHours == 0,
      }).select();

      if (eventResponse.isEmpty) throw Exception('Failed to create event');

      final eventId = eventResponse.first['id'];

      // Add creator as member
      await supabase.from('event_members').insert({
        'event_id': eventId,
        'user_id': user.id,
        'joined_at': DateTime.now().toIso8601String(),
        'is_admin': true,
      });

      if (mounted) {
        _loadMyEvents();
        _showEventCodeDialog(eventCode, eventId);
        _eventNameController.clear();
        _eventDurationController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating event: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  void _showEventCodeDialog(String code, String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Created!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with friends:'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: Colors.brown,
                ),
              ),
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: code,
              version: QrVersions.auto,
              size: 150,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/camera',
                arguments: {
                  'eventId': eventId,
                  'eventCode': code,
                },
              );
            },
            child: const Text('Start Event'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Create event form
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF5DEB3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create New Event',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _eventNameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _eventDurationController,
                  decoration: InputDecoration(
                    labelText: 'Duration (hours, 0 = permanent)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                    ),
                    onPressed: _isCreating ? null : _createEvent,
                    child: _isCreating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Event', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          // My events list
          Expanded(
            child: _myEvents.isEmpty
                ? const Center(
              child: Text('No events yet. Create or join one!'),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _myEvents.length,
              itemBuilder: (context, index) {
                final event = _myEvents[index];
                final expiry = event['expires_at'] != null
                    ? DateTime.parse(event['expires_at'])
                    : null;
                final isExpired = expiry != null && expiry.isBefore(DateTime.now());

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isExpired ? Colors.grey : Colors.brown,
                      child: Icon(
                        isExpired ? Icons.timer_off : Icons.event,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(event['name'] ?? 'Unnamed Event'),
                    subtitle: Text('Code: ${event['event_code'] ?? 'N/A'}'),
                    trailing: isExpired
                        ? const Text('Expired', style: TextStyle(color: Colors.red))
                        : IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.brown),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/camera',
                          arguments: {
                            'eventId': event['id'],
                            'eventCode': event['event_code'],
                          },
                        );
                      },
                    ),
                    onTap: () {
                      if (!isExpired) {
                        Navigator.pushNamed(
                          context,
                          '/gallery',
                          arguments: {'eventId': event['id']},
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5E1BE),
        selectedItemColor: Colors.brown[700],
        unselectedItemColor: Colors.brown[400],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/join_event');
              break;
            case 2:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Join'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}