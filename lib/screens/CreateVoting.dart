import 'package:flutter/material.dart';
import 'package:voting/controller/UserController.dart';
import 'package:voting/controller/VoteController.dart';
import 'package:voting/screens/StartScreen.dart';
import 'package:voting/widgets/InputField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:voting/widgets/widgets.dart';

VoteController? _voteController;

TextEditingController _voteTitleController = TextEditingController();
TextEditingController _voteDescriptionController = TextEditingController();
TextEditingController _voteStartDateController = TextEditingController();
TextEditingController _voteEndDateController = TextEditingController();
final owner = Get.find<UserController>().user;

class CreateVotingScreen extends StatelessWidget {
  const CreateVotingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _voteTitleController.text = '';
    _voteDescriptionController.text = '';
    _voteStartDateController.text = '';
    _voteEndDateController.text = '';
    _voteController = Get.put(VoteController());
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      body: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
            sliver: SliverToBoxAdapter(
                child: Image(
              image: AssetImage('assets/images/logoapp.png'),
            )),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'CREATE NEW ELECTION',
                style: GoogleFonts.yanoneKaffeesatz(
                    fontSize: 28.0,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    InputField(
                      controller: _voteTitleController,
                      hintText: 'Enter the vote\'s name',
                      prefixIcon: Icons.person,
                      label: "VoteName",
                      obscure: false,
                    ),
                    InputField(
                      controller: _voteDescriptionController,
                      hintText: 'Enter the election\'s description',
                      prefixIcon: Icons.edit,
                      label: "VoteName",
                      obscure: false,
                    ),
                    VoteDate(
                        controller: _voteStartDateController,
                        title: 'START DATE',
                        hint: 'Start date of the election',
                        prefixIcon: Icons.calendar_view_day),
                    VoteDate(
                        controller: _voteEndDateController,
                        title: 'END DATE',
                        hint: 'End date of the election',
                        prefixIcon: Icons.date_range)
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin:
                  const EdgeInsets.only(left: 55.0, bottom: 20.0, right: 55.0),
              decoration: BoxDecoration(
                  color: Colors.indigo[400],
                  borderRadius: BorderRadius.circular(18.0)),
              child: FlatButton.icon(
                label: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                icon: const Icon(
                  Icons.next_plan,
                  size: 32.0,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await _voteController?.createVoting(
                      _voteTitleController.text,
                      _voteDescriptionController.text,
                      _voteStartDateController.text,
                      _voteEndDateController.text);
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
