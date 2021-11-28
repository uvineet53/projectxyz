import 'package:flutter/material.dart';
import 'package:mentalmath/backend/services/authentication_service.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Auth().signOut();
          },
          child: Text("Sign Out"),
        ),
      ),
    );
  }
}
