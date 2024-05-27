import 'package:flutter/material.dart';

import '../../api/api_response.dart';

class CustomListWheelScrollView extends StatelessWidget {
  final List<KeyValueElement> items;
  final Function(int) onSelected;

  const CustomListWheelScrollView({
    super.key,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust height as needed
      child: ListWheelScrollView(
        itemExtent: 30,
        children: List.generate(
          items.length,
          (index) => _buildItem(items[index].value ?? "N?A"),
        ),
        onSelectedItemChanged: (index) {
          onSelected(index);
        },
      ),
    );
  }

  Widget _buildItem(String item) {
    return Center(
      child: Text(
        item,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
