// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:final_project/gameLogic.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget cardsContainer(double height, double width, String card) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      child: Image.asset(card),
      height: height,
      width: width,
    ),
  );
}

Widget guessCardContainer(double height, double width) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      child: FlipCard(
        controller: controller,
        front: Image.asset(back),
        back: Image.asset(guessCard),
        flipOnTouch: false,
      ),
      height: height,
      width: width,
    ),
  );
}

Widget miniBoxDisplayChoice() {
  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        child: Center(
          child: Text(
            answer,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        color: Colors.white,
        height: 50,
        width: 50,
      ),
    ),
  );
}

TextStyle scoreTextStyle = GoogleFonts.almendraSc(
  fontSize: 40,
  color: Colors.white,
  shadows: [
    BoxShadow(
      color: Colors.purple,
      spreadRadius: 2,
      blurRadius: 8,
      offset: Offset(4, 4),
    ),
  ],
);

Widget btn(double height, double width, String btnText) {
  return Container(
    child: Center(
      child: Text(
        btnText,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
    height: height,
    width: width * .2,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.purple,
          spreadRadius: 1,
          blurRadius: 8,
          offset: Offset(4, 4),
        ),
        BoxShadow(
          color: Colors.grey.shade300,
          spreadRadius: 2,
          blurRadius: 8,
          offset: Offset(-4, -4),
        ),
      ],
    ),
  );
}
