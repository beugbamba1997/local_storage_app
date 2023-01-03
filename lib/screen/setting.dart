import 'package:flutter/material.dart';
import 'package:local_storage_app/data/shar_prefs.dart';
import 'package:local_storage_app/model/font_size.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int settingColor = 0xf1976d2;
  double fonSize = 16;
  List<int> colors = [
    0xFF455A64,
    0xFFFFC107,
    0xFF673ab7,
    0xFFF57C00,
    0xFF795548
  ];
  ShardPrefs shardPrefs = ShardPrefs();
  final List<FontSize> fontSizes = [
    FontSize('small', 14),
    FontSize('medium', 16),
    FontSize('large', 20),
    FontSize('extra-large', 24),
  ];

  void setColor(int color) {
    setState(() {
      settingColor = color;
      shardPrefs.setColor(color);
    });
  }

  List<DropdownMenuItem<String>> getDropdownMenuItem() {
    List<DropdownMenuItem<String>> items = [];

    for (FontSize fontSize in fontSizes) {
      items.add(DropdownMenuItem(
          value: fontSize.size.toString(), child: Text(fontSize.name)));
    }
    return items;
  }

  @override
  void initState() {
    shardPrefs.init().then((value) {
      setState(() {
        settingColor = shardPrefs.getColor();
        fonSize = shardPrefs.getFontSize();
      });
    });
    super.initState();
  }

  void changeSize(String? newsize) {
    shardPrefs.setFontSize(double.parse(newsize ?? '14'));
    setState(() {
      fonSize = double.parse(newsize ?? '14');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: Color(settingColor),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          'choose a Font Size for the App',
          style: TextStyle(fontSize: fonSize, color: Color(settingColor)),
        ),
        DropdownButton(
          value: fonSize.toString(),
          items: getDropdownMenuItem(),
          onChanged: changeSize,
        ),
        Text(
          'APP MAIN',
          style: TextStyle(fontSize: fonSize, color: Color(settingColor)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < colors.length; i++)
              GestureDetector(
                onTap: () {
                  setColor(colors[i]);
                },
                child: ColorSquare(
                  colorCode: colors[i],
                ),
              )
          ],
        )
      ]),
    );
  }
}

class ColorSquare extends StatelessWidget {
  final int colorCode;
  const ColorSquare({super.key, required this.colorCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Color(colorCode),
      ),
    );
  }
}
