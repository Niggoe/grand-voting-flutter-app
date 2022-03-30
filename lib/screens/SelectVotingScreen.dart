import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting/controller/Database.dart';
import 'package:voting/controller/controllers.dart';
import 'package:voting/widgets/VotingAppBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'QuestionListScreen.dart';

class SelectVotingScreen extends StatefulWidget {
  const SelectVotingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SelectVotingScreenState();
}

class SelectVotingScreenState extends State<SelectVotingScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var uid = Get.find<UserController>().user.id;
    print('User Id from logged in users: ' + uid!);

    return Scaffold(
        appBar: VotingAppBar(
            title: const Text('Select Voting'),
            appBar: AppBar(),
            widgets: const <Widget>[Icon(Icons.more_vert)]),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => SelectVotingScreen());
            }),
        body: StreamBuilder<QuerySnapshot>(
            stream: Database().getVotingsForUser(uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              print("found results: " + snapshot.data!.size.toString());
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
                        title: Text(data['title']),
                        subtitle: Text(data['description']),
                        onTap: () {
                          if (!checkForwarding(data)) {
                            Get.to(() => ShowQuestionListScreen(),
                                arguments: document.id);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Sorry'),
                                      content:
                                          const Text('Voting already closed!'),
                                      actions: <Widget>[
                                        IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Get.back();
                                            })
                                      ],
                                    ));
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.circle,
                            color: data["closed"] == true
                                ? Colors.red
                                : Colors.green,
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

  bool checkForwarding(Map<String, dynamic> data) {
    return data["closed"];
  }
}
