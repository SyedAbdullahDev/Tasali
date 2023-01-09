import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class reloood extends StatefulWidget {
  const reloood({Key? key}) : super(key: key);

  @override
  State<reloood> createState() => _relooodState();
}

class _relooodState extends State<reloood> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Get.back(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.purple),
      ),
    );
  }
}
