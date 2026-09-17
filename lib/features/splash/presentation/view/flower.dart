import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FlowerView extends StatefulWidget {
  const FlowerView({super.key});

  @override
  State<FlowerView> createState() => _FlowerViewState();
}

class _FlowerViewState extends State<FlowerView> with TickerProviderStateMixin {
  late final AnimationController _flowerController;
  late final AnimationController _textController;

  late final Animation<double> _flowerOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Flower animation
    _flowerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _flowerOpacity = CurvedAnimation(
      parent: _flowerController,
      curve: Curves.easeIn,
    );

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    final textCurve = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    );

    _textOpacity = textCurve;

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(textCurve);

    // Start flower first
    _flowerController.forward();

    // Start text slightly after flower
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _flowerController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Stack(
        children: [
          // Background Flower
          FadeTransition(
            opacity: _flowerOpacity,
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: .7),
                    Colors.transparent,
                  ],
                  stops: const [0.3, 0.9],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                AppImages.flowerImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // Logo + Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppImages.flowerddd, width: 120),

                const SizedBox(height: 16),

                // Flowery animation
                FadeTransition(
                  opacity: _textOpacity,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Text(
                      'Flowery',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.purpleBase,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
