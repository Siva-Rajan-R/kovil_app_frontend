import 'dart:math';
import 'package:sampleflutter/utils/custom_print.dart';

String getRandomLoadings() {
  final names = [
    "assets/lotties/lamp_loading.json", 
    "assets/lotties/oil_lamp_loading.json"
  ];
  final random = Random();
  final randomName = names[random.nextInt(names.length)];
  printToConsole(randomName);
  return randomName;
}