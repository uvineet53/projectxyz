import 'dart:convert';

import 'package:alan_voice/alan_voice.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentalmath/backend/constants/testTrackData.dart';
import 'package:mentalmath/backend/controllers/quizController.dart';
import 'package:mentalmath/frontend/pages/core/quiz.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState() {
    AlanVoice.addButton(
        "36cf10a045ad4f147daed15d057fa38b2e956eca572e1d8b807a3e2338fdd0dc/prod");

    AlanVoice.onCommand.add((command) {
      _handleCommand(command.data);
    });
  }

  _handleCommand(Map<String, dynamic> command) {
    print("Command =  $command");
    if (command["commmand"] == "navigate") {
      print('Navigation UJ triggered');
      _handleNavigation(command["route"]);
    }else if(command["command"]=="resultSpoken"){
      _handleAnswer(command["result"]);
    }
  }

  _handleNavigation(String route) {
    if (route == 'back') {
      Navigator.pop(context);
    } else {
      Get.to(ProblemPage(track: route));
    }
  }

  _handleAnswer(String ans) {
    var _quizController = Get.put(QuizController());
    var _question = _quizController.getCurrentQuestion();
    print("ans = " + ans);
    print(_question["question"].toString());
    print(_question["result"].toString());

    if(_question["result"].toString()==ans){
      playText("Correct answer");
    }else{
      playText("Wrong Answer. It is ${_question["result"]}");
    }
  }

  void playText(String text) {
    var params = jsonEncode({"text": text});
    AlanVoice.callProjectApi("script::playText", params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: HStack([
            "Mental".text.black.xl3.make(),
            "Math".text.yellow500.make(),
          ]),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Swiper(
              itemHeight: Get.height * .4,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  key: Key(testTracks[index]['id'].toString()),
                  onTap: () {
                    Get.to(ProblemPage(
                        track: testTracks[index]['track'].toString()));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                                testTracks[index]['image'].toString()),
                            fit: BoxFit.fill,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              testTracks[index]['title'].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      )),
                );
              },
              itemCount: testTracks.length,
              itemWidth: 300,
              layout: SwiperLayout.STACK,
            ),
          ],
        ));
  }

  Column cards() {
    return Column(
      children: testTracks.map((testTrack) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: MaterialButton(
            minWidth: double.infinity,
            height: 100,
            color: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(10),
            key: Key(testTrack['id'].toString()),
            onPressed: () {
              Get.to(ProblemPage(track: testTrack['track'].toString()));
            },
            child: Text(
              testTrack['title'].toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
