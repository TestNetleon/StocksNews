import 'package:flutter/material.dart';

class GradientContainerWidget extends StatefulWidget {
  const GradientContainerWidget(
      {this.width = double.infinity,
      this.borderRadius,
      this.shape = BoxShape.rectangle,
      required this.height,
      super.key});
  final double height;
  final double? width;
  final double? borderRadius;
  final BoxShape shape;
  @override
  State<GradientContainerWidget> createState() =>
      _GradientContainerWidgetState();
}

class _GradientContainerWidgetState extends State<GradientContainerWidget>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<Alignment> _shimmerAnimation;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     duration: const Duration(seconds: 2),
  //     vsync: this,
  //   )..repeat();

  //   _shimmerAnimation = AlignmentTween(
  //     begin: const Alignment(-1.5, -0.5),
  //     end: const Alignment(2.5, 1.5),
  //   ).animate(CurvedAnimation(
  //     parent: _controller,
  //     curve: Curves.linear,
  //   ));
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        shape: widget.shape,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 23, 23, 23),
            Color.fromARGB(255, 48, 48, 48),
          ],
        ),
      ),
    );
    // return AnimatedBuilder(
    //   animation: _controller,
    //   builder: (context, child) {
    //     return Container(
    //       height: widget.height,
    //       width: widget.width,
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           colors: [
    //             Colors.grey.shade400,
    //             Colors.grey.shade300,
    //             Colors.grey.shade400
    //           ],
    //           begin: _shimmerAnimation.value,
    //           end: _shimmerAnimation.value.add(const Alignment(1.0, 0.0)),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
