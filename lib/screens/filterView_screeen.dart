import 'package:_nehadam/hardcodingdatas/filters.dart';
import 'package:_nehadam/screens/frameSelection_screen.dart';
import 'package:_nehadam/screens/home_screen.dart';
import 'package:_nehadam/states/image_state.dart';
import 'package:_nehadam/widgets/filterCard_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showHomeScreen = false; // 홈 스크린 표시 여부를 위한 상태 변수
  bool _showFrameSelectionScreen = false; // 프레임 선택 화면 표시 여부를 위한 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showHomeScreen
          ? const HomeScreen() // 홈 스크린을 표시
          : _showFrameSelectionScreen
              ? const FrameSelectionScreen() // 프레임 선택 화면을 표시
              : SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 35),
                        child: Row(
                          children: [
                            Text(
                              '네하담',
                              style: TextStyle(
                                color: Color(0XFF334F78),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NanumPenScript',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xfff9fbff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45)),
                              ),
                              child: const Text(
                                '필터 선택',
                                style: TextStyle(
                                  color: Color(0XFF334F78),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NanumPenScript',
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showFrameSelectionScreen = true;
                                });
                              },
                              child: const Text(
                                '프레임 선택으로 바로 가기',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'NanumPenScript',
                                  color: Color(0XFF334F78),
                                  decoration: TextDecoration.underline, // 밑줄 추가
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            ThemeCard(
                              title: '카툰',
                              imagePath: 'assets/data/filters/cartoon.jpg',
                              onTap: () {
                                Provider.of<Image_State>(context, listen: false)
                                    .updateimage_FilterPath(
                                        'assets/data/filters/cartoon.jpg');
                                Provider.of<Image_State>(context, listen: false)
                                    .updateSelectedTheme('Cartoon');

                                setState(() {
                                  _showHomeScreen = true; // 바로 홈 스크린으로 이동
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ThemeCard(
                              title: '명화',
                              imagePath: 'assets/data/filters/AI.jpg',
                              onTap: () {
                                _showFilterSelectionPopup(context, 'AI');
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ThemeCard(
                              title: 'Aging(baby/old)',
                              imagePath: 'assets/data/filters/life.jpg',
                              onTap: () {
                                _showAgingOptions(context);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ThemeCard(
                              title: 'sdWebui',
                              imagePath: 'assets/data/filters/sdwebui.jpg',
                              onTap: () {
                                Provider.of<Image_State>(context, listen: false)
                                    .updateimage_FilterPath(
                                        'assets/data/filters/sdwebui.jpg');
                                Provider.of<Image_State>(context, listen: false)
                                    .updateSelectedTheme('sdwebui');

                                setState(() {
                                  _showHomeScreen = true; // 바로 홈 스크린으로 이동
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ThemeCard(
                              title: 'anime',
                              imagePath: 'assets/data/filters/anime.jpg',
                              onTap: () {
                                Provider.of<Image_State>(context, listen: false)
                                    .updateimage_FilterPath(
                                        'assets/data/filters/anime.jpg');
                                Provider.of<Image_State>(context, listen: false)
                                    .updateSelectedTheme('anime');

                                setState(() {
                                  _showHomeScreen = true; // 바로 홈 스크린으로 이동
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ThemeCard(
                              title: 'pixelart',
                              imagePath: 'assets/data/filters/pixelart.jpg',
                              onTap: () {
                                Provider.of<Image_State>(context, listen: false)
                                    .updateimage_FilterPath(
                                        'assets/data/filters/pixelart.jpg');
                                Provider.of<Image_State>(context, listen: false)
                                    .updateSelectedTheme('pixelart');

                                setState(() {
                                  _showHomeScreen = true; // 바로 홈 스크린으로 이동
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ThemeCard(
                              title: 'ardiffusion',
                              imagePath: 'assets/data/filters/ardiffusion.jpg',
                              onTap: () {
                                Provider.of<Image_State>(context, listen: false)
                                    .updateimage_FilterPath(
                                        'assets/data/filters/ardiffusion.jpg');
                                Provider.of<Image_State>(context, listen: false)
                                    .updateSelectedTheme('ardiffusion');

                                setState(() {
                                  _showHomeScreen = true; // 바로 홈 스크린으로 이동
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _showFilterSelectionPopup(BuildContext context, String theme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '필터 선택',
            style: TextStyle(
              fontFamily: 'NanumPenScript',
            ),
          ),
          content: FilterChoiceScreen(
            theme: theme,
            onFilterSelected: (String imagePath) {
              Provider.of<Image_State>(context, listen: false)
                  .updateimage_FilterPath(imagePath);
              Provider.of<Image_State>(context, listen: false)
                  .updateSelectedTheme(theme);

              Navigator.of(context).pop(); // 팝업 닫기
              setState(() {
                _showHomeScreen = true; // 홈 스크린으로 이동
              });
            },
          ),
        );
      },
    );
  }

  void _showAgingOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // 기본 패딩 제거
          content: SizedBox(
            width: double.maxFinite, // 전체 너비 사용
            child: Column(
              mainAxisSize: MainAxisSize.min, // 세로 크기 조정
              children: <Widget>[
                Image.asset(
                  'assets/data/filters/life.jpg', // 이미지 경로
                  height: 150, // 높이 조정
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20), // 이미지와 버튼 사이 간격
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    TextButton(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0XFF334F78), // 테두리 색상
                            width: 2.0, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                        ),
                        child: const Text(
                          'baby',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NanumPenScript',
                          ),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<Image_State>(context, listen: false)
                            .updateimage_FilterPath(
                                'assets/data/filters/life_baby.jpg');
                        Provider.of<Image_State>(context, listen: false)
                            .updateSelectedTheme('life_baby');

                        setState(() {
                          _showHomeScreen = true; // 홈 스크린으로 이동
                        });

                        Navigator.of(context).pop(); // 팝업 닫기
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0XFF334F78), // 테두리 색상
                            width: 2.0, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                        ),
                        child: const Text(
                          'old',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NanumPenScript',
                          ),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<Image_State>(context, listen: false)
                            .updateimage_FilterPath(
                                'assets/data/filters/life_old.jpg');
                        Provider.of<Image_State>(context, listen: false)
                            .updateSelectedTheme('life_old');

                        setState(() {
                          _showHomeScreen = true; // 홈 스크린으로 이동
                        });

                        Navigator.of(context).pop(); // 팝업 닫기
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20), // 버튼 아래 간격 추가
              ],
            ),
          ),
        );
      },
    );
  }
}

class FilterChoiceScreen extends StatelessWidget {
  final String theme;
  final Function(String) onFilterSelected;

  const FilterChoiceScreen({
    super.key,
    required this.theme,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            theme: theme,
            onFilterSelected: onFilterSelected,
          ),
        ],
      ),
    );
  }
}

class FilterHardCodingDatas extends StatelessWidget {
  final String theme;
  final Function(String) onFilterSelected;

  const FilterHardCodingDatas({
    super.key,
    required this.theme,
    required this.onFilterSelected,
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
          onFilterSelected: onFilterSelected,
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> getFilterDataForTheme(String theme) {
    // 필요한 경우 테마에 따라 필터 데이터를 필터링합니다.
    return myFilterData;
  }
}

class FilterWidget extends StatelessWidget {
  final String filter_name, image, id;
  final Function(String) onFilterSelected;

  const FilterWidget({
    super.key,
    required this.filter_name,
    required this.image,
    required this.id,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSelectButton(
      image: image,
      filter_name: filter_name,
      onFilterSelected: onFilterSelected,
    );
  }
}

class FilterSelectButton extends StatelessWidget {
  final String image;
  final String filter_name;
  final Function(String) onFilterSelected;

  const FilterSelectButton({
    super.key,
    required this.image,
    required this.filter_name,
    required this.onFilterSelected,
  });

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
