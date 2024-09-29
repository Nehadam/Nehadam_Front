import 'package:_nehadam/hardcodingdatas/filters.dart';
import 'package:_nehadam/screens/home_screen.dart'; // Import HomeScreen
import 'package:_nehadam/states/image_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterChoiceScreen extends StatelessWidget {
  final String theme;
  const FilterChoiceScreen({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: FilterChoice(theme: theme),
    );
  }
}

class FilterChoice extends StatefulWidget {
  final String theme;

  const FilterChoice({super.key, required this.theme});

  @override
  State<FilterChoice> createState() => _FilterChoiceState();
}

class _FilterChoiceState extends State<FilterChoice> {
  bool _showHomeScreen = false; // 상태변수 추가

  void _onFilterSelected(String imagePath) {
    // 상태를 업데이트하고 홈 스크린으로 전환
    Provider.of<Image_State>(context, listen: false)
        .updateimage_FilterPath(imagePath);

    setState(() {
      _showHomeScreen = true; // 홈 스크린으로 이동하도록 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showHomeScreen
          ? const HomeScreen() // 홈 스크린으로 이동
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                    width: 300,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: const Text('명화',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'NanumPenScript',
                        )),
                  ),
                  const SizedBox(height: 15),
                  FilterHardCodingDatas(
                    theme: widget.theme,
                    onFilterSelected: _onFilterSelected, // 콜백 함수 전달
                  ),
                ],
              ),
            ),
    );
  }
}

class FilterHardCodingDatas extends StatelessWidget {
  final String theme;
  final Function(String) onFilterSelected; // 콜백 함수 추가

  const FilterHardCodingDatas({
    super.key,
    required this.theme,
    required this.onFilterSelected, // 콜백 함수 초기화
  });

  @override
  Widget build(BuildContext context) {
    final filterData = getFilterDataForTheme(theme);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: filterData.map((data) {
        return FilterWidget(
          filter_name: data["filter_name"],
          image: data["image"],
          id: data["id"],
          onFilterSelected: onFilterSelected, // 콜백 함수 전달
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> getFilterDataForTheme(String theme) {
    // You can modify this method to filter based on theme if needed
    return myFilterData;
  }
}

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
