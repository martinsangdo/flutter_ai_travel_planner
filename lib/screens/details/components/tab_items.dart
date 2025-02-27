import 'package:flutter/material.dart';
import '../../../components/cards/item_card.dart';
import '../../../constants.dart';

//show tabs in city detail page
class TabItems extends StatefulWidget {
  List hotelList;
  List attractions;
  List restaurants;

  TabItems({super.key, required this.hotelList, required this.attractions, required this.restaurants});

  @override
  State<TabItems> createState() => _ItemsState();
}

class _ItemsState extends State<TabItems> {
  int _currentTabIndex = 0;
  //
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //tab headers
        DefaultTabController(
          length: tabHeaders.length,
          child: TabBar(
            isScrollable: true,
            unselectedLabelColor: titleColor,
            labelStyle: Theme.of(context).textTheme.titleLarge,
            onTap: (tabIndex) {
              // you will get selected tab index
              setState(() {
                _currentTabIndex = tabIndex;
              });
            },
            tabs: tabHeaders,
          ),
        ),
        //list in tab body
        if (_currentTabIndex == 0 && widget.attractions.isNotEmpty)
        ...List.generate(
          widget.attractions.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: ItemCard(
              trip_id: widget.attractions[index]["trip_id"],
              title: widget.attractions[index]["name"],
              description: widget.attractions[index]["description"],
              image: widget.attractions[index]["image"],
              duration: widget.attractions[index]["duration"],
              commentNum: widget.attractions[index]['commentNum']??'',
              itemType: 'attraction',
            ),
          ),
        ),  //end attraction list
        if (_currentTabIndex == 1 && widget.restaurants.isNotEmpty)
        ...List.generate(
          widget.restaurants.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: ItemCard(
              trip_id: widget.restaurants[index]["trip_id"],
              title: widget.restaurants[index]["name"],
              description: widget.restaurants[index]["description"],
              image: widget.restaurants[index]["image"],
              duration: widget.restaurants[index]["duration"],
              commentNum: widget.restaurants[index]['commentNum']??'',
              itemType: 'restaurant',
            ),
          ),
        ),  //end restaurant list
        if (_currentTabIndex == 2 && widget.hotelList.isNotEmpty)
        ...List.generate(
          widget.hotelList.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: ItemCard(
              title: widget.hotelList[index]["name"],
              description: widget.hotelList[index]["description"],
              image: widget.hotelList[index]["image"],
              price: widget.hotelList[index]["price"],
              url: widget.hotelList[index]["url"],
              rating: (widget.hotelList[index]["rating"]==null)?0:double.parse(widget.hotelList[index]["rating"].toString()),
              itemType: 'hotel'
            ),
          ),
        ), //end hotel list
      ], 
    );
  }
}

final List<Tab> tabHeaders = <Tab>[
  const Tab(
    child: Text('Attractions'),
  )
  ,
  const Tab(
    child: Text('Restaurants'),
  ),
  const Tab(
    child: Text('Hotels'),
  ),
];
