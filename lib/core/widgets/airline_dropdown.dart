import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AirlineDropdown extends StatelessWidget {
  final String? selectedAirline;
  final String hintText;
  final Function(String?) onChanged;

  const AirlineDropdown({
    super.key,
    this.selectedAirline,
    required this.hintText,
    required this.onChanged,
  });

  static const List<Map<String, String>> airlines = [
    {'name': 'Air Bangladesh', 'country': 'Bangladesh', 'code': 'B9'},
    {
      'name': 'Biman Bangladesh Airlines',
      'country': 'Bangladesh',
      'code': 'BG'
    },
    {'name': 'Bismillah Airlines', 'country': 'Bangladesh', 'code': '5Z'},
    {'name': 'United Airways', 'country': 'Bangladesh', 'code': '4H'},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: airlines.map((a) => a['name']!).toList(),
      selectedItem: selectedAirline,
      onChanged: onChanged,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        itemBuilder: (context, item, isSelected) {
          final airline = airlines.firstWhere((a) => a['name'] == item);
          return ListTile(
            title: Text(airline['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(airline['country']!),
            trailing: Text(airline['code']!),
          );
        },
        searchFieldProps: TextFieldProps(
          decoration: const InputDecoration(
            hintText: "Search airlines...",
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      itemAsString: (item) => item,
    );
  }
}
