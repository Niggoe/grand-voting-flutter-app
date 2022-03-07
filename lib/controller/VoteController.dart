import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voting/controller/controllers.dart';
import 'package:voting/models/VoteModel.dart';
import 'dart:math';
import 'Database.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _random = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));

class VoteController extends GetxController {
  Rx<VoteModel> _electionModel = VoteModel().obs;
  VoteModel currentElection = VoteModel();

  VoteModel get election => _electionModel.value;

  set election(VoteModel value) => this._electionModel.value = value;

  createVoting(title, description, starttime, endtime) {
    VoteModel voting = VoteModel(
        accessCode: getRandomString(6),
        owner: Get.find<UserController>().user.id,
        title: title,
        description: description,
        startTime: starttime,
        endTime: endtime,
        closed: false);

    Database().createVoting(voting);
  }

  bool endVoting() {
    _electionModel.value.endTime = DateTime.now().toString();
    return true;
  }

  VoteModel fromDocumentSnapshot(DocumentSnapshot doc) {
    VoteModel _election = VoteModel();

    _election.id = doc.id;
    _election.accessCode = doc['accessCode'];
    _election.description = doc['description'];
    _election.endTime = doc['endDate'];
    _election.title = doc['title'];
    _election.startTime = doc['startDate'];
    _election.owner = doc['owner'];
    return _election;
  }

  candidatesStream(String _uid, String _electionId) {
    Database().candidatesStream(_uid, _electionId);
  }

  copyAccessCode(String code) {
    //how to copy to the clipboard using dart
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      'COPYING ACCESS CODE',
      'Access code copied successfully',
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
      barBlur: 0.0,
      overlayBlur: 0.0,
      margin: const EdgeInsets.only(top: 200.0),
      icon: Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      backgroundGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo[300]!, Colors.blue]),
    );
  }

  getVoting(String _uid, String _electionID) {
    Database()
        .getVoting(_uid, _electionID)
        .then((_election) => Get.find<VoteController>().election = _election);
  }
}
