import 'package:flutter/material.dart';

class AutocompleteDropdown extends StatefulWidget {
  final List<String> items;

  const AutocompleteDropdown({super.key, required this.items});

  @override
  State<AutocompleteDropdown> createState() => _AutocompleteDropdownState();
}

class _AutocompleteDropdownState extends State<AutocompleteDropdown> {
  final TextEditingController _controller = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items; // Initialize with all items
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return widget.items.take(5).toList(); // Show first 5 if empty
        }

        _filteredItems = widget.items
            .where((item) =>
                item.toLowerCase().contains(textEditingValue.text.toLowerCase()))
            .toList();

        return _filteredItems.take(5).toList(); // Limit to 5 suggestions
      },
      onSelected: (String selection) {
        _controller.text = selection;
      },
      // textFormFieldBuilder: (BuildContext context,
      //     TextEditingController textEditingController,
      //     FocusNode focusNode) {
      //   return TextFormField(
      //     controller: textEditingController,
      //     focusNode: focusNode,
      //     decoration: const InputDecoration(
      //       hintText: 'Type to search...',
      //       border: OutlineInputBorder(),
      //     ),
      //     onChanged: (value) {
      //       setState(() {}); // Important: Rebuild to update suggestions
      //     },
      //   );
      // },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0, // Set a maximum height for the dropdown
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                children: options.map((option) {
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(option),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}