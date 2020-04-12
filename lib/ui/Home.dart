import 'package:flutter/material.dart';

import 'NotoDoScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NotoDo"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: NotoDoScreen(),
    );
  }
}
