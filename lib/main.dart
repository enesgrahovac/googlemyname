import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String googleRed = "#EA4335";
  static String googleGreen = "#34A853";
  static String googleBlue = "#4285F4";
  static String googleYellow = "#FBBC05";
  static String googleMagifyingGlassColor = "#9aa0a6";
  static String googleSearchBorderColor = "#dfe1e5";
  static String googleCancelColor = '#80868b';

  static String googleWhite = "#fff"; // AKA white

  static String googleSearchFont = 'Arial';

  final String defaultText = "Google your Name!";

  bool emptySearchBox = true;

  static String firestoreURL = "https://firebasestorage.googleapis.com/v0/b/myname-5.appspot.com/o/";

  final List<String> googleColorPattern = [
    googleBlue,
    googleRed,
    googleYellow,
    googleBlue,
    googleGreen,
    googleRed
  ];

  // Images
  static Widget magIcon = Image.network(
    firestoreURL + "mag_icon.png?alt=media",
    width: 20,
    height: 20,
    color: Hexcolor(googleMagifyingGlassColor),
  );

  static Widget cancelIcon = Image.network(
    firestoreURL + "cancel_icon.png?alt=media",
    width: 20,
    height: 20,
    color: Hexcolor(googleCancelColor),
  );

  RichText googleName;
  final searchInputController = TextEditingController();
  List<TextSpan> inputLetters = [];

  // Initializer
  @override
  void initState() {
    createGoogleLetters(defaultText);
    emptySearchBox = true;
    super.initState();
  }

  // Function to generate color patterns
  void createGoogleLetters(name, {automated: false}) {
    if (name == "") {
      emptySearchBox = true;
      searchInputController.clear();
      FocusScope.of(context).unfocus();
      createGoogleLetters(defaultText, automated: true);
      return;
    }

    inputLetters = [];
    int patternIndex = 0;
    for (var i = 0; i < name.length; i++) {
      String letter = name[i];
      TextSpan letterStyle;
      if (letter != " ") {
        var stringColorInPattern = googleColorPattern[patternIndex % 6];
        letterStyle = TextSpan(
          text: letter,
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontFamily: 'ProductSans',
            color: Hexcolor(stringColorInPattern),
          ),
        );
        patternIndex += 1;
      } else {
        letterStyle = TextSpan(
          text: letter,
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontFamily: 'ProductSans',
          ),
        );
      }
      inputLetters.add(letterStyle);
    }
    setState(() {
      if (automated == false) {
        emptySearchBox = false;
      }
      // return googleName;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double contentWidth = width * .7;
    double searchbarWidth =
        contentWidth - 98; // width of search bar minus icons
    double googleizedFontSize;
    if (width > 500) {
      googleizedFontSize = 80;
    } else {
      googleizedFontSize = 80 * width / 500;
    }

    googleName = RichText(
      // textAlign: TextAlign.end,
      text: TextSpan(
          style: TextStyle(
            fontSize: googleizedFontSize,
          ),
          children: inputLetters),
    );

    return Scaffold(
      backgroundColor: Hexcolor(googleWhite),
      body: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              child: SingleChildScrollView(
                child: googleName,
              ),
              width: contentWidth,
              height: height * .4,
            ),
            Container(
              width: width,
              height: height * .05,
            ),
            Container(
              width: contentWidth,
              // Search Bar Searchbar
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Hexcolor(googleSearchBorderColor),
                  width: 1,
                ),
                color: Hexcolor(googleWhite),
              ),
              child: Row(
                children: [
                  Container(
                      child: magIcon, padding: EdgeInsets.fromLTRB(14, 0, 14, 0)
                      // color: Colors.red,
                      ),
                  Container(
                    width: searchbarWidth,
                    child: TextField(
                      controller: searchInputController,
                      cursorColor: Colors.black,
                      cursorWidth: 1,
                      enableSuggestions: false,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: googleSearchFont,
                      ),
                      onChanged: (text) {
                        createGoogleLetters(text);
                      },
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        // hintText: 'Enter a search term',
                      ),
                    ),
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (emptySearchBox) // cancelIcon
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                createGoogleLetters("");
                              },
                              child: Container(

                                  // width: 20,
                                  // height:20,
                                  child: cancelIcon,
                                  padding: EdgeInsets.fromLTRB(14, 0, 0, 0)
                                  // color: Colors.red,
                                  ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
