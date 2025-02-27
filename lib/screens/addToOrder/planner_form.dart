import 'package:ai_travel_planner/screens/addToOrder/components/square_checkedbox.dart';
import 'package:ai_travel_planner/screens/addToOrder/date_widget.dart';
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
    { 'text': 'Shopping', 'selected': true, 'value': 6},
    { 'text': 'Beaches', 'selected': false, 'value': 0},
    { 'text': 'Food exploration', 'selected': true, 'value': 4},
    { 'text': 'Festivals', 'selected': true, 'value': 3},
    { 'text': 'Spa', 'selected': false, 'value': 7},
    { 'text': 'Outdoor', 'selected': false, 'value': 2},
    { 'text': 'Nightlife exploration', 'selected': true, 'value': 5},
    ]; //list of selected activities
  final List<String> _whoGoWith = ['Solo', 'Couple', 'Family', 'Friend'];
  int _selectedWhoGoIndex = 0;

  final List<String> _budgetType = ['0 - 1000 USD', '< 2500 USD', '2500+ USD'];
  int _selectedBudgetIndex = 0;
  //
  Map<String, dynamic> _searchResults = {};  //list of search results of city,country
  //
  int _selectedTravelDays = 5;
  String _selectedTravelDate = '';  //yyyy-mm-dd
  String _selectedWonderId = '';
  //
  _callbackShowSearchResults(searchResults){
    //debugPrint(searchResults.toString());
    setState(() {
      _searchResults = searchResults;
    });
  }
  //this is called after user chose the date
  void onDateSelected(strSelectedDate){
    //debugPrint(strSelectedDate);
    setState(() {
      _selectedTravelDate = strSelectedDate + 'T00:00:00.000Z';
    });
  }
  //begin planning
  _suggestThePlan() async{
    debugPrint(_selectedWonderId);
    //collect other info
    debugPrint(_selectedTravelDate);
    debugPrint(_activityTypes.toString());
    debugPrint(_selectedWhoGoIndex.toString());
    debugPrint(_selectedBudgetIndex.toString());
  }
  //max days to travel is 7
  _increaseDays(){
    setState(() {
      if (_selectedTravelDays < 7){
        _selectedTravelDays = _selectedTravelDays + 1;
      }
    });
  }
  //min days to travel is 1
  _decreaseDays(){
    setState(() {
      if (_selectedTravelDays > 1){
        _selectedTravelDays = _selectedTravelDays - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Column(
            children: [
              Text(
                "AI Travel Planner"
              )
            ],
          )
        )
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              SearchForm(callBackSearchResult: _callbackShowSearchResults), //input the city keyword
              //list of results
              if (_searchResults.isNotEmpty)
                Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: 200.0, // Set a maximum height for the dropdown
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        children: [
                          for (String key in _searchResults.keys.toList())...[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedWonderId = _searchResults[key]['wonder_id'];
                                  _searchResults = {};  //clear search results
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(_searchResults[key]['city_name']),
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: defaultPadding),
              //travel date
              DatePickerWidget(
                onDateSelected: onDateSelected
              ),
              //no. of days
              /*
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
                            onPressed: () {_decreaseDays();},
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
                          child: Text(_selectedTravelDays.toString().padLeft(2, "0"),
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              _increaseDays();
                            },
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
                    */
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
