import 'package:_nehadam/hardcodingdatas/filters.dart';
import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:_nehadam/widgets/filter_widget.dart';
import 'package:flutter/material.dart';

const List<Widget> filters = <Widget>[
  Text('AI'),
  Text('AR'),
];

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
  final List<bool> _selectedfilters = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainFrameScreen(),
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 50,
            width: 300,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: const Text('필터',
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
                  for (int i = 0; i < _selectedfilters.length; i++) {
                    _selectedfilters[i] = i == index;
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
              isSelected: _selectedfilters,
              children: filters,
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedfilters[0])
            FilterHardCodingDatas(
                theme: widget.theme), // Pass theme to the widget
        ]),
      ),
    );
  }
}

class FilterHardCodingDatas extends StatelessWidget {
  final String theme;
  const FilterHardCodingDatas({super.key, required this.theme});

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
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> getFilterDataForTheme(String theme) {
    // You can modify this method to filter based on theme if needed
    return myFilterData;
  }
}
