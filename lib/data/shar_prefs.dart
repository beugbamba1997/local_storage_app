import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ShardPrefs {
  String keycolors = "color";
  String keyfontSize = "font_size ";
  static late SharedPreferences _sp; //attribut private de shared prefrence
  static ShardPrefs? _instance;

//constructeur private
  ShardPrefs._internal();

  factory ShardPrefs() {
    _instance ??= ShardPrefs._internal();
    return _instance as ShardPrefs;
  }

  Future init() async {
    _sp = await SharedPreferences.getInstance();
  }

  Future setColor(int color) {
    return _sp.setInt(keycolors, color);
  }

  int getColor() {
    int? color = _sp.getInt(keycolors);
    color ??=
        0xff1976d2; //sii color est null on l'effeccte une couleur par defaut
    return color;
  }

  Future setFontSize(double size) {
    return _sp.setDouble(keyfontSize, size);
  }

  double getFontSize() {
    double? fontSize = _sp.getDouble(keyfontSize);
    fontSize ??= 14;
    return fontSize;
  }
  
}
