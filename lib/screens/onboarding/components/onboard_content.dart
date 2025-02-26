import 'package:ai_travel_planner/components/percentage_display.dart';
import 'package:flutter/material.dart';

class OnboardContent extends StatefulWidget {
  int duration = 100; //default is changing every 100 millisecs
  final String illustration;

  OnboardContent({
    super.key,
    required this.illustration,
    required this.duration
  });

  @override
  State<OnboardContent> createState() => _State();
}

class _State extends State<OnboardContent> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(widget.illustration),
          ),
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 8),
        PercentageDisplay(duration: widget.duration,)
      ],
    );
  }
}
