import 'package:flutter/material.dart';

class ImcContainer extends StatefulWidget {
  final String result;
  const ImcContainer({super.key, required this.result});

  @override
  State<ImcContainer> createState() => _ImcContainerState();
}

class _ImcContainerState extends State<ImcContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF767676),
        borderRadius: BorderRadius.circular(20),
      ),
      height: 100,
      width: 300,
      child: Center(
        child: Text(
          widget.result,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
