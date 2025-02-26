import 'package:flutter/material.dart';

import '../../../components/cards/medium/info_medium_card.dart';
import '../../../components/scalton/medium_card_scalton.dart';
import '../../../constants.dart';
import '../../details/city_details_screen.dart';

class MediumCardList extends StatefulWidget {
  List dataList =[];  //list of items to display

  MediumCardList({super.key, required this.dataList});

  @override
  State<MediumCardList> createState() => _MediumCardListState();
}

class _MediumCardListState extends State<MediumCardList> {
  bool isLoading = true;
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
    List _dataList = [];
    if (widget.dataList.isNotEmpty){
      _dataList = widget.dataList..shuffle();
    }
    // only for demo
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SizedBox(
            width: double.infinity,
            height: 254,
            child: isLoading
                ? buildFeaturedPartnersLoadingIndicator()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: (_dataList.length - 1) == index ? defaultPadding : 0,
                      ),
                      child: InfoMediumCard(
                        image: _dataList[index]['img'],
                        name: _dataList[index]['name'],
                        location: _dataList[index]['country'],
                        reviewCount: formatNumberWithCommas(_dataList[index]['review']),
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CityDetailsScreen(cityInfo: {}),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
      ],
    );
  }

  SingleChildScrollView buildFeaturedPartnersLoadingIndicator() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          2,
          (index) => const Padding(
            padding: EdgeInsets.only(left: defaultPadding),
            child: MediumCardScalton(),
          ),
        ),
      ),
    );
  }
}
