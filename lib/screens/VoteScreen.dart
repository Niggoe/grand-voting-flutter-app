import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting/screens/screens.dart';
import 'package:voting/widgets/VotingAppBar.dart';
import 'package:get/get.dart';

/** 
 * This is the screen where the user has to vote and enter his choice of answer
 */

class VoteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteScreenState();
}

class VoteScreenState extends State<VoteScreen> {
  bool? userHasVoted;
  String? questionID;
  String? question;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final args = Get.arguments;
    checkUserAnsweredAlready(args.questionID);
    questionID = args.questionID;
    question = args.question;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _queryStream = FirebaseFirestore.instance
        .collection('questions')
        .doc(questionID)
        .collection('answers')
        .snapshots();

    return Scaffold(
      appBar: VotingAppBar(
        appBar: AppBar(),
        title: Text(question!),
        widgets: [],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _queryStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Snapshot has Error:  ${snapshot.error}");
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Not connected to the Stream or null');
              case ConnectionState.active:
                List allAnswers;
                print(snapshot);
                var totalAnswersCount = 0;
                if (snapshot.hasData) {
                  allAnswers = snapshot.data!.docs;
                  totalAnswersCount = allAnswers.length;
                  if (totalAnswersCount > 0) {
                    return GridView.builder(
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: totalAnswersCount,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Card(
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  executeClickOnOption(
                                      allAnswers[index]["answerString"],
                                      questionID,
                                      allAnswers[index].id);
                                },
                                child: Container(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                      ClipRect(
                                          child: Align(
                                              alignment: Alignment.topCenter,
                                              heightFactor: 1.0,
                                              child: Text(allAnswers[index]
                                                  ["answerString"]))),
                                    ])),
                              ),
                            ),
                          );
                        });
                  }
                }
                return Center(
                    child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50.0),
                    ),
                    Text(
                      "Keine Antworten gefunden",
                    )
                  ],
                ));

              case ConnectionState.done:
                return const Text('Not connected to the Stream or null');
              default:
                return const Text('Not connected to the Stream or null');
            }
          }),
    );
  }

  void checkUserAnsweredAlready(String questionId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> allUsersVoted = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .get();
    var data = querySnapshot.data();

    allUsersVoted = data?["userVoted"];
    if (allUsersVoted.contains(userId)) {
      setState(() {
        userHasVoted = true;
      });
    }
    setState(() {
      userHasVoted = false;
    });
  }

  void executeClickOnOption(allAnswer, questionId, id) {
    AlertDialog alert = AlertDialog(
        title: const Text('Confirm'),
        content: Text('Are you sure? You voted for \n\n $allAnswer'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                String userID = FirebaseAuth.instance.currentUser!.uid;
                var listUser = [userID];
                FirebaseFirestore.instance
                    .collection('questions')
                    .doc(questionId)
                    .update({"userVoted": FieldValue.arrayUnion(listUser)});
                print('Answer doc id: $id');
                FirebaseFirestore.instance
                    .collection('questions')
                    .doc(questionId)
                    .collection('answers')
                    .doc(id)
                    .update({"votes": FieldValue.increment(1)});
                setState(() {
                  userHasVoted = true;
                });
                Get.back();
              })
        ]);
    print("ich bin hier");
    if (userHasVoted == true) {
      Get.snackbar("Already Votoed", "You have already voted");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }
}
