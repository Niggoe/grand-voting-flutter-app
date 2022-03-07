// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting/models/QuestionScreenArguments.dart';

import '../widgets/VotingAppBar.dart';

class ShowQuestionListScreen extends StatefulWidget {
  const ShowQuestionListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShowQuestionListScreenState();
}

class ShowQuestionListScreenState extends State<ShowQuestionListScreen> {
  bool ownedQuestion = false;
  bool userAnswered = false;

  @override
  void initState() {
    super.initState();
    ownedQuestion = false;
    userAnswered = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final args = ModalRoute.of(context)!.settings.arguments;
    log(args.toString());
    final Stream<QuerySnapshot> _queryStream = FirebaseFirestore.instance
        .collection('questions')
        .where("votingID", isEqualTo: args)
        .orderBy('order', descending: false)
        .snapshots();

    return Scaffold(
        appBar: VotingAppBar(
            title: const Text('Pick Question  ...'),
            appBar: AppBar(),
            widgets: const <Widget>[Icon(Icons.more_vert)]),
        body: StreamBuilder<QuerySnapshot>(
            stream: _queryStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                log(snapshot.error.toString());
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.album),
                        title: Text(data['question']),
                        onTap: () {
                          if (false) {
                            Navigator.of(context).pushNamed('showAnswerScreen',
                                arguments: QuestionScreenArguments(
                                    data['question'], document.id));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Sorry'),
                                      content: const Text(
                                          'You have already voted!!'),
                                      actions: <Widget>[
                                        IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            })
                                      ],
                                    ));
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FutureBuilder(
                            future: getValueFromDocument(data),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                case ConnectionState.done:
                                  if (snapshot.hasError)
                                    return Text(snapshot.error.toString());
                                  else
                                    return TextButton(
                                        onPressed: () {
                                          print(snapshot.data);
                                          if (snapshot.data == true) {
                                            Navigator.pushNamed(
                                                context, 'showResultScreen');
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Not yet voted or your voting")));
                                          }
                                        },
                                        child: Text("Ergebnisse"));

                                default:
                                  return Text('Unhandle State');
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList());
            }));
  }

  Future<bool> getValueFromDocument(Map<String, dynamic> data) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> allUsersVoted = data["userVoted"];
    if (allUsersVoted.contains(userId)) {
      return FirebaseFirestore.instance
          .collection('votings')
          .doc(data["votingID"])
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get("owner") == userId) {
            print("user there");
            return true;
          }
        }
        return false;
      });
    }
    {
      return false;
    }
  }
}
