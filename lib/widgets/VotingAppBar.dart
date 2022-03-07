import 'package:flutter/material.dart';
import 'package:voting/config/strings.dart';
import 'package:get/get.dart';
import 'package:voting/controller/AuthController.dart';

class VotingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = const Color(0xFFff7b6c);
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;

  const VotingAppBar(
      {Key? key,
      required this.title,
      required this.appBar,
      required this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: title,
      actions: [
        IconButton(
            color: Colors.white,
            icon: Icon(Icons.logout_rounded),
            onPressed: () {
              Get.find<AuthController>().signOut();
            }),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
