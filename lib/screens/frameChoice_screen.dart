import 'package:_nehadam/hardcodingdatas/frames.dart';
import 'package:_nehadam/widgets/frame_widget.dart';
import 'package:flutter/material.dart';

const List<Widget> frameChoiceButton = <Widget>[
  Text('베스트'),
  Text('유니크'),
];

class FrameChoiceScreen extends StatelessWidget {
  const FrameChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const FrameChoice(title: ""),
    );
  }
}

class FrameChoice extends StatefulWidget {
  const FrameChoice({super.key, required this.title});

  final String title;

  @override
  State<FrameChoice> createState() => _FrameChoiceState();
}

class _FrameChoiceState extends State<FrameChoice> {
  final List<bool> _selectedframes = <bool>[
    true,
    false
  ]; // Default to first option selected.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 50,
            width: 300,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: const Text('프레임',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'NanumPenScript',
                )),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedframes.length; i++) {
                    _selectedframes[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.black,
              selectedColor: Colors.black,
              fillColor: Colors.white60,
              color: Colors.black26,
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 120.0,
              ),
              isSelected: _selectedframes,
              children: frameChoiceButton,
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedframes[0])
            const FrameHardCodingDatas(), // Only display this widget if the first toggle is selected (세로형)
        ]),
      ),
    );
  }
}

class FrameHardCodingDatas extends StatelessWidget {
  const FrameHardCodingDatas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var data in myFrameData)
          FrameWidget(
            frame_name: data["frame_name"],
            image: data["image"],
            id: data["id"],
          ),
      ],
    );
  }
}
