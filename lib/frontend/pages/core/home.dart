import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentalmath/backend/constants/testTrackData.dart';
import 'package:mentalmath/frontend/pages/core/quiz.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Mental Math - Demo",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: testTracks.map((testTrack) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 100,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
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
          ),
        ));
  }
}
