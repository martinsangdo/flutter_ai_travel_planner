import 'package:ai_travel_planner/screens/auto_complete_dropdown.dart';
import 'package:flutter/material.dart';

import '../../components/cards/big/info_big_card.dart';
import '../../components/scalton/big_card_scalton.dart';
import '../../constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showSearchResult = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void showResult() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showSearchResult = true;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Column(
          children: [
            Text(
              "AI Planner".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: primaryColor),
            )
          ],
        )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Text('Search', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: defaultPadding),
              //input box
              const SearchForm(),
              



              const SizedBox(height: defaultPadding),
              Text(_showSearchResult ? "Search Results" : "Top Restaurants",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: defaultPadding),






              Expanded(
                child: ListView.builder(
                  itemCount: _isLoading ? 2 : 5, //5 is demo length of your data
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: _isLoading
                        ? const BigCardScalton()
                        : InfoBigCard(
                            // Images are List<String>
                            images: []..shuffle(),
                            name: "McDonald's",
                            rating: 4.3,
                            reviewCount: '66,111',
                            attractionCount: '125',
                            subList: const [
                              "Chinese",
                              "American",
                              "Deshi food"
                            ],
                            press: () {},
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//input keyword to find cities
class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      //text box
      child: TextFormField(
        onChanged: (value) {
          // get data while typing
          // if (value.length >= 3) showResult();
        },
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            // If all data are correct then save data to out variables
            _formKey.currentState!.save();

            // Once user pree on submit
          } else {}
        },
        // validator: requiredValidator.call,
        style: Theme.of(context).textTheme.labelLarge,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: "What is the city or country that you want to go?",
          contentPadding: kTextFieldPadding,
        ),
      ),
      //result list
      

    );
  }
}

List<String> myItems = [
  'Apple',
  'Banana',
  'Orange',
  'Grape',
  'Mango',
  'Pineapple',
  'Watermelon',
  'Kiwi',
  'Strawberry',
  'Blueberry',
];