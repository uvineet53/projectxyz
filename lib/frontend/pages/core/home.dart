import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentalmath/backend/constants/testTrackData.dart';
import 'package:mentalmath/frontend/pages/core/quiz.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
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
