import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:mentalmath/backend/controllers/quizController.dart';

class ProblemPage extends HookWidget {
  final String track;
  ProblemPage({Key? key, required this.track}) : super(key: key);

  QuizController _quizController = Get.put(QuizController());
  TextEditingController answerController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  String buttonText(int value) {
    switch (value) {
      case 0:
        return "Check Answer";
      case 1:
        return "Correct Answer";
      case -1:
        return "Wrong Answer";
    }
    return "Check Answer";
  }

  @override
  Widget build(BuildContext context) {
    final _question = useState(_quizController.handlerFunction(track));
    final _buttonColor = useState(Colors.orange);
    final _isCorrect = useState(0);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _question.value['question'],
                  style: TextStyle(fontSize: 35),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: answerController,
                  validator: (value) {
                    if (value!.isNotEmpty &&
                        value != _question.value['result'].toString()) {
                      return 'Wrong Answer!';
                    } else if (value.isEmpty) {
                      return 'No answer added!';
                    }
                  },
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      hintText: "What's your answer?",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                    minWidth: double.infinity,
                    color: _buttonColor.value,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        _buttonColor.value = Colors.green;
                        _isCorrect.value = 1;
                      } else {
                        _buttonColor.value = Colors.red;
                        _isCorrect.value = -1;
                      }
                    },
                    child: Text(
                      buttonText(_isCorrect.value),
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.black,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      _isCorrect.value = 0;
                      answerController.clear();
                      _buttonColor.value = Colors.orange;
                      _question.value = _quizController.handlerFunction(track);
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
