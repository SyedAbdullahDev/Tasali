import 'package:flutter/material.dart';
import 'package:tasali/Widgets/video.dart';

class fullpagevid extends StatelessWidget {
  const fullpagevid({Key? key, required this.vidurrl}) : super(key: key);
  final String vidurrl;
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
        child: FeedItem(
                  url:
                      vidurrl,
                )
      ),
    );
  }
}

