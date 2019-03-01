import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image(
          image: AssetImage('lib/src/assets/logo-black.png'),
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
    
  }
}