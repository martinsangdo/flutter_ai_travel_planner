import 'package:flutter/material.dart';
import '../../../components/cards/item_card.dart';
import '../../../constants.dart';

//display in Attraction detail page
class AttractionTabItems extends StatefulWidget {
  Map things2DoNEat = {};

  AttractionTabItems({super.key, required this.things2DoNEat});

  @override
  State<AttractionTabItems> createState() => _ItemsState();
}

class _ItemsState extends State<AttractionTabItems> {
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
        if (_currentTabIndex == 0 && widget.things2DoNEat['places2Visit'] != null)
          ...List.generate(
            widget.things2DoNEat['places2Visit'].length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: ItemCard(
                itemType: 'place2visit',
                title: widget.things2DoNEat['places2Visit'][index]["name"],
                image: widget.things2DoNEat['places2Visit'][index]["imgUrl"],
                commentNum: widget.things2DoNEat['places2Visit'][index]["commentNum"]
              ),
            ),
        ),  //end Things to do
        /*
        if (_currentTabIndex == 1 && widget.things2DoNEat['what2Eat'].isNotEmpty)
          ...List.generate(
            widget.things2DoNEat['what2Eat'].length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: ItemCard(
                itemType: 'what2eat',
                title: widget.things2DoNEat['what2Eat'][index]["name"],
                image: widget.things2DoNEat['what2Eat'][index]["imgUrl"],
                price: widget.things2DoNEat['what2Eat'][index]["price"],
                reviews: widget.things2DoNEat['what2Eat'][index]["reviews"]
              ),
            ),
        ),  //end Things to eat
        */
      ], 
    );
  }
}
final List<Tab> tabHeaders = <Tab>[
  const Tab(
    child: Text('Places to visit'),
  ),
  const Tab(
    child: Text('What to eat'),
  ),
  const Tab(
    child: Text('Reviews'),
  ),
  const Tab(
    child: Text('Recommend'),
  ),
];
