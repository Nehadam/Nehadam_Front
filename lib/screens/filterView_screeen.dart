import 'package:_nehadam/screens/filterChoice_screen.dart';
import 'package:_nehadam/states/image_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  final PageController _pageController = PageController();
  final int _numberOfPages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            PageView(
              controller: _pageController,
              children: [
                ThemeCard(
                  title: 'Cartoon',
                  imagePath: 'assets/data/filters/cartoon.jpg',
                  onTap: () {
                    Provider.of<Image_State>(context, listen: false)
                        .updateimage_FilterPath(
                            'assets/data/filters/cartoon.jpg');
                    Provider.of<Image_State>(context, listen: false)
                        .updateSelectedTheme('Cartoon');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: const Text('필터를 선택했습니다.',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'NanumPenScript')),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ThemeCard(
                  title: 'AI',
                  imagePath: 'assets/data/filters/scream.jpg',
                  onTap: () {
                    Provider.of<Image_State>(context, listen: false)
                        .updateSelectedTheme('AI');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FilterChoiceScreen(theme: 'AI'),
                      ),
                    );
                  },
                ),
                ThemeCard(
                  title: 'life',
                  imagePath: 'assets/data/filters/life.jpg',
                  onTap: () {
                    Provider.of<Image_State>(context, listen: false)
                        .updateimage_FilterPath('assets/data/filters/life.jpg');
                    Provider.of<Image_State>(context, listen: false)
                        .updateSelectedTheme('life');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: const Text('필터를 선택했습니다.',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'NanumPenScript')),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (_pageController.page == 0) {
                    _pageController.animateToPage(
                      _numberOfPages - 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            Positioned(
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  if (_pageController.page == _numberOfPages - 1) {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const ThemeCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath,
                  height: 200, width: 200, fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
