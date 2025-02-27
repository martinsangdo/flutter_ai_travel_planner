import 'package:ai_travel_planner/components/cards/big/info_big_card.dart';
import 'package:ai_travel_planner/constants.dart';
import 'package:ai_travel_planner/db/city_model.dart';
import 'package:ai_travel_planner/db/database_helper.dart';
import 'package:ai_travel_planner/screens/details/city_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

//display list of cities of 1 continent
class ContinentCityScreen extends StatefulWidget {
  String continent = '';

  ContinentCityScreen({super.key, required this.continent});

  @override
  State<ContinentCityScreen> createState() => _State();
}

class _State extends State<ContinentCityScreen> {
  bool _isLoading = true;
  List<Map> _cityList = [];
  int _currentPage = 0; //start from 0
  int totalPage = 1;
  //
  _loadCitiesInContinent() async{
    var cities = await DatabaseHelper.instance.queryCitiesByContinentPagination(widget.continent, _currentPage, DOUBLE_PAGE_SIZE);
    if (cities.isNotEmpty){
      // List<City> basicCities = [];
      // for (Map city in cities){
        // debugPrint(city['name']);
        // debugPrint(city['img']);
        // basicCities.add(City.fromMap(city));
      // }
      setState(() {
        _cityList = cities;
        _isLoading = false;
      });
    } else {
      //why empty?
        setState(() {
            _isLoading = false;
        });
    }
  }
  //get total of items
  Future<int> _fetchTotalPages() async{
    int _totalPage = 1;
    var cityTotal = await DatabaseHelper.instance.queryByContinentTotal(widget.continent);
    if (cityTotal.isNotEmpty){
      if (cityTotal[0]['total'] >= DOUBLE_PAGE_SIZE){
        //we have more than 1 page
        _totalPage = (cityTotal[0]['total'] / DOUBLE_PAGE_SIZE).ceil();
      }
    }
    //debugPrint('Total page ' + _totalPage.toString());
    return _totalPage;
  }
  //
  @override
  void initState() {
      super.initState();
      if (widget.continent != ''){
        //maybe has pagination
        _fetchTotalPages().then((pageTotal){
            setState(() {
              totalPage = pageTotal;
            });
            Future.microtask(() { 
              _loadCitiesInContinent();
            });
          });
      }
  } 

  @override
  void dispose() {
    super.dispose();
  }
  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.continent.toUpperCase()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: ListView.builder(
            // while we dont have our data bydefault we show 3 scalton
            itemCount: _cityList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: defaultPadding),
              child: InfoBigCard(
                images: [fullImgUrl(_cityList[index]['img'])],
                name: _cityList[index]['name'] + ', ' + _cityList[index]['country'],
                reviewCount: _cityList[index]['review'].toString(),
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityDetailsScreen(cityInfo: _cityList[index], cityOptions: {},),
                  ),
                ),
              ),
            ),
          ),
        ),
      )//end SafeArea
      ,
        bottomNavigationBar: (totalPage > 1) ? Card(
          margin: EdgeInsets.zero,
          child: NumberPaginator(
            // by default, the paginator shows numbers as center content
            numberPages: totalPage,
            onPageChange: (int index) { //start from 0
              setState(() {
                _currentPage = index;
              });
              Future.microtask(() { 
                _loadCitiesInContinent();
              });
            },
          ),
        ) : null
    );
  }
}
