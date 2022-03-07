import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting/controller/controllers.dart';
import 'package:flutter/cupertino.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart' show BuildContext, Widget;
import 'package:get/get.dart';
import 'package:voting/screens/StartScreen.dart';
import 'package:voting/screens/screens.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      initState: (_) {
        Get.put(UserController());
      },
      builder: (_) {
        if (Get.find<UserController>().user.name != null) {
          return StartScreenScreen();
        } else {
          return Login();
        }
      },
    );
  }
}
