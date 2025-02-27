import 'dart:convert';

import 'package:ai_travel_planner/screens/details/attractions_details_screen.dart';
import 'package:ai_travel_planner/screens/photo_gallery_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

//used to show hotel or attractions in city detail page (tab region)
class ItemCard extends StatefulWidget {
  ItemCard({
    super.key,
    required this.title,
    required this.image,
    required this.itemType, //attraction, hotel, thing to do, etc.
    this.description,
    this.price,
    this.url,
    this.rating,
    this.duration,
    this.trip_id, ///attraction
    this.currency,
    this.reviews,
    this.commentNum
  });

  final String? title, description, image, url, price, currency, reviews, commentNum;
  final int? duration, trip_id;
  final double? rating;
  String itemType;

  @override
  State<ItemCard> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<ItemCard> {
  bool _isGettingPhotos = false;

  @override
  void initState() {
      super.initState();
  } 

  @override
  void dispose() {
    super.dispose();
  }
  //depend on which tab, we process when user clicks on each item
  _processItemClicked() async{
    if (widget.url != null && widget.itemType == 'hotel'){
      //open new web browser
      if (!await launchUrlString(widget.url!, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $widget.url');
      }
    } else if (widget.itemType == 'attraction' || widget.itemType == 'restaurant'){
      _getGalleryAttraction();
    }
  }
  //get photos of this attraction to show in Gallery
  _getGalleryAttraction() async{
    if (_isGettingPhotos){
      return; //you must wait
    }
    setState(() {
      _isGettingPhotos = true;  //lock multiple tap
    });
    List finalList = [];
    String attractionPhotosUri = glb_trip_uri + GET_GALLERY_ATTRACTION;
    final response = await http.Client().post(Uri.parse(attractionPhotosUri), 
        headers: COMMON_HEADER, body: jsonEncode({
          "head": {
              "locale": "en-US",
              "extension": [
                  {
                      "name": "locale",
                      "value": "en-US"
                  },
                  {
                      "name": "platform",
                      "value": "Online"
                  },
                  {
                      "name": "currency",
                      "value": "USD"
                  },
                  {
                      "name": "user-agent",
                      "value": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36"
                  }
              ]
          },
          "poiId": widget.trip_id,
          "index": 1,
          "count": 50
      }));
    setState(() {
      _isGettingPhotos = false;
    });
    if (response.statusCode != 200){
      debugPrint('Cannot get content from cloud');
    } else {
      Map<String, dynamic> objFromCloud = jsonDecode(response.body);
      if (objFromCloud['recommendPhoto'] != null && objFromCloud['recommendPhoto']['photoList'] != null){
        List<String> imgList = [];
        for (Map photo in objFromCloud['recommendPhoto']['photoList']){
          imgList.add(photo['imageUrl']);
        }
        if (imgList.isNotEmpty){
          Navigator.push(
              context,
                        MaterialPageRoute(
                          builder: (context) => 
                          PhotoGalleryFullscreen(
                            imageUrls: imgList
                          ),
              ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: titleColor.withOpacity(0.64),
          fontWeight: FontWeight.normal,
        );
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: _processItemClicked,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    widget.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title!,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14),
                    ),
                    Text(
                      widget.description??'',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        if (widget.rating != null && widget.rating! > 0)...[
                          SvgPicture.asset(
                            "assets/icons/rating.svg",
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                              primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("Rating: "+widget.rating.toString(), style: const TextStyle(color: Colors.black),),
                        ],//end rating
                        if (widget.duration != null && widget.duration! > 0)...[
                          SvgPicture.asset(
                            "assets/icons/clock.svg",
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                              primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.duration.toString() + " min", style: const TextStyle(color: Colors.black),),
                        ],//end duration
                        if (widget.reviews != null)...[
                          SvgPicture.asset(
                            "assets/icons/profile.svg",
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                              primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.reviews!, style: const TextStyle(color: Colors.black),),
                        ],//end reviews
                        if (widget.commentNum != null && widget.commentNum != '')...[
                          SvgPicture.asset(
                            "assets/icons/profile.svg",
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                              primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${widget.commentNum} comments', style: const TextStyle(color: Colors.black),),
                        ],//end comment num
                        const Spacer(),
                        Text(
                          widget.price??'',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: primaryColor),
                        ) //end price
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
