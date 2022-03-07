import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting/models/models.dart';
import 'package:get/get.dart';
import 'package:voting/controller/controllers.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _votingRef;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "owned_votings": [],
      });
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return Get.find<UserController>().fromDocumentSnapshot(doc);
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<DocumentReference?> createVoting(VoteModel voting) async {
    try {
      await _firestore.collection('votings').add({
        'accessCode': voting.accessCode,
        'owner': voting.owner,
        'description': voting.description,
        'title': voting.title,
        'closed': voting.closed,
        'startDate': voting.startTime,
        'endDate': voting.endTime
      }).then((value) {
        _firestore.collection('users').doc(voting.owner).update({
          'ownedVotings': FieldValue.arrayUnion([value.id])
        });
      });
      return _votingRef;
    } catch (err) {
      print("Error during creation of voting is " + err.toString());
      return null;
    }
  }

  Future<VoteModel> getVoting(String _uid, String _electionID) async {
    var data = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('elections')
        .doc(_electionID)
        .get();
    return Get.find<VoteController>().fromDocumentSnapshot(data);
  }

  Future<DocumentSnapshot> candidatesStream(
      String _uid, String _electionId) async {
    var data = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('elections')
        .doc(_electionId)
        .get();
    return data;
  }
}
