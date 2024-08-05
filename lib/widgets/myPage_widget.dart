import 'package:flutter/material.dart';

class MyPageWidget extends StatelessWidget {
  final String title;

  final IconData iconname;
  final Widget screenToMove;

  const MyPageWidget(
      {super.key,
      required this.title,
      required this.iconname,
      required this.screenToMove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screenToMove));
      },
      child: Column(
        children: [
          const SizedBox(
            height: 7,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45, width: 0.5),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    (iconname),
                    color: Colors.black,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'NanumPenScript',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
