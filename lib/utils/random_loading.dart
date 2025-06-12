import 'dart:math';

String getRandomLoadings() {
  final names = [
    "assets/lotties/lamp_loading.json", 
    "assets/lotties/oil_lamp_loading.json"
  ];
  final random = Random();
  final randomName = names[random.nextInt(names.length)];
  print(randomName);
  return randomName;
}