import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  final Widget header;
  final Widget content;
  final bool initialExpanded; // Add this line

  const ExpandableWidget({
    super.key,
    required this.header,
    required this.content,
    this.initialExpanded = false, // Initialize to false by default
  });

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactor = _animationController.drive(CurveTween(curve: Curves.ease));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This code runs AFTER the first frame is built.
      if (widget.initialExpanded) { // If you have an initialExpanded property
        _animationController.forward();
        _isExpanded = true;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      //debugPrint(_isExpanded.toString());
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell( // Makes the header tappable
          onTap: _toggleExpand,
          child: widget.header,
        ),
        ClipRect( // Prevents content from overflowing during animation
          child: Align(
            alignment: Alignment.centerLeft, // Or any alignment you prefer
            heightFactor: _heightFactor.value,
            child: widget.content,
          ),
        ),
      ],
    );
  }
}