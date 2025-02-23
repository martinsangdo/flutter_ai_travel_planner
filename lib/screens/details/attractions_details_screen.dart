import 'package:ai_travel_planner/functions.dart';
import 'package:ai_travel_planner/screens/details/components/attraction_tab_items.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/attraction_photos.dart';
import 'components/tab_items.dart';
import 'components/attraction_info.dart';

class AttractionDetailsScreen extends StatefulWidget {
  int? trip_id;  //default for testing
  int? city_id;
  String currency;
  String name;

  AttractionDetailsScreen({super.key, this.trip_id, this.city_id,
  required this.name, required this.currency});

  @override
  State<AttractionDetailsScreen> createState() =>
      _State();
}

class _State extends State<AttractionDetailsScreen> {
  List<String> _photoUrls = [];
  Map _things2DoNEat = {};

  //find all details of 1 place
  Map findAttractionDetails(intAttractionId){
    Map finalResult = {};

    //get tour details https://uk.trip.com/restapi/soa2/21052/getProductInfo

    //4. related places (https://uk.trip.com/restapi/soa2/18762/getInternalLinkModuleList)

    //(What to eat) https://www.trip.com/restapi/soa2/23044/getDestinationPageInfo.json
    //2. list of reviews https://uk.trip.com/restapi/soa2/19707/getReviewSearch (with photos)

    //recommend cities: saved in db with random cities in a country

    return finalResult;
  }
  //call another service to get attraction details
  _fetchAttractionDetails() async{
    if (widget.trip_id! <= 0 && widget.city_id! <= 0){
      return;
    }
    //1. get image list
    List<String> photoUrls = await getAttractionPhotos(widget.trip_id);
    setState(() {
      _photoUrls = photoUrls;
    });
    //2. get tours (things to do) & restaurants
    Map things2DoNEat = await getAttractionThings2EatNVisit(widget.city_id, widget.currency);
    debugPrint(things2DoNEat['places2Visit'][0].toString());
    setState(() {
      _things2DoNEat = things2DoNEat;
    });
  }
  //
  @override
  void initState() {
    super.initState();
    _fetchAttractionDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding / 2),
              AttractionInfo(name: widget.name), //general info
              const SizedBox(height: defaultPadding),
              AttractionPhotos(photoUrls: _photoUrls,),  //photo list
              const SizedBox(height: defaultPadding),
              AttractionTabItems(things2DoNEat: _things2DoNEat,)
            ],
          ),
        ),
      ),
    );
  }
}
