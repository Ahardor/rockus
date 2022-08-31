import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:rockus/colors.dart';

//-----------------------------------------------------------------------------//

class Pair {
  const Pair(this.height, this.width);

  final double height;
  final double width;

  @override
  String toString() => 'Pair[$height, $width]';
}

//-----------------------------------------------------------------------------//

class Element extends StatefulWidget {
  Element({
    Key? key,
    this.size = const Pair(0.0, 0.0),
    required this.tap,
    this.dur = 1500,
    this.coef = -1,
  }) : super(key: key);

//-----------------------------------------------------------------------------//

  Element.based({
    Key? key,
    required this.offset,
    this.size = const Pair(0.0, 0.0),
    required this.tap,
    this.dur = 1500,
    this.coef = -1,
  })  : setBase = true,
        super(key: key);

//-----------------------------------------------------------------------------//

  Element.image({
    Key? key,
    required this.img,
    this.size = const Pair(0.0, 0.0),
    required this.tap,
    this.dur = 1500,
    this.coef = -1,
  })  : imaged = true,
        super(key: key);

//-----------------------------------------------------------------------------//

  Element.imageBased({
    Key? key,
    required this.img,
    required this.offset,
    this.size = const Pair(0.0, 0.0),
    required this.tap,
    this.dur = 1500,
    this.coef = -1,
  })  : imaged = true,
        setBase = true,
        super(key: key);

//-----------------------------------------------------------------------------//

  Pair offset = Pair(0.0, 0.0);
  bool setBase = false;
  bool imaged = false;
  late String img;
  Pair size = Pair(0.0, 0.0);
  int dur;
  double coef;

  late final Function() tap;

  @override
  State<Element> createState() => _ElementState();
}

//-----------------------------------------------------------------------------//

class _ElementState extends State<Element> {
  Pair _position = Pair(0, 0);
  Pair _base = Pair(0, 0);
  late double _coef;
  late bool _isBaseSet;
  bool _isTapped = false;
  int _dur = 1500;
  Pair _size = Pair(0, 0);
  var _gHeight = window.physicalSize.height / window.devicePixelRatio / 2;
  var _gWidth = window.physicalSize.width / window.devicePixelRatio / 2;

//-----------------------------------------------------------------------------//

  @override
  void initState() {
    super.initState();
    setState(
      () {
        _dur = widget.dur;
        _isBaseSet = widget.setBase;
        if (widget.setBase) {
          _base = Pair(_gHeight - widget.offset.height - _size.height / 2,
              _gWidth - widget.offset.width - _size.width / 2);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => a());
        WidgetsBinding.instance.addTimingsCallback((_) {
          if (!mounted) return;
          _gHeight = window.physicalSize.height / window.devicePixelRatio / 2;
          _gWidth = window.physicalSize.width / window.devicePixelRatio / 2;
        });
      },
    );
  }

//-----------------------------------------------------------------------------//

  void a() {
    if (!mounted) return;

    setState(
      () {
        if (!_isTapped) {
          _position = Pair(
              _base.height + Random().nextDouble() * _coef - _coef / 2,
              _base.width + Random().nextDouble() * _coef - _coef / 2);

          Future.delayed(Duration(milliseconds: _dur), () => a());
        }
      },
    );
  }

//-----------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        if (widget.size.height != 0) _size = widget.size;
        _coef = widget.coef == -1 ? sx(5) : widget.coef;
        if ((!_isBaseSet ||
                _base.height !=
                    _gHeight - widget.offset.height - _size.height / 2 ||
                _base.width !=
                    _gWidth - widget.offset.width - _size.width / 2) &&
            !_isTapped) {
          _position = Pair(_gHeight - widget.offset.height - _size.height / 2,
              _gWidth - widget.offset.width - _size.width / 2);

          _base = Pair(_position.height, _position.width);

          _isBaseSet = true;
        }

//-----------------------------------------------------------------------------//

        return AnimatedPositioned(
          top: _position.height,
          left: _position.width,
          duration: Duration(milliseconds: _dur),
          child: GestureDetector(
            onPanUpdate: (details) {
              if (!mounted) return;
              setState(
                () {
                  _isTapped = true;
                  _dur = 50;
                  _position = Pair(details.globalPosition.dy - _size.height / 2,
                      details.globalPosition.dx - _size.width / 2);

                  widget.tap();
                },
              );
            },
            onPanEnd: (details) {
              if (!mounted) return;
              setState(() {
                _isTapped = false;
                _dur = widget.dur;
              });
              a();
            },
            child: Container(
              // color: Color(0x1000FF00),
              height: _size.height,
              width: _size.width,
              child: Stack(
                children: [
                  Center(
                    child: widget.imaged
                        ? Container(
                            height: 200,
                            width: 200,
                            child: Image(
                              image: AssetImage(widget.img),
                            ),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: !widget.imaged
                        ? ShaderMask(
                            blendMode: BlendMode.modulate,
                            shaderCallback: (Rect bounds) {
                              return const RadialGradient(
                                colors: [Colors.white, Colors.grey],
                              ).createShader(Rect.fromLTWH(
                                  0, 0, _size.width / 1.2, _size.height / 0.8));
                            },
                            child: Text(
                              'ROCKUS',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.bold,
                                  fontSize: sy(30) * 0.5 + sx(10) * 0.5,
                                  color: Colors.white),
                            ),
                          )
                        : const Image(
                            color: Color(0xA0FFFFFF),
                            image: AssetImage('assets/img/bubble.png'),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//-----------------------------------------------------------------------------//

class MainPage extends StatefulWidget {
  MainPage({
    Key? key,
    required this.switchPage,
  }) : super(key: key);

  late final Function(int id, {double top, double left}) switchPage;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
//-----------------------------------------------------------------------------//

  late Animation<double> animation;
  late AnimationController controller;

  List<Widget> widgets = [];

  final _rockusKey = GlobalKey();
  final _bubbleKey1 = GlobalKey();
  final _bubbleKey2 = GlobalKey();

  late Widget _bubble1, _bubble2;

//-----------------------------------------------------------------------------//

  void _play(bool forward) {
    if (forward) {
      controller.forward().then((value) => _play(false));
    } else {
      controller.reverse().then((value) => _play(true));
    }
  }

//-----------------------------------------------------------------------------//

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

//-----------------------------------------------------------------------------//

    controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    animation = Tween<double>(begin: 0.5, end: 0.8).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    _play(true);

//-----------------------------------------------------------------------------//

//-----------------------------------------------------------------------------//

    widgets.add(RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return Element(
          key: _rockusKey,
          size: Pair(sy(38), sx(40) * 0.5 + sy(110) * 0.5),
          tap: () {
            _onCheckTap(_bubble1);
            _onCheckTap(_bubble2);
          },
          dur: 500,
          coef: sx(3),
        );
      },
    ));

    _bubble1 = RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return Element.imageBased(
          key: _bubbleKey1,
          img: 'assets/img/Webinfo.png',
          offset: Pair(sx(100), sx(100)),
          size: Pair(sx(70), sx(70)),
          tap: () => _onCheckTap(_bubble1),
        );
      },
    );

    widgets.add(_bubble1);

    _bubble2 = RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return Element.imageBased(
          key: _bubbleKey2,
          img: 'assets/img/Webinfo.png',
          offset: Pair(sx(-100), sx(-100)),
          size: Pair(sx(70), sx(70)),
          tap: () => _onCheckTap(_bubble2),
        );
      },
    );

    widgets.add(_bubble2);
  }

  void _onCheckTap(Widget bubble) {
    var st = (bubble == _bubble1 ? _bubbleKey1 : _bubbleKey2).currentState;
    if (st != null && st.mounted) {
      RenderBox box0 =
          _rockusKey.currentContext?.findRenderObject() as RenderBox;
      RenderBox box1 = (bubble == _bubble1 ? _bubbleKey1 : _bubbleKey2)
          .currentContext
          ?.findRenderObject() as RenderBox;

      final size0 = box0.size;
      final size1 = box1.size;

      final position0 = box0.localToGlobal(Offset.zero);
      final position1 = box1.localToGlobal(Offset.zero);

      final b1 = position0.dx < position1.dx + size1.width &&
          position0.dx + size0.width > position1.dx &&
          position0.dy < position1.dy + size1.height &&
          position0.dy + size0.height > position1.dy;
      if (b1) {
        widget.switchPage(
          bubble == _bubble1 ? 1 : 2,
          top: position1.dy + size1.height,
          left: position1.dx + size1.width,
        );
        widgets.remove(bubble);
      }
    }
  }

//-----------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: animation.value,
          colors: const [
            RockusColors.lightBlueBGColor,
            RockusColors.darkBlueBGColor,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: widgets,
      ),
    );
  }
}
