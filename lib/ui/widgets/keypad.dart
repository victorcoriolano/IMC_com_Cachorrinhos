import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDeletePressed;

  const Keypad(
      {super.key, required this.onKeyPressed, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 3.0,
        crossAxisCount: 3,
        mainAxisExtent: 40,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        String buttonText;
        switch (index) {
          case 9:
            buttonText = '.';
            break;
          case 10:
            buttonText = '0';
            break;
          case 11:
            buttonText = '←';
            break;
          default:
            buttonText = '${index + 1}';
        }
        return ElevatedButton(
          onPressed: () {
            if (buttonText == '←') {
              onDeletePressed();
            } else {
              onKeyPressed(buttonText);
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: Colors.grey[300],
            padding: const EdgeInsets.all(5),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        );
      },
    );
  }
}
