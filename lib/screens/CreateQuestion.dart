import 'package:flutter/material.dart';
import 'package:voting/controller/QuestionController.dart';
import 'package:voting/controller/UserController.dart';
import 'package:get/get.dart';
import 'package:voting/models/question.dart';
import 'package:voting/screens/QuestionListScreen.dart';

import '../widgets/VotingAppBar.dart';

QuestionController? _questionController;

final owner = Get.find<UserController>().user;

class CreateQuestionScreen extends StatefulWidget {
  _CreateQuestionScreenState createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _questionTextController;
  static List<String> answerList = <String>[""];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _questionController = Get.put(QuestionController());
    _questionTextController = TextEditingController();
    answerList = <String>[""];
  }

  @override
  void dispose() {
    _questionTextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String votingID = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: VotingAppBar(
          title: const Text('Pick Question  ...'),
          appBar: AppBar(),
          widgets: const <Widget>[Icon(Icons.more_vert)]),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: TextFormField(
                  controller: _questionTextController,
                  decoration: InputDecoration(hintText: 'Question'),
                  validator: (v) {
                    if (v!.trim().isEmpty) return 'Please enter something';
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ..._getFriends(),
              Text(
                'Add Answers',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              SizedBox(
                height: 40,
              ),
              FlatButton(
                onPressed: () {
                  print(answerList);
                  if (_formKey.currentState!.validate()) {
                    _questionController?.createQuestion(
                        _questionTextController!.text.toString(),
                        answerList,
                        votingID);
                  }
                  Get.back();
                },
                child: Text('Submit'),
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < answerList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: QuestionAnswerTextField(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == answerList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          answerList.insert(0, "");
        } else
          answerList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class QuestionAnswerTextField extends StatefulWidget {
  final int index;
  QuestionAnswerTextField(this.index);
  @override
  _QuestionAnswerTextFieldState createState() =>
      _QuestionAnswerTextFieldState();
}

class _QuestionAnswerTextFieldState extends State<QuestionAnswerTextField> {
  TextEditingController? answerController;

  @override
  void initState() {
    super.initState();
    answerController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    answerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      answerController?.text =
          _CreateQuestionScreenState.answerList[widget.index];
    });
    return TextFormField(
      controller: answerController,
      onChanged: (v) => _CreateQuestionScreenState.answerList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Enter your friend\'s name'),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
