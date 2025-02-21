import 'package:ai_travel_planner/screens/addToOrder/components/square_checkedbox.dart';
import 'package:ai_travel_planner/screens/search/search_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/required_section_title.dart';
import 'components/rounded_checkedbox_list_tile.dart';

//Used in the screen to choose options in AI Planner
class PlannerFormScreen extends StatefulWidget {
  const PlannerFormScreen({super.key});

  @override
  State<PlannerFormScreen> createState() => _AddToOrderScrreenState();
}

class _AddToOrderScrreenState extends State<PlannerFormScreen> {
  List<Map> _activityTypes = [
    { 'text': 'Sightseeing', 'selected': true, 'value': 1},
    { 'text': 'Shopping', 'selected': false, 'value': 6},
    { 'text': 'Beaches', 'selected': false, 'value': 0},
    { 'text': 'Food exploration', 'selected': false, 'value': 4},
    { 'text': 'Festivals', 'selected': false, 'value': 3},
    { 'text': 'Spa', 'selected': false, 'value': 7},
    { 'text': 'Outdoor', 'selected': false, 'value': 2},
    { 'text': 'Nightlife exploration', 'selected': false, 'value': 5},
    ]; //list of selected activities
  final List<String> _whoGoWith = ['Solo', 'Couple', 'Family', 'Friend'];
  int _selectedWhoGoIndex = 0;

  final List<String> _budgetType = ['0 - 1000 USD', '< 2500 USD', '2500 USD +'];
  int _selectedBudgetIndex = 0;

  int choiceOfTopCookie = 1;

  int choiceOfBottomCookie = 1;

  int numOfItems = 1;

  //
  _suggestThePlan() async{

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              backgroundColor: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              const SearchForm(), //input the city keyword
              const SizedBox(height: defaultPadding),
              //date

              //no. of days
              Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: defaultPadding),
                          child: Text(
                            'How many days do you plan to travel?', // Replace with your actual text
                            style: Theme.of(context).textTheme.titleMedium
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.remove),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Text(numOfItems.toString().padLeft(2, "0"),
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
              //activities types
              RequiredSectionTitle(
                        title: "Which activities do you prefer?", isRequired: true,),
                    const SizedBox(height: defaultPadding),
                    ...List.generate(
                      _activityTypes.length,
                      (index) => SquareCheckboxItem(
                        isActive: _activityTypes[index]['selected'] == true,
                        text: _activityTypes[index]['text'],
                        press: () {
                          _activityTypes[index]['selected'] = ! _activityTypes[index]['selected'];
                          setState(() {
                            _activityTypes = _activityTypes;  //refresh UI
                          });
                        },
                      ),
                    ),
              const SizedBox(height: defaultPadding),
              //who go with
              RequiredSectionTitle(
                        title: "Who do you travel with?", isRequired: false,),
                    const SizedBox(height: defaultPadding),
                    ...List.generate(
                      _budgetType.length,
                      (index) => RoundedCheckboxListTile(
                        isActive: _selectedWhoGoIndex == index,
                        text: _whoGoWith[index],
                        press: () {
                          _selectedWhoGoIndex = index;
                          setState(() {
                            _selectedWhoGoIndex = _selectedWhoGoIndex;  //refresh UI
                          });
                        },
                      ),
                    ),
              const SizedBox(height: defaultPadding),
              //budget
              RequiredSectionTitle(
                        title: "Your travel budget", isRequired: false,),
                    const SizedBox(height: defaultPadding),
                    ...List.generate(
                      _budgetType.length,
                      (index) => RoundedCheckboxListTile(
                        isActive: _selectedBudgetIndex == index,
                        text: _budgetType[index],
                        press: () {
                          _selectedBudgetIndex = index;
                          setState(() {
                            _selectedBudgetIndex = _selectedBudgetIndex;  //refresh UI
                          });
                        },
                      ),
                    ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                      onPressed: () {
                        _suggestThePlan();
                      },
                      child: const Text("Suggest me the plan"),
              ),
              const SizedBox(height: defaultPadding)
            ],
          ),
        ),
      ),
    );
  }
}
