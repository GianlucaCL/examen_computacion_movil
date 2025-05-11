import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backDownDecor(),
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: [
        const AuthBackgorundC1(),
        SafeArea(
            child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          child: const Icon(
            Icons.local_mall,
            color: Colors.white,
            size: 100,
          ),
        )),
        child,
      ]),
    );
  }

  BoxDecoration backDownDecor() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 163, 56, 224),
        Color.fromARGB(255, 97, 11, 210),
      ]));
}
