import 'dart:convert';

import 'package:ai_travel_planner/components/percentage_display.dart';
import 'package:ai_travel_planner/db/database_helper.dart';
import 'package:flutter/material.dart';

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
  //
  List<String> _homeSliderImages = [];
  Map<dynamic, dynamic> _topBannerInfo = {};
  //
  List<String> _randomPickImages = [];
  Map<dynamic, dynamic> _randomPickInfo = {};
  //
  Map _countriesInContinents = {
    'europe': [], 'america': [], 'asia': [], 'australia': [], 'africa': []
  };  //key: continent id, value: list of countries info

  _loadHomeCities(){
    //load banner
    _loadBanner();
    //load Random Pick city
    _loadRandomPick();
    //load other continents
    _loadContinentCountries('europe');
    _loadContinentCountries('america');
    _loadContinentCountries('asia');
    _loadContinentCountries('australia');
    _loadContinentCountries('africa');
  }
  //get countries of 
  _loadBanner() async{
    Map topBannerCity = glb_home_cities['top_banner'];
    final dbData = await DatabaseHelper.instance.rawQuery("SELECT * FROM tb_city WHERE name='"+topBannerCity['n']+"' AND country='"+topBannerCity['c']+"'", []);
    if (dbData.isNotEmpty){
      setState(() {
        List<dynamic> imgUrls = jsonDecode(dbData[0]['imgUrls']);
        List<String> imgList = [];
        for (dynamic imgUrl in imgUrls){
          imgList.add(imgUrl);
        }
        _homeSliderImages = imgList;
        //
        _topBannerInfo = dbData[0];
        //
        _isLoading = false;
      });
    } else {
      //no city in top banner (our local db)
      setState(() {
        _isLoading = false;
      });
    }
  }
  //get countries of continent
  _loadContinentCountries(String continent) async{
    List continentCountries = glb_home_cities[continent]; //list of city names/countries of this continent
    if (continentCountries.isEmpty){
      return; //do nothing
    }
    List countryObjects = [];
    //find info of those city in our local db
    for (Map cityCountry in continentCountries){
      final dbData = await DatabaseHelper.instance.rawQuery("SELECT * FROM tb_city WHERE name='"+cityCountry['n']+"' AND country='"+cityCountry['c']+"'", []);
      if (dbData.isNotEmpty){
        countryObjects.add(dbData[0]);
      } else {
       //not found this city in our db
      }
    }
    if (countryObjects.isNotEmpty){
      setState(() {
        _countriesInContinents[continent] = countryObjects;
      });
    }
  }
  //
  _loadRandomPick() async{
    Map cityInfo = glb_home_cities['random_pick'];
    final dbData = await DatabaseHelper.instance.rawQuery(
      "SELECT * FROM tb_city WHERE name='"+cityInfo['n']+"' AND country='"+cityInfo['c']+"'", []);
    // debugPrint(dbData[0].toString());
    if (dbData.isNotEmpty){
      setState(() {
        List<dynamic> imgUrls = jsonDecode(dbData[0]['imgUrls']);
        List<String> imgList = [];
        for (dynamic imgUrl in imgUrls){
          imgList.add(imgUrl);
        }
        _randomPickImages = imgList;
        //
        _randomPickInfo = dbData[0];
      });
    }
  }
  //user pressed the top banner
  _pressedTopBanner(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetailsScreen(cityInfo: _topBannerInfo),
      ),
    );
  }

  _pressedRandomPick(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetailsScreen(cityInfo: _randomPickInfo),
      ),
    );
  }

  @override
  void initState() {
      super.initState();
      _loadHomeCities();  //load all parts
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
              if (_isLoading) ...[
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const PercentageDisplay(),
              ],
              const SizedBox(height: defaultPadding),
              //part 1 (top banner)
              if (_homeSliderImages.isNotEmpty)...[
                const SizedBox(height: defaultPadding),
                Padding(
                    padding: const EdgeInsets.fromLTRB(
                        defaultPadding, 0, defaultPadding, defaultPadding),
                    child: InfoBigCard(
                      images: _homeSliderImages..shuffle(),
                      name: _topBannerInfo['name'] + ', ' + _topBannerInfo['country'],
                      reviewCount: _topBannerInfo['review'].toString(),
                      press: _pressedTopBanner
                    ),
                  ),
                const SizedBox(height: defaultPadding),
              ],
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
              MediumCardList(dataList: _countriesInContinents['europe']), //list of items
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
              MediumCardList(dataList: _countriesInContinents['america']),
              const SizedBox(height: defaultPadding),
              //part 4
              if (_randomPickImages.isNotEmpty)...[
                SectionTitle(title: "Random pick", press: () {}),
                const SizedBox(height: defaultPadding),
                Padding(
                    padding: const EdgeInsets.fromLTRB(
                        defaultPadding, 0, defaultPadding, defaultPadding),
                    child: InfoBigCard(
                      images: _randomPickImages..shuffle(),
                      name: _randomPickInfo['name'] + ', ' + _randomPickInfo['country'],
                      reviewCount: _randomPickInfo['review'].toString(),
                      press: _pressedRandomPick
                    ),
                  ),
                const SizedBox(height: defaultPadding),
              ],
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
              MediumCardList(dataList: _countriesInContinents['australia']),
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
              MediumCardList(dataList: _countriesInContinents['africa']),
              const SizedBox(height: defaultPadding),
              //part 6
              SectionTitle(
                title: "Asia",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              MediumCardList(dataList: _countriesInContinents['asia']),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
