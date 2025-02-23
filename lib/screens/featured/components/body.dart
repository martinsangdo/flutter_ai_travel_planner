import 'package:flutter/material.dart';
import '../../../components/cards/big/info_big_card.dart';
import '../../../components/scalton/big_card_scalton.dart';
import '../../../constants.dart';

//Show in list screen
class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> _imgList = [];
  bool isLoading = true;
  int demoDataLength = 4;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: ListView.builder(
          // while we dont have our data bydefault we show 3 scalton
          itemCount: isLoading ? 3 : demoDataLength,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: isLoading
                ? const BigCardScalton()
                : InfoBigCard(
                    images: _imgList..shuffle(),
                    name: "McDonald's",
                    rating: 4.3,
                    reviewCount: '33,444',
                    attractionCount: '888',
                    subList: const ["Westminster Abbey", "Buckingham Place", "London Eye"],
                    press: () {},
                  ),
          ),
        ),
      ),
    );
  }
}
