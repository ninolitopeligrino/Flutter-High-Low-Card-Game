// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:audioplayers/audioplayers.dart';
import 'package:final_project/gameLogic.dart';
import 'package:final_project/mainmenu.dart';
import 'package:flutter/material.dart';
import 'customWidget.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void gameFunction() {
    if (answer == ">=") {
      if (cards[RecentCards[0]]! >= cards[guessCard]!) {
        correctDialog();
      } else {
        gameOverDialog();
      }
    } else if (answer == "<") {
      if (cards[RecentCards[0]]! < cards[guessCard]!) {
        correctDialog();
      } else {
        gameOverDialog();
      }
    }
  }

  void isCorrect() {
    Navigator.of(context).pop(false);
    setState(() {
      answer = "";
      score++;
      RecentCards.insert(0, guessCard);
    });
  }

  void resetGame() {
    Navigator.of(context).pop(false);
    setState(() {
      answer = "";
      score = 0;
      initCard = Random().nextInt(52) + 1;
      RecentCards = ["assets/img/$initCard.png", back, back, back, back];
    });
  }

  Future gameOverDialog() async {
    await Future.delayed(Duration(seconds: 1));
    AudioPlayer gameOverSound = await AudioCache().play('sounds/gameover.mp3');
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Image.asset(
                    "assets/wrong.png",
                    height: 50,
                    width: 50,
                  ),
                  Text("GAME OVER"),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: isOne()
                  ? Text("You've got $score point")
                  : Text("You've got $score points"),
              actions: [
                TextButton(
                    onPressed: () {
                      submitPressed = 0;
                      controller.toggleCard();
                      resetGame();
                      gameOverSound.stop();
                    },
                    child: Text("Play Again")),
                TextButton(
                    onPressed: () {
                      isExit = true;
                      stopSound();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => mainMenu()));
                    },
                    child: Text("Main Menu")),
              ],
            ));
  }

  Future correctDialog() async {
    await Future.delayed(Duration(seconds: 1));
    AudioPlayer correctAnswerSound =
        await AudioCache().play('sounds/correct_answer.mp3');
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Image.asset("assets/correct.png", height: 50, width: 50),
                    Text("You're Correct")
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                      onPressed: () {
                        correctAnswerSound.stop();
                        isCorrect();
                        controller.toggleCard();
                        setState(() {
                          submitPressed = 0;
                        });
                      },
                      child: Text("Ok"))
                ]));
  }

  void errorCheck() {
    setState(() {
      if (answer == "") {
        const snackbar = SnackBar(
            content: Text("Error. Choose between >= or < before submitting. "));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        submitPressed = 0;
      } else {
        guessCardNumber = Random().nextInt(52) + 1;
        guessCard = "assets/img/$guessCardNumber.png";
        controller.toggleCard();
        gameFunction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    playSound("sounds/bg_1.mp3");
    highScore();
    return WillPopScope(
      onWillPop: () async {
        stopSound();
        playSound("sounds/bg_2.mp3");
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: OrientationBuilder(
            builder: (context, orientation) =>
                orientation == Orientation.portrait
                    ? buildPortrait(context)
                    : buildLandscape(context),
          ),
        ),
      ),
    );
  }

  Widget buildPortrait(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Score",
                        style: scoreTextStyle,
                      ),
                      Text("$score", style: scoreTextStyle),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Best", style: scoreTextStyle),
                      Text(
                        "$high_Score",
                        style: scoreTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cardsContainer(size.height, size.width * .3, RecentCards[0]),
                  miniBoxDisplayChoice(),
                  guessCardContainer(size.height, size.width * .3)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    cardsContainer(
                        size.height, size.width * .2, RecentCards[1]),
                    cardsContainer(
                        size.height, size.width * .2, RecentCards[2]),
                    cardsContainer(
                        size.height, size.width * .2, RecentCards[3]),
                    cardsContainer(
                        size.height, size.width * .2, RecentCards[4]),
                  ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          answer = ">=";
                        });
                      },
                      child: btn(size.height, size.width, ">=")),
                  GestureDetector(
                      onTap: () {
                        submitPressed++;
                        if (submitPressed == 1) {
                          errorCheck();
                        }
                      },
                      child: btn(size.height, size.width, "Submit")),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          answer = "<";
                        });
                      },
                      child: btn(size.height, size.width, "<")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLandscape(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardsContainer(
                          size.height * .3, size.width * .1, RecentCards[2]),
                      cardsContainer(
                          size.height * .3, size.width * .1, RecentCards[1]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardsContainer(
                          size.height * .3, size.width * .1, RecentCards[3]),
                      cardsContainer(
                          size.height * .3, size.width * .1, RecentCards[4]),
                    ],
                  ),
                ],
              )),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardsContainer(
                          size.height * .4, size.width * .15, RecentCards[0]),
                      miniBoxDisplayChoice(),
                      guessCardContainer(size.height * .4, size.width * .15)
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    answer = ">=";
                                  });
                                },
                                child: btn(size.height, size.width * .7, ">=")),
                            GestureDetector(
                                onTap: () {
                                  submitPressed++;
                                  if (submitPressed == 1) {
                                    errorCheck();
                                  }
                                },
                                child: btn(
                                    size.height, size.width * .7, "Submit")),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    answer = "<";
                                  });
                                },
                                child: btn(size.height, size.width * .7, "<")),
                          ]),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Score",
                      style: scoreTextStyle,
                    ),
                    Text(
                      "$score",
                      style: scoreTextStyle,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Best",
                      style: scoreTextStyle,
                    ),
                    Text(
                      "$high_Score",
                      style: scoreTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
