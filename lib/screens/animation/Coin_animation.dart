import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CoinAnimationWidget extends StatefulWidget {
  const CoinAnimationWidget({super.key});

  @override
  State<CoinAnimationWidget> createState() => _CoinAnimationWidgetState();
}

class _CoinAnimationWidgetState extends State<CoinAnimationWidget>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];
  final List<Offset?> _coinPositions = List.generate(9, (_) => null);
  Offset? _targetPosition;
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _setInitialAndTargetPositions();
      _startAnimation();
    });
  }

  void _setInitialAndTargetPositions() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      await _player.play(AssetSource(AudioFiles.coinWinAudio));
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final initialPosition =
        Offset((screenWidth - 60) / 2, (screenHeight - 60) / 2); // Center
    _targetPosition =
        const Offset(Dimen.padding, Dimen.padding); // Top-left corner

    setState(() {
      for (int i = 0; i < _coinPositions.length; i++) {
        _coinPositions[i] = initialPosition;
        final controller = AnimationController(
          duration: const Duration(milliseconds: 200),
          vsync: this,
        );
        final animation = Tween<Offset>(
          begin: initialPosition,
          end: _targetPosition!,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.linear,
        ));
        _controllers.add(controller);
        _animations.add(animation);
      }
    });
  }

  void _startAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * (i + 1)), () {
        _controllers[i].forward().whenComplete(() {
          if (i == _controllers.length - 6) {
            _timer?.cancel();
          }

          if (i == _controllers.length - 1) {
            _player.pause();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _player.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Dialog(
        backgroundColor: ThemeColors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
        child: Container(
          padding: const EdgeInsets.all(Dimen.padding),
          color: ThemeColors.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.congrationTextImage),
              SpacerVertical(height: 100.sp),
              Text(
                "you won",
                style: stylePTSansBold(color: Colors.white),
              ),
              const SpacerVertical(height: 20),
              Text(
                "2,696",
                style: stylePTSansBold(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      ...List.generate(9, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: _animations[index].value,
              child: child,
            );
          },
          child: Image.asset(
            Images.coinWin,
            width: 35,
            height: 35,
          ),
        );
      }),
    ]);
  }
}
