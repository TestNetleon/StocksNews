import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/utils.dart';

class FilterDropDownCupertino extends StatefulWidget {
  final List<Widget> children;
  final void Function(int item) onSelected;

  const FilterDropDownCupertino({
    super.key,
    required this.children,
    required this.onSelected,
  });

  @override
  State<FilterDropDownCupertino> createState() =>
      _FilterDropDownCupertinoState();
}

class _FilterDropDownCupertinoState extends State<FilterDropDownCupertino> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust height as needed
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              backgroundColor: Colors.white, // Set background color
              itemExtent: 50, // Set the height of each item
              // looping: true, // Allow looping of values
              onSelectedItemChanged: (index) {
                // Handle selected item change
                setState(() {
                  selectedIndex = index;
                });
                Utils().showLog("$selectedIndex");
              },
              children: widget.children,
            ),
          ),
          GestureDetector(
            onTap: () {
              try {
                // if (selectedIndex != null) {
                Utils().showLog("$selectedIndex");
                widget.onSelected(selectedIndex);
                Utils().showLog("$selectedIndex ** ");
                // }
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
              Navigator.of(context).pop(); // Close the modal bottom sheet
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
