import 'package:animated_snack_bar/animated_snack_bar.dart';


AnimatedSnackBar customSnackBar({required String content, required AnimatedSnackBarType contentType,Duration duration=const Duration(seconds: 5)}){
  return AnimatedSnackBar.material(
      content, 
      type: contentType,
      duration: duration,
      mobileSnackBarPosition: MobileSnackBarPosition.top,
      mobilePositionSettings: MobilePositionSettings(topOnAppearance: 40)
    );
}
