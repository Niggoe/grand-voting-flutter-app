import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voting/bindings/AuthBinding.dart';
import 'package:voting/controller/VoteController.dart';
import 'package:voting/controller/controllers.dart';
import 'package:voting/screens/CreateVoting.dart';
import 'package:voting/screens/LoginScreen.dart';
import 'package:voting/screens/SelectVotingScreen.dart';
import 'package:voting/screens/StartScreen.dart';
import 'package:voting/screens/VoteResultScreen.dart';
import 'package:voting/screens/VoteScreen.dart';
import 'package:voting/screens/VoteSelectScreen.dart';
import 'package:voting/screens/QuestionListScreen.dart';
import 'package:voting/widgets/Root.dart';

import 'controller/AuthController.dart';

class VotingApp extends StatelessWidget {
  VotingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: InitialBindings(),
        initialRoute: "/",
        theme: ThemeData(
          textTheme: GoogleFonts.yanoneKaffeesatzTextTheme(
              Theme.of(context).textTheme),
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: <String, WidgetBuilder>{
          'startScreen': (BuildContext context) => StartScreenScreen(),
          'loginScreen': (BuildContext context) => LoginPage(),
          'searchVotingScreen': (BuildContext context) => VotingSelectScreen(),
          'selectVotingScreen': (BuildContext context) => SelectVotingScreen(),
          'showResultScreen': (BuildContext context) => ResultViewPage(),
          'showVotingScreen': (BuildContext context) =>
              ShowQuestionListScreen(),
          'showAnswerScreen': (BuildContext context) => VoteScreen(),
          'createVotingScreen': (BuildContext context) => CreateVotingScreen()
        },
        home: Root());
  }
}

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<VoteController>(() => VoteController());
    Get.lazyPut<UserController>(() => UserController());
  }
}
