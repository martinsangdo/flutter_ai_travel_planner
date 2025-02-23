import 'package:flutter/material.dart';
import '../../../components/cards/item_card.dart';
import '../../../constants.dart';

//display in Attraction detail page
class AttractionTabItems extends StatefulWidget {
  List thingsTodoList = [];

  AttractionTabItems({super.key, required this.thingsTodoList});

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
        if (_currentTabIndex == 0 && widget.thingsTodoList.isNotEmpty)
        ...List.generate(
          widget.thingsTodoList.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: ItemCard(
              itemType: 'things2do',
              title: widget.thingsTodoList[index]["name"],
              image: widget.thingsTodoList[index]["imgUrl"],
              price: widget.thingsTodoList[index]["price"],
              reviews: widget.thingsTodoList[index]["reviews"]
            ),
          ),
        ),  //end first tab list

      ], 
    );
  }
}
final List<Tab> tabHeaders = <Tab>[
  const Tab(
    child: Text('Things to do'),
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
