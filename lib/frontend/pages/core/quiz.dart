import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:mentalmath/backend/controllers/quizController.dart';

class ProblemPage extends HookWidget {
  final String track;
  ProblemPage({Key? key, required this.track}) : super(key: key);

  QuizController _quizController = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    final _question =
        useState(_quizController.handlerFunction(track)['question']);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_question.value),
            ElevatedButton(
                onPressed: () {
                  _question.value =
                      _quizController.handlerFunction(track)['question'];
                },
                child: Text("Next"))
          ],
        ),
      ),
    );
  }
}
