import 'package:flutter/material.dart';

import '../../../constants.dart';

class SquareCheckboxItem extends StatelessWidget {
  const SquareCheckboxItem({
    super.key,
    this.isActive = false,
    required this.press,
    required this.text,
  });

  final bool isActive;
  final VoidCallback press;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SquareCheckBox(isActive: isActive),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: titleColor.withOpacity(0.84), height: 1),
                )
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class SquareCheckBox extends StatelessWidget {
  const SquareCheckBox({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kDefaultDuration,
      height: 24,
      width: 24,
      padding: EdgeInsets.all(isActive ? 3 : 12),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: isActive
              ? primaryColor.withOpacity(0.54)
              : const Color(0xFF868686).withOpacity(0.54),
          width: 0.8,
        ),
      ),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
