import 'package:flutter/material.dart';

class MyPageWidget extends StatelessWidget {
  final String title;
  final IconData iconname;
  final Widget screenToMove;
  final Color? backgroundColor; // New optional backgroundColor parameter

  const MyPageWidget({
    super.key,
    required this.title,
    required this.iconname,
    required this.screenToMove,
    this.backgroundColor, // Initialize the new parameter
  });

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
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor ?? const Color(0xfff9fbff),
// Use the provided backgroundColor or fallback to default
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  Icon(
                    iconname,
                    color: const Color(0XFF9CB5DE),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0XFF334F78),
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
