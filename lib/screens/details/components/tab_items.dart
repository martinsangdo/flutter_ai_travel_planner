import 'package:ai_travel_planner/screens/photo_gallery_fullscreen.dart';
import 'package:flutter/material.dart';
import '../../../components/cards/item_card.dart';
import '../../../constants.dart';

class TabItems extends StatefulWidget {
  List hotelList;
  List attractions;

  TabItems({super.key, required this.hotelList, required this.attractions});

  @override
  State<TabItems> createState() => _ItemsState();
}

class _ItemsState extends State<TabItems> {
  int _currentTabIndex = 0;
  //
  @override
  void initState() {
    super.initState();
    setState(() {
    });
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
              title: widget.attractions[index]["name"],
              description: widget.attractions[index]["description"],
              image: widget.attractions[index]["image"],
              duration: widget.attractions[index]["duration"],
            ),
          ),
        ),  //end attraction list
        if (_currentTabIndex == 1 && widget.hotelList.isNotEmpty)
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
              rating: widget.hotelList[index]["rating"]
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
  ),
  const Tab(
    child: Text('Hotels'),
  ),
];

final List<Map<String, dynamic>> demoData = List.generate(
  7,
  (index) => {
    "image": "https://ak-d.tripcdn.com/images/01029120008fcnhm923E2_C_180_240_Q70.webp",
    "title": "Cookie Sandwich",
    "description": "Shortbread, chocolate turtle cookies, and red velvet.",
    "price": 7.4,
    "foodType": "Chinese",
    "priceRange": "\$" * 2,
  },
);

final List<String> photoGalleryUrls = [
  'https://ak-d.tripcdn.com/images/01029120008fcnhm923E2_C_180_240_Q70.webp',
  'https://ak-d.tripcdn.com/images/1lo4s12000dyhs5m47CE2_C_180_240_Q70.webp',
  'https://ak-d.tripcdn.com/images/100b10000000o5v2z5A26_C_180_240_Q70.webp',
];
