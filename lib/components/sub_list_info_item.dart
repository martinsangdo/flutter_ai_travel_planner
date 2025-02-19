import 'package:flutter/material.dart';
import '../components/small_dot.dart';

import '../constants.dart';
//used in the slider of homepage
class SubListInfoItem extends StatelessWidget {
  const SubListInfoItem({
    super.key,
    required this.subList,
  });

  final List<String> subList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          subList.length,
          (index) => Row(
            children: [
              buildSmallDot(),
              Text(subList[index],
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildSmallDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      child: SmallDot(),
    );
  }
}
