import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';


Future compressImageToTargetSize(File file,int compressTo,{bool returnAsFile=false}) async {
  int targetSize = compressTo; // 3 KB
  int quality = 90;

  Uint8List? compressed;

  while (quality > 10) {
    compressed = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: quality,
      format: CompressFormat.webp,
    );

    if (compressed != null && compressed.lengthInBytes <= targetSize) {
      print("Final Size: ${compressed.lengthInBytes} bytes");
      break;
    }

    quality -= 5;
  }

  if (returnAsFile){
    final dir = await getTemporaryDirectory();
    final outputFile = File("${dir.path}/compressed.webp");
    return outputFile.writeAsBytes(compressed!);

  }
  return compressed; // returns smallest achieved
}
