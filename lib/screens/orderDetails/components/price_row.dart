import 'package:flutter/material.dart';

import '../../../constants.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.text,
    required this.price,
  });

  final String text;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(children: [
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(color: titleColor),
          ),
        ]),
        Flexible(
          child:
          Text(
            price,
            style: const TextStyle(color: titleColor),
          )
        )
      ],
    );
  }
}
