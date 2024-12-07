import 'package:flutter/material.dart';

class SortMenu extends StatelessWidget {
  final List<String> sortOptions;
  final Function(String) onSortSelected;

  SortMenu({required this.sortOptions, required this.onSortSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: sortOptions.first,
      icon: Icon(Icons.sort),
      items: sortOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          onSortSelected(newValue);
        }
      },
    );
  }
}
