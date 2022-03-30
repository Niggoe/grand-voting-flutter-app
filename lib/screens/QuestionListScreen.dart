// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting/controller/Database.dart';
import 'package:voting/models/QuestionScreenArguments.dart';
import 'package:get/get.dart';
import '../widgets/VotingAppBar.dart';
import 'package:voting/screens/screens.dart';

class ShowQuestionListScreen extends StatefulWidget {
  const ShowQuestionListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShowQuestionListScreenState();
}

class ShowQuestionListScreenState extends State<ShowQuestionListScreen> {
  bool ownedQuestion = false;
  bool userAnswered = false;
  String? id;

  @override
  void initState() {
    super.initState();
    ownedQuestion = false;
    userAnswered = false;
    id = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: VotingAppBar(
            title: const Text('Pick Question  ...'),
            appBar: AppBar(),
            widgets: const <Widget>[Icon(Icons.more_vert)]),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => CreateQuestionScreen(), arguments: id);
            }),
        body: StreamBuilder<QuerySnapshot>(
            stream: Database().getQuestionsForVoting(id!),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                Get.snackbar('Something went wrong', snapshot.error.toString());
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
                        title: Text(data['questionString']),
                        onTap: () {
                          if (checkIfUserHasNotVoted(data)) {
                            Get.to(() => VoteScreen(),
                                arguments: QuestionScreenArguments(
                                    data['questionString'], document.id));
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
                                            Get.to(() => ResultViewPage(),
                                                arguments: document.id);
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

  bool checkIfUserHasNotVoted(Map<String, dynamic> data) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> allUsersVoted = data["userVoted"];
    if (allUsersVoted.contains(userId)) {
      return false;
    }
    return true;
  }
}
