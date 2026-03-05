import 'dart:async';
import 'package:flutter/material.dart';

class EventTimer extends StatefulWidget {
  final DateTime expiryTime;
  final VoidCallback onExpire;

  const EventTimer({
    super.key,
    required this.expiryTime,
    required this.onExpire,
  });

  @override
  State<EventTimer> createState() => _EventTimerState();
}

class _EventTimerState extends State<EventTimer> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeLeft();
      if (_timeLeft.isNegative) {
        timer.cancel();
        widget.onExpire();
      }
    });
  }

  void _updateTimeLeft() {
    setState(() {
      _timeLeft = widget.expiryTime.difference(DateTime.now());
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return 'Expired';

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = _timeLeft.isNegative;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isExpired ? Colors.red : Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.timer_off : Icons.timer,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            isExpired ? 'Expired' : _formatDuration(_timeLeft),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}