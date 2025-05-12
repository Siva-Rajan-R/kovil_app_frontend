import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';


Future<void> makePhoneCall(String phoneNumber,BuildContext context) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    customSnackBar(content: 'Could not launch $phoneNumber', contentType:AnimatedSnackBarType.info).show(context);
  }
}