import 'package:flutter/material.dart';

class DogImage extends StatefulWidget {
  final String url;
  const DogImage({super.key, required this.url});

  @override
  State<DogImage> createState() => _DogImageState();
}

class _DogImageState extends State<DogImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: MediaQuery.of(context).size.width < 500 ? 1 : 0,
            child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ))),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Image.network(widget.url,
              scale: 1.0,
              fit: MediaQuery.of(context).size.width < 500
                  ? BoxFit.fill
                  : BoxFit.contain),
        ),
      ],
    );
  }
}
