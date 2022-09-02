import 'dart:ui';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:rockus/colors.dart';

class ThirdPage extends StatefulWidget {
  ThirdPage({
    Key? key,
    required this.left,
    required this.top,
    required this.switchPage,
    this.a = 0,
  }) : super(key: key);
  final double left, top;
  double a = 0;

  late final Function(int id, {double top, double left}) switchPage;

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage>
    with SingleTickerProviderStateMixin {
  double h = window.physicalSize.height / window.devicePixelRatio / 2;
  double w = window.physicalSize.width / window.devicePixelRatio / 2;

  late Animation<double> animation, animationWidth, animationHeight;
  late AnimationController controller;

  double curLocX = 0, curLocY = 0;
  double startLocX = 0, startLocY = 0;
  double endLocX = 0, endLocY = 0;

  double curHeight = 0, curWidth = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation = Tween<double>(begin: h, end: 0).animate(controller)
      ..addListener(() {
        setState(() {
          curLocX = endLocX * controller.value;
          curLocY = endLocY * controller.value;
          curHeight = (curLocY - startLocY) * controller.value;
          curWidth = (curLocX - startLocX) * controller.value;
        });
      });

    animationWidth =
        Tween<double>(begin: widget.left, end: 0).animate(controller)
          ..addListener(() {
            setState(() {});
          });

    animationHeight =
        Tween<double>(begin: widget.top, end: 0).animate(controller)
          ..addListener(() {
            setState(() {});
          });

    controller.forward().whenComplete(() {
      html.window.open('https://rockus.su/museum', 'new tab');
      html.window.onFocus.listen((event) {
        controller.reverse();
        widget.switchPage(0);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bubble = Container(
      height: curHeight > 0 ? curHeight : 0,
      width: curWidth > 0 ? curWidth : 0,
      child: const Image(
        image: AssetImage('assets/img/bubble.png'),
        fit: BoxFit.contain,
      ),
    );

    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return RelativeBuilder(
        builder: (context, height, width, sy, sx) {
          return Positioned(
            top: animationHeight.value -
                (controller.value * height / 4) * (1 - controller.value),
            left: animationWidth.value -
                (controller.value * width / 4) * (1 - controller.value),
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  startLocX = details.globalPosition.dx;
                  startLocY = details.globalPosition.dy;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  curLocX = details.globalPosition.dx;
                  curLocY = details.globalPosition.dy;
                  curWidth = curLocX - startLocX;
                  curHeight = curLocY - startLocY;
                });
              },
              onPanEnd: (details) {
                if (curHeight * curWidth > width * height / 2) {
                  endLocX = curLocX;
                  endLocY = curLocY;
                  controller.reverse();
                  widget.switchPage(0);
                } else {
                  setState(() {
                    curHeight = 0;
                    curWidth = 0;
                  });
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(animation.value),
                    child: Container(
                      height: controller.value * height,
                      width: controller.value * width,
                      color: RockusColors.darkBlueBGColor,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 200.0, sigmaY: 200.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.0)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * controller.value,
                    width: width * controller.value,
                    child: const Image(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/img/museum.png'),
                    ),
                  ),
                  Positioned(
                    top: startLocY,
                    left: startLocX,
                    child: bubble,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
