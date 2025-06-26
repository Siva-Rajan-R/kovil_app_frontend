// Map<String, dynamic>? extractNameAndNumber(String input) {
//   // Match pattern like "somename-1"
//   RegExp regExp = RegExp(r'([a-zA-Z]+)-(\d+)');
//   Match? match = regExp.firstMatch(input);

//   if (match != null) {
//     String name = match.group(1)!;
//     int number = int.parse(match.group(2)!);
//     return {'name': name, 'number': number};
//   }

//   return null; // If no match found
// }
// void main() {
//   String input = "somename-1 padi/kg";
//   var result = extractNameAndNumber(input);

//   if (result != null) {
//     print("Name: ${result['name']}, Number: ${result['number']}");
//   } else {
//     print("No valid name-number pair found.");
//   }
// }

void main() {
  List<Map<String, dynamic>> items = [
    {"id": 16, "name": "vkk", "amount": 500},
    {"id": 14, "name": "sample puli saatham", "amount": 100},
  ];

  int maxId = items.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b);

  print("Max ID: $maxId");
}

