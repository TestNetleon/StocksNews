import 'package:flutter/material.dart';
import '../../base/base_list_divider.dart';

class SDListHeading extends StatelessWidget {
  final List<String> data;
  const SDListHeading({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            data.length,
            (index) {
              return Expanded(
                flex: index == 0 || index == data.length - 1 ? 2 : 1,
                child: Align(
                  alignment: index == 0
                      ? Alignment.centerLeft
                      : index == data.length - 1
                          ? Alignment.centerRight
                          : Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          index == 0 || index == data.length - 1 ? 12 : 0,
                      vertical: 12,
                    ),
                    child: Text(
                      data[index],
                      textAlign:
                          index == data.length - 1 ? TextAlign.end : null,
                      // style: styleBaseBold(fontSize: 13),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        BaseListDivider(),
      ],
    );
  }
}
