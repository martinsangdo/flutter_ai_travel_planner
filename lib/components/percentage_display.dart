import 'dart:async';

import 'package:flutter/material.dart';

class PercentageDisplay extends StatefulWidget {
  const PercentageDisplay({super.key});

  @override
  State<PercentageDisplay> createState() => _PercentageDisplayState();
}

class _PercentageDisplayState extends State<PercentageDisplay> {
  double _percentage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _percentage = 0; // Reset percentage before starting a new animation.
    
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        _percentage += 1; // Increment by 1 for smoother animation
        if (_percentage > 100) {
          _timer.cancel(); // Stop when 100% is reached
          _percentage = 100; // Ensure it stops at exactly 100
          debugPrint('Timer stopped');
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    debugPrint('Timer stopped');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center( // Center the text
      child: Text(
        '${_percentage.toStringAsFixed(0)}%', // Display as integer percentage
        style: const TextStyle(fontSize: 14), // Adjust font size as needed
      ),
    );
  }
}