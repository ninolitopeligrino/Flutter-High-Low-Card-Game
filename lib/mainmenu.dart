// ignore_for_file: camel_case_types, prefer_const_constructors, annotate_overrides, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gameLogic.dart';
import 'dart:math';

class mainMenu extends StatefulWidget {
  const mainMenu({Key? key}) : super(key: key);

  @override
  State<mainMenu> createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  Future getData() async {
    await Future.delayed(Duration(seconds: 3));
    return HomePage();
  }

  Future exitDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are you sure?"),
              content: Text("Do you really wish to exit?"),
              actions: [
                GestureDetector(
                  onTap: () {
                    stopSound();
                    SystemNavigator.pop();
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ));
  }

  Widget build(BuildContext context) {
    playSound("sounds/bg_2.mp3");
    double size_height = MediaQuery.of(context).size.height;
    double size_width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        exitDialog();
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: size_height,
                width: size_width,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/logo.png"))),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        submitPressed = 0;
                        isExit = false;
                        answer = "";
                        score = 0;
                        initCard = Random().nextInt(52) + 1;
                        RecentCards = [
                          "assets/img/$initCard.png",
                          back,
                          back,
                          back,
                          back
                        ];
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FutureBuilder(
                              future: getData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  stopSound();
                                  return HomePage();
                                } else {
                                  return SpinKitWave(
                                      itemBuilder: (context, index) {
                                    final colors = [Colors.white, Colors.red];
                                    final color = colors[index % colors.length];

                                    return DecoratedBox(
                                        decoration: BoxDecoration(
                                      color: color,
                                    ));
                                  });
                                }
                              },
                            ),
                          ));
                    },
                    child: menuChoiceText("New Game", size_height),
                  ),
                  SizedBox(height: 20),
                  isExit
                      ? TextButton(
                          onPressed: null,
                          child: menuChoiceText("Load Game", 20))
                      : TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FutureBuilder(
                                    future: getData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        stopSound();
                                        return HomePage();
                                      } else {
                                        return SpinKitWave(
                                            itemBuilder: (context, index) {
                                          final colors = [
                                            Colors.white,
                                            Colors.red
                                          ];
                                          final color =
                                              colors[index % colors.length];

                                          return DecoratedBox(
                                              decoration: BoxDecoration(
                                            color: color,
                                          ));
                                        });
                                      }
                                    },
                                  ),
                                ));
                          },
                          child: menuChoiceText("Load Game", size_height),
                        ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        exitDialog();
                      },
                      child: menuChoiceText("Quit", size_height)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget menuChoiceText(String text, double height) {
  return Text(
    text,
    style: GoogleFonts.almendraSc(
      fontSize: height * 0.05,
      color: Colors.white,
    ),
  );
}
