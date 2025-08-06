import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_chat_app/widgets/drawer.dart';
import 'package:ai_chat_app/widgets/popup_menu_item_widget.dart';

class GradientBackgroundScreen extends StatefulWidget {
  const GradientBackgroundScreen({super.key});

  @override
  State<GradientBackgroundScreen> createState() =>
      _GradientBackgroundScreenState();
}

class _GradientBackgroundScreenState extends State<GradientBackgroundScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool _isMicOn = true;
  bool _isVolumeOn = true;
  String selectedModel = "gemini";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(160, 255, 92, 119),
      end: const Color.fromARGB(192, 8, 98, 182),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startNewConversation() {
    // Navigate back to chat screen and clear conversation
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: const Color(0xFFF8F6F5),
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            FocusScope.of(context).unfocus();
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: PopupMenuButton<String>(
          offset: const Offset(0, 45),
          onSelected: (String value) {
            setState(() {
              selectedModel = value;
            });
            print('Selected model: $value');
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            buildPopupMenuItem(
              value: 'gemini',
              title: 'Gemini 2.5',
              description: 'Smart',
              selectedModel: selectedModel,
            ),
            buildPopupMenuItem(
              value: 'llama',
              title: 'Llama 4',
              description: 'Fast',
              selectedModel: selectedModel,
            ),
            buildPopupMenuItem(
              value: 'gpt-4',
              title: 'GPT 4.1',
              description: 'Coding',
              selectedModel: selectedModel,
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: const Color(0xFFFCFCFC),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Anzer',
                style: GoogleFonts.ubuntu(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color.fromARGB(255, 99, 95, 95),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.maps_ugc_outlined),
            onPressed: _startNewConversation,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFFF8F6F5), _colorAnimation.value!],
                stops: const [0.75, 1.0],
              ),
            ),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 350.0, sigmaY: 350.0),
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
