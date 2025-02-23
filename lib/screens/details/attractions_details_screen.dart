import 'package:ai_travel_planner/functions.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/attraction_photos.dart';
import 'components/tab_items.dart';
import 'components/attraction_info.dart';

class AttractionDetailsScreen extends StatefulWidget {
  int trip_id;  //default for testing
  String name;

  AttractionDetailsScreen({super.key, required this.trip_id, required this.name});

  @override
  State<AttractionDetailsScreen> createState() =>
      _State();
}

class _State extends State<AttractionDetailsScreen> {
  List<String> _photoUrls = [];

  //find all details of 1 place
  Map findAttractionDetails(intAttractionId){
    Map finalResult = {};
    //1.1 image list https://uk.trip.com/restapi/soa2/18066/searchMomentList
    
    //2. list of reviews https://uk.trip.com/restapi/soa2/19707/getReviewSearch (with photos)

    //(Things to do) day tours https://uk.trip.com/restapi/soa2/14580/json/getCrossRecommendProduct

    //get tour details https://uk.trip.com/restapi/soa2/21052/getProductInfo

    //4. related places (https://uk.trip.com/restapi/soa2/18762/getInternalLinkModuleList)

    //(What to eat) https://www.trip.com/restapi/soa2/23044/getDestinationPageInfo.json

    //recommend cities: saved in db with cities in a country

    return finalResult;
  }
  //call another service to get attraction details
  _fetchAttractionDetails() async{
    if (widget.trip_id == null || widget.trip_id! <= 0){
      return;
    }
    //1. get image list
    List<String> photoUrls = await getAttractionPhotos(widget.trip_id);
    setState(() {
      _photoUrls = photoUrls;
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
            ],
          ),
        ),
      ),
    );
  }
}
