import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventCodeInputScreen extends StatefulWidget {
  const EventCodeInputScreen({super.key});

  @override
  State<EventCodeInputScreen> createState() => _EventCodeInputScreenState();
}

class _EventCodeInputScreenState extends State<EventCodeInputScreen> {
  final TextEditingController _codeController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;

  Future<void> _joinEvent() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an event code')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if event exists
      final event = await _supabase
          .from('events')
          .select()
          .eq('event_code', code)
          .maybeSingle();

      if (event == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event not found'), backgroundColor: Colors.red),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final user = _supabase.auth.currentUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // Check if event has expired
      if (event['expires_at'] != null) {
        final expiryDate = DateTime.parse(event['expires_at']);
        if (expiryDate.isBefore(DateTime.now())) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This event has expired'), backgroundColor: Colors.red),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      // Check if user is already in event
      final existingMember = await _supabase
          .from('event_members')
          .select()
          .eq('event_id', event['id'])
          .eq('user_id', user.id)
          .maybeSingle();

      if (existingMember == null) {
        // Add user to event
        await _supabase.from('event_members').insert({
          'event_id': event['id'],
          'user_id': user.id,
          'joined_at': DateTime.now().toIso8601String(),
        });
      }

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/camera',
          arguments: {
            'eventId': event['id'],
            'eventCode': event['event_code'],
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1BE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Join Event',
          style: TextStyle(color: Colors.brown),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.brown,
            ),
            const SizedBox(height: 40),
            const Text(
              'Enter Event Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: 'XXXXXX',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading ? null : _joinEvent,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Join Event',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.brown[300]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: TextStyle(color: Colors.brown[600]),
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.brown[300]),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/qr_scanner');
              },
              icon: const Icon(Icons.qr_code_scanner, color: Colors.brown),
              label: const Text(
                'Scan QR Code',
                style: TextStyle(color: Colors.brown, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_event');
              },
              child: const Text(
                'Create New Event',
                style: TextStyle(color: Colors.brown, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}