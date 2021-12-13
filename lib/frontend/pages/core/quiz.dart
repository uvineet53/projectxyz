import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:mentalmath/backend/controllers/quizController.dart';
import 'package:velocity_x/velocity_x.dart';

class ProblemPage extends HookWidget {
  final String track;
  ProblemPage({Key? key, required this.track}) : super(key: key);
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 10;

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

  final _countdownController = CountDownController();
  void sendData(String question, String result) {
    question = "What is $question ?";
    var params = jsonEncode({"question": question, "result": result});
    AlanVoice.callProjectApi("script::playQuestion", params);
  }

  @override
  Widget build(BuildContext context) {
    final _question = useState(_quizController.handlerFunction(track));
    sendData(_question.value['question'], _question.value['result'].toString());
    final _buttonColor = useState(Colors.orange);
    final _isCorrect = useState(0);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularCountDownTimer(
                    duration: 30,
                    initialDuration: 0,
                    controller: _countdownController,
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: MediaQuery.of(context).size.height / 2.8,
                    ringColor: Vx.gray100,
                    ringGradient: null,
                    fillColor: Vx.blue300,
                    fillGradient: null,
                    backgroundColor: Vx.blue500,
                    backgroundGradient: null,
                    strokeWidth: 20.0,
                    strokeCap: StrokeCap.round,
                    textStyle: TextStyle(
                        fontSize: 33.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textFormat: CountdownTextFormat.S,
                    isReverse: true,
                    isReverseAnimation: true,
                    isTimerTextShown: true,
                    autoStart: true,
                    onStart: () {
                      print('Countdown Started');
                    },
                    onComplete: () {
                      print('Countdown Ended');
                      _isCorrect.value = 0;
                      answerController.clear();
                      _buttonColor.value = Colors.blue;
                      _question.value = _quizController.handlerFunction(track);
                      _countdownController.restart(duration: 30);
                    },
                  ),
                  Text(
                    _question.value['question'],
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                      // sendData(_question.value['question']);
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
                        _countdownController.pause();
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
                        _countdownController.restart(duration: 30);
                        _isCorrect.value = 0;
                        answerController.clear();
                        _buttonColor.value = Colors.blue;
                        _question.value =
                            _quizController.handlerFunction(track);
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
