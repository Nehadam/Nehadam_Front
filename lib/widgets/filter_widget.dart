import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final String filter_name, image, id;
  final Function(String) onFilterSelected; // 콜백 함수 추가

  const FilterWidget({
    super.key,
    required this.filter_name,
    required this.image,
    required this.id,
    required this.onFilterSelected, // 콜백 함수 초기화
  });

  @override
  Widget build(BuildContext context) {
    return FilterSelectButton(
      image: image,
      filter_name: filter_name,
      onFilterSelected: onFilterSelected, // 콜백 함수 전달
    );
  }
}

class FilterSelectButton extends StatelessWidget {
  const FilterSelectButton({
    super.key,
    required this.image,
    required this.filter_name,
    required this.onFilterSelected, // 콜백 함수 전달
  });

  final String image;
  final String filter_name;
  final Function(String) onFilterSelected; // 콜백 함수 정의

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onFilterSelected(image); // 필터 선택 시 콜백 함수 호출
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
                  ),
                ],
              ),
              child: Image.asset(image),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              filter_name,
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'NanumPenScript',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
