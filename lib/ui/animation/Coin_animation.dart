import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'dart:math';

class CoinAnimationWidget extends StatefulWidget {
  final CongoClaimRes? data;
  const CoinAnimationWidget({
    super.key,
    this.data,
  });

  @override
  State<CoinAnimationWidget> createState() => _CoinAnimationWidgetState();
}

class _CoinAnimationWidgetState extends State<CoinAnimationWidget>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];
  final List<Animation<double>> _fadeAnimations = [];
  final List<Offset?> _coinPositions = List.generate(9, (_) => null);
  Offset? _targetPosition;
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  bool _animationsInitialized = false;
  bool _coinsAnimationComplete = false;
  bool showNormalCongo = false;

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
    final initialPosition = Offset(
      screenWidth / 2 - 17.5,
      screenHeight / 2 - 95,
    );
    _targetPosition = Offset(ScreenUtil().screenWidth - 100, 100);
    for (int i = 0; i < _coinPositions.length; i++) {
      _coinPositions[i] = initialPosition;
      final controller = AnimationController(
        duration: const Duration(milliseconds: 1300),
        vsync: this,
      );
      final animation = Tween<Offset>(
        begin: initialPosition,
        end: _targetPosition!.translate(
          Random().nextDouble() * 20 - 10,
          Random().nextDouble() * 20 - 10,
        ),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
      final fadeAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ));
      _controllers.add(controller);
      _animations.add(animation);
      _fadeAnimations.add(fadeAnimation);
    }
    if (mounted) {
      setState(() {
        _animationsInitialized = true;
      });
    }
  }

  void _startAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * (i + 1)), () {
        _controllers[i].forward().whenComplete(() {
          if (i == _controllers.length - 6) {
            _timer?.cancel();
          }

          if (i == _controllers.length - 1) {
            Future.delayed(const Duration(milliseconds: 50), () {
              if (mounted) {
                setState(() {
                  _coinsAnimationComplete = true;
                });
              }
            });
            _player.play(AssetSource(AudioFiles.successCoin), volume: 4);

            Future.delayed(const Duration(seconds: 5), () {
              if (mounted) {
                setState(() {
                  showNormalCongo = true;
                });
              }
            });
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
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(navigatorKey.currentContext!);
          },
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            child: !_coinsAnimationComplete
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        Images.pointIcon3,
                        width: 60,
                        height: 60,
                      ),
                      Text(
                        "You Won",
                        style: stylePTSansBold(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      const SpacerVertical(height: 20),
                      Text(
                        "${widget.data?.subtitle ?? 0}",
                        style: stylePTSansBold(color: Colors.white),
                      ),
                    ],
                  )
                : showNormalCongo
                    ? Image.asset(Images.congratsGIF1)
                    : AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 500),
                        child: Image.asset(
                          Images.congratsGIF,
                        ),
                      ),
          ),
        ),
        if (_animationsInitialized)
          ...List.generate(
            9,
            (index) {
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: Transform.translate(
                      offset: _animations[index].value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  Images.pointIcon2,
                  width: 35,
                  height: 35,
                ),
              );
            },
          ),
      ],
    );
  }
}

class CongoClaimRes {
  num? points;
  String? subtitle;
  CongoClaimRes({
    this.points,
    this.subtitle,
  });
}
