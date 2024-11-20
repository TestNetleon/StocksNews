// // custom_expansion_tile.dart
// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:svg_flutter/svg.dart';

// class CustomExpansionTile extends StatefulWidget {
//   final Widget title;
//   final Widget? leading;
//   final Widget? trailing;
//   final List<Widget> children;

//   const CustomExpansionTile({
//     super.key,
//     required this.title,
//     this.leading,
//     this.trailing,
//     required this.children,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _CustomExpansionTileState createState() => _CustomExpansionTileState();
// }

// class _CustomExpansionTileState extends State<CustomExpansionTile> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _isExpanded = !_isExpanded;
//             });
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if (widget.trailing != null) widget.trailing!,
//               _isExpanded
//                   ? SvgPicture.asset(
//                       Images.add,
//                       // ignore: deprecated_member_use
//                       color: Colors.green,
//                       height: 40,
//                     )
//                   : Opacity(
//                       opacity: .3,
//                       child: SvgPicture.asset(
//                         Images.add,
//                         // ignore: deprecated_member_use
//                         color: Colors.green,
//                         height: 40,
//                       ),
//                     ),
//               const SpacerHorizontal(width: 8.0),
//               if (widget.leading != null) widget.leading!,
//               Expanded(child: widget.title),
//               const SpacerHorizontal(width: 8.0),
//               Icon(
//                 _isExpanded ? Icons.expand_less : Icons.expand_more,
//                 color: Colors.green,
//               ),
//             ],
//           ),
//         ),
//         if (_isExpanded)
//           Padding(
//             padding: const EdgeInsets.only(top: 20.0, left: 20.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   left: BorderSide(
//                     color: _isExpanded ? Colors.green : Colors.green,
//                     width: 2.0,
//                   ),
//                 ),
//               ),
//               padding: const EdgeInsets.only(
//                 left: 20.0,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: widget.children,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
