import 'package:flutter/material.dart';

class fullpagememe extends StatelessWidget {
  const fullpagememe({Key? key, required this.memeurrl}) : super(key: key);
  final String memeurrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          width: 52,
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.network(memeurrl),
      ),
    );
  }
}
