import 'package:flutter/material.dart';
import 'package:voting/config/strings.dart';

import '../widgets/VotingAppBar.dart';

class VotingSelectScreen extends StatefulWidget {
  const VotingSelectScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => VotingSelectScreenState();
}

class VotingSelectScreenState extends State<VotingSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VotingAppBar(
        title: const Text(appTitle),
        appBar: AppBar(),
        widgets: const <Widget>[Icon(Icons.more_vert)],
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
              ),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: textFieldSearchVoting),
              ),
              ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, 'selectVotingScreen'),
                  child: const Text(buttonSearchVotings)),
            ],
          )),
    );
  }
}
