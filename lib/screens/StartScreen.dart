import 'package:flutter/material.dart';
import 'package:voting/config/strings.dart';
import 'package:voting/screens/CreateVoting.dart';
import 'package:voting/widgets/VotingAppBar.dart';
import 'package:get/get.dart';

class StartScreenScreen extends StatelessWidget {
  const StartScreenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: VotingAppBar(
          title: const Text(appTitle),
          appBar: AppBar(),
          widgets: const <Widget>[Icon(Icons.more_vert)],
        ),
        body: Column(
          children: [
            Row(
              children: [
                const Flexible(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    decoration:
                        const InputDecoration(helperText: "Enter Voting ID"),
                  ),
                )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: ElevatedButton(
                        onPressed: () => {}, child: Text("Check my votings"))),
              ],
            ),
            Container(
              height: 30,
            ),
            CircleAvatar(
                backgroundImage: AssetImage("assets/images/logoapp.png"),
                radius: 50),
            Container(
              height: 50,
            ),
            Expanded(
                child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              crossAxisSpacing: 5,
              mainAxisSpacing: 15,
              // Generate 100 widgets that display their index in the List.
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.orangeAccent, width: 1),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      children: <Widget>[
                        IconButton(
                            iconSize: 130,
                            onPressed: () {
                              Get.to(() => CreateVotingScreen());
                            },
                            icon: const Icon(Icons.outbox_outlined)),
                        Text("Create Voting")
                      ],
                    )),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.orangeAccent, width: 1),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      children: <Widget>[
                        IconButton(
                            iconSize: 130,
                            onPressed: () {},
                            icon: const Icon(Icons.outbox_outlined)),
                        Text("My votings")
                      ],
                    )),
              ],
            )),
          ],
        ));
  }
}
