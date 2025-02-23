import 'dart:convert';

import 'package:ai_travel_planner/db/database_helper.dart';
import 'package:flutter/material.dart';

import '../../components/cards/big/big_card_image_slide.dart';
import '../../components/cards/big/info_big_card.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import '../details/city_details_screen.dart';
import '../featured/featurred_screen.dart';
import 'components/medium_card_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<String> _homeSliderImages = [];
  Map _topBannerInfo = {};

  _loadHomeCities(){
    //load banner
    _loadBanner(glb_home_cities['top_banner']);
    for (String key in glb_home_cities.keys.toList()){
      //debugPrint(key.toString());
      
    }
  }
  //get images of top banner
  _loadBanner(city_uuid) async{
    final dbData = await DatabaseHelper.instance.rawQuery("SELECT * FROM tb_city WHERE uuid='"+city_uuid+"'", []);
    if (dbData.isNotEmpty){
      //debugPrint(dbData[0].toString());
      setState(() {
        List<dynamic> imgUrls = jsonDecode(dbData[0]['imgUrls']);
        List<String> imgList = [];
        for (dynamic imgUrl in imgUrls){
          imgList.add(imgUrl);
        }
        _homeSliderImages = imgList;
        //
        _topBannerInfo = {
          "wonder_id": dbData[0]['wonder_id'],
          "cache_trip_date": dbData[0]['cache_trip_date'],
          "wonder_trip_id": dbData[0]['wonder_trip_id']
        };
        //
        _isLoading = false;
      });
    } else {
      //no city in top banner
    }
  }
  //user pressed the top banner
  _pressedTopBanner(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetailsScreen(tripInfo: _topBannerInfo),
      ),
    );
  }

  @override
  void initState() {
      super.initState();
      _loadHomeCities();
  } 

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                "Explore".toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: primaryColor),
              ),
              const Text(
                "Top destinations",
                style: TextStyle(color: Colors.black),
              )
            ],
          )
        )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              const SizedBox(height: defaultPadding),
              //part 1 (top banner)
              InkWell(
                onTap: () {
                  _pressedTopBanner();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: BigCardImageSlide(images: _homeSliderImages),  //main slider
                )
              ),
              const SizedBox(height: defaultPadding * 2),
              //part 2
              SectionTitle(
                title: "Europe",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(), //list
              const SizedBox(height: defaultPadding),
              //part 3
              SectionTitle(
                title: "America",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(),
              const SizedBox(height: defaultPadding),
              //part 4
              SectionTitle(title: "Random pick", press: () {}),
              const SizedBox(height: defaultPadding),
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      defaultPadding, 0, defaultPadding, defaultPadding),
                  child: InfoBigCard(
                    images: _homeSliderImages..shuffle(),
                    name: "Paris",
                    rating: 4.3,
                    reviewCount: '99,999',
                    attractionCount: '345',
                    subList: const ["London Eye", "Tower Bridge", "River Thames"],
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityDetailsScreen(tripInfo: {}),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: defaultPadding),
              //part 5
              SectionTitle(
                title: "Australia",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(),
              const SizedBox(height: defaultPadding),
              //part 6
              SectionTitle(
                title: "Africa",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
