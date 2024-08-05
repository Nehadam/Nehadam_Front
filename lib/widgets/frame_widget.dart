import 'package:_nehadam/states/image_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FrameWidget extends StatelessWidget {
  final String frame_name, image, id;

  const FrameWidget({
    super.key,
    required this.frame_name,
    required this.image,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return FrameSelectButton(image: image, frame_name: frame_name);
  }
}

class FrameSelectButton extends StatelessWidget {
  const FrameSelectButton({
    super.key,
    required this.image,
    required this.frame_name,
  });

  final String image;
  final String frame_name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Provider.of<Image_State>(context, listen: false)
              .updateimage_FramePath(image);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: const Text('프레임을 선택했습니다.',
                  style: TextStyle(fontFamily: 'NanumPenScript')),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: 200,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    offset: const Offset(10, 10),
                    color: Colors.black.withOpacity(0.15),
                  )
                ],
              ),
              child: Image.asset(image),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              frame_name,
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'NanumPenScript',
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
