import 'package:flutter/material.dart';
import 'dart:ui';

class GradientBackgroundScreen extends StatefulWidget {
  const GradientBackgroundScreen({super.key});

  @override
  State<GradientBackgroundScreen> createState() =>
      _GradientBackgroundScreenState();
}

class _GradientBackgroundScreenState extends State<GradientBackgroundScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool _isMicOn = true;
  bool _isVolumeOn = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFFFF5C77),
      end: const Color.fromARGB(255, 5, 3, 131),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFF8F6F5),
                  _colorAnimation.value!,
                ],
                stops: const [0.75, 1.0],
              ),
            ),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
                  child: Container(color: Color(0xFFF8F6F5).withOpacity(0.1)),
                ),
                Center(
                  child: Opacity(
                    opacity: 0.2,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey.withOpacity(0.5),
                        BlendMode.modulate,
                      ),
                      child: Image.asset(
                        'assets/images/logo-anzer.png',
                        width: 230,
                        height: 230,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            topLeft: Radius.circular(40),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 200.0,
                              sigmaY: 200.0,
                            ),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: _isMicOn
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : const Color.fromARGB(
                                        255,
                                        255,
                                        112,
                                        93,
                                      ).withValues(alpha: 0.7),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                border: Border.all(
                                  color: _isMicOn
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : const Color.fromARGB(
                                          255,
                                          255,
                                          112,
                                          93,
                                        ).withValues(alpha: 0.7),
                                  width: 0.1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isMicOn = !_isMicOn;
                                  });
                                },
                                style: IconButton.styleFrom(
                                  overlayColor: Colors.transparent,
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                icon: Icon(
                                  _isMicOn
                                      ? Icons.mic_none
                                      : Icons.mic_off_outlined,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 9),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 15.0,
                              sigmaY: 15.0,
                            ),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: _isVolumeOn
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : const Color.fromARGB(
                                        255,
                                        255,
                                        112,
                                        93,
                                      ).withValues(alpha: 0.7),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                border: Border.all(
                                  color: _isVolumeOn
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : const Color.fromARGB(
                                          255,
                                          255,
                                          112,
                                          93,
                                        ).withValues(alpha: 0.7),
                                  width: 0.1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isVolumeOn = !_isVolumeOn;
                                  });
                                },
                                style: IconButton.styleFrom(
                                  overlayColor: Colors.transparent,
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                icon: Icon(
                                  _isVolumeOn
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: const Color.fromARGB(192, 0, 0, 0),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 9),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 15.0,
                              sigmaY: 15.0,
                            ),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // More options action
                                },
                                style: IconButton.styleFrom(
                                  overlayColor: Colors.transparent,
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Color.fromARGB(192, 0, 0, 0),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 15.0,
                              sigmaY: 15.0,
                            ),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: IconButton.styleFrom(
                                  overlayColor: Colors.transparent,
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                icon: const Icon(
                                  Icons.close,
                                  color: Color.fromARGB(192, 0, 0, 0),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}