import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Event QR Code'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              if (_isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  setState(() => _isProcessing = true);
                  await _joinEventWithCode(code, context);
                  break;
                }
              }
            },
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 4),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(100),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Align QR code within the frame',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _joinEventWithCode(String code, BuildContext context) async {
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
        setState(() => _isProcessing = false);
        return;
      }

      final user = _supabase.auth.currentUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
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
      setState(() => _isProcessing = false);
    }
  }
}