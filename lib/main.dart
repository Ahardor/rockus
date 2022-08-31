import 'package:flutter/material.dart';
import 'package:rockus/colors.dart';
import 'package:rockus/mainpage.dart';
import 'package:rockus/secondpage.dart';
import 'package:rockus/thirdpage.dart';
import 'dart:html' as html;

//-----------------------------------------------------------------------------//
void main() {
  Paint.enableDithering = true;

  runApp(const MyApp());
}

//-----------------------------------------------------------------------------//

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rockus',
      theme: ThemeData(
        primarySwatch: RockusColors.darkBlueBGColor,
      ),
      home: const MyHomePage(),
    );
  }
}

//-----------------------------------------------------------------------------//

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//-----------------------------------------------------------------------------//

class _MyHomePageState extends State<MyHomePage> {
  late Widget _curPage = MainPage(
    key: UniqueKey(),
    switchPage: changePage,
  );
  Widget _newPage = Container();

//-----------------------------------------------------------------------------//

  void changePage(int id, {double top = 0, double left = 0}) {
    setState(() {
      switch (id) {
        case 1:
          _newPage = SecondPage(
            key: UniqueKey(),
            top: top,
            left: left,
            switchPage: changePage,
          );
          Future.delayed(const Duration(seconds: 2, milliseconds: 100), () {
            setState(() {
              _curPage = Container();
            });
          });
          break;
        case 2:
          _newPage = SecondPage(
            key: UniqueKey(),
            top: top,
            left: left,
            switchPage: changePage,
          );
          Future.delayed(const Duration(seconds: 2, milliseconds: 100), () {
            setState(() {
              _curPage = Container();
            });
          });
          break;

        default:
          Future.delayed(const Duration(seconds: 2), () {
            _newPage = Container();
          });
          _curPage = MainPage(
            key: UniqueKey(),
            switchPage: changePage,
          );
          break;
      }
    });
  }

//-----------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: RockusColors.darkBlueBGColor,
      body: Stack(
        children: [_curPage, _newPage],
      ),
    );
  }
}
