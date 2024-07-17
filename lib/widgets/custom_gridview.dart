import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    required this.length,
    required this.getChild,
    this.paddingVertical = 16,
    this.paddingHorizontal = 8,
    this.itemSpace,
    super.key,
  });

  final double paddingVertical, paddingHorizontal;
  final int length;
  final double? itemSpace;
  final Widget Function(int index) getChild;
//
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: paddingVertical),
      itemBuilder: (context, index) {
        return IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: getChild(index * 2)),
                length > (index * 2 + 1)
                    ? SizedBox(width: itemSpace ?? paddingHorizontal.sp)
                    : const SizedBox(),
                length > (index * 2 + 1)
                    ? Expanded(child: getChild(index * 2 + 1))
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: (paddingVertical * 1.2).sp);
      },
      itemCount: ((length / 2) + (length % 2)).toInt(),
    );
  }
}

// class CustomGridView extends StatelessWidget {
//   const CustomGridView({
//     required this.length,
//     required this.getChild,
//     this.paddingVertical = 16,
//     this.paddingHorizontal = 8,
//     super.key,
//   });

//   final double paddingVertical, paddingHorizontal;
//   final int length;
//   final Widget Function(int index) getChild;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.symmetric(vertical: paddingVertical),
//       itemBuilder: (context, index) {
//         final int startIndex = index * 3;
//         final int endIndex = startIndex + 3 <= length ? startIndex + 3 : length;
//         final List<Widget> rowChildren = [];

//         for (int i = startIndex; i < endIndex; i++) {
//           rowChildren.add(Expanded(child: getChild(i)));
//           if (i < endIndex - 1) {
//             rowChildren.add(SizedBox(width: paddingHorizontal));
//           }
//         }

//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: rowChildren,
//           ),
//         );
//       },
//       separatorBuilder: (context, index) {
//         return SizedBox(height: paddingVertical * 1.2);
//       },
//       itemCount: ((length - 1) ~/ 3) + 1,
//     );
//   }
// }

class CustomGridView4 extends StatelessWidget {
  const CustomGridView4({
    required this.length,
    required this.getChild,
    this.paddingVertical = 16,
    this.paddingHorizontal = 8,
    super.key,
  });

  final double paddingVertical, paddingHorizontal;
  final int length;
  final Widget Function(int index) getChild;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: paddingVertical.sp),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (i) {
              int childIndex = index * 4 + i;
              return Expanded(
                child: childIndex < length
                    ? getChild(childIndex)
                    : const SizedBox(),
              );
            }),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: (paddingVertical * 1.2).sp);
      },
      itemCount: ((length / 4).ceil()),
    );
  }
}

class CustomGridViewPerChild extends StatelessWidget {
  const CustomGridViewPerChild({
    required this.length,
    required this.getChild,
    this.paddingVertical = 16,
    this.paddingHorizontal = 8,
    this.childrenPerRow = 2,
    super.key,
  });

  final double paddingVertical, paddingHorizontal;
  final int length;
  final int childrenPerRow;
  final Widget Function(int index) getChild;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: paddingVertical.sp),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(childrenPerRow, (i) {
              int childIndex = index * childrenPerRow + i;
              return Expanded(
                child: childIndex < length
                    ? getChild(childIndex)
                    : const SizedBox(),
              );
            }),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: (paddingVertical * 1.2).sp);
      },
      itemCount: ((length / childrenPerRow).ceil()),
    );
  }
}
