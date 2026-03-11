import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splash=screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, -10),
          end: Offset(0, -0.5),
        ).animate(
          CurvedAnimation(parent: _iconController, curve: Curves.bounceOut),
        );

    _textSlideAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _iconController.forward();

    _iconController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: SvgPicture.asset("assets/icons/logo.svg"),
              ),
              AnimatedBuilder(
                animation: _textSlideAnimation,
                builder: (context, child) {
                  return ClipRRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _textSlideAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: AnimatedBuilder(
                  animation: _textSlideAnimation,
                  builder: (context, child) {
                    return ClipRRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _textSlideAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    "Ruang Sehat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
