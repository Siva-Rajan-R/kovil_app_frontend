import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sampleflutter/utils/secure_storage_init.dart';
import 'package:http_parser/http_parser.dart';  // For MediaType
import 'package:connectivity_plus/connectivity_plus.dart';





// https://kovil-app-backend.vercel.app
String BASEURL = "https://feminist-andria-sivarajan-40ab83c8.koyeb.app";

class NetworkService {
  static Future sendRequest({
    required String path,
    required BuildContext context,
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
    bool isJson = true,
    bool isRetry = false,
    bool isMultipart = false, // Flag to check if it's a multipart request
    File? imageFile, // Optional image file for multipart
  }) async {

    // 🔌 Check network before hitting the backend
      var connectivityResult = await Connectivity().checkConnectivity();
      print(connectivityResult);
      if (connectivityResult == ConnectivityResult.none) {
        print("helopo");
        customSnackBar(
          content: "No internet connection. Please turn on your data or Wi-Fi.",
          contentType: AnimatedSnackBarType.info,
        ).show(context);
        return null; // Skip API call if there's no internet
      }

    final url = "$BASEURL$path";
    final uri = Uri.parse(url);
    final accessToken = await secureStorage.read(key: 'accessToken');
    print(uri);

    Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    };
    
    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    
    http.Response response;

    if (isMultipart) {
      // If it's a multipart request, use MultipartRequest
      var request = http.MultipartRequest(method, uri)
        ..headers.addAll(defaultHeaders);

      // Add form fields if available (e.g., feedback, tips, etc.)
      if (body != null) {
        body.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      // If image file is provided, add it to the request
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', // Name of the field expected by the backend
          imageFile.path,
          contentType: MediaType('image', 'jpeg'), // Adjust the content type as needed (e.g., 'png', 'jpeg')
        ));
      }

      // Send the request and return the response
      final streamedResponse = await request.send();

      // Convert the streamed response to a normal response
      response = await http.Response.fromStream(streamedResponse);
    } else {
      // Handle regular requests (GET, POST, PUT, DELETE)
      if (method == 'POST') {
        response = await http.post(
          uri,
          headers: defaultHeaders,
          body: isJson ? jsonEncode(body) : body,
        );
      } else if (method == 'PUT') {
        response = await http.put(
          uri,
          headers: defaultHeaders,
          body: isJson ? jsonEncode(body) : body,
        );
      } else if (method == 'DELETE') {
        response = await http.delete(
          uri,
          headers: defaultHeaders,
          body: isJson ? jsonEncode(body) : body,
        );
      } else {
        // Default is GET
        response = await http.get(
          uri,
          headers: defaultHeaders,
        );
      }
    }

    // Check if the response is unauthorized (401)
    print(response.statusCode);
    if (response.statusCode == 401 && !isRetry) {
      final String? refreshToken = await secureStorage.read(key: 'refreshToken');
      final String? accessToken = await secureStorage.read(key: 'accessToken');
      final String? refreshTokenExpDate = await secureStorage.read(key: "refreshTokenExpDate");
      final DateTime parsedDate = DateTime.parse(refreshTokenExpDate!);
      final DateTime tdyDate = DateTime.now();

      print("refresh token: $refreshToken accesstoken $accessToken");
      // Check if the refresh token is expired
      if (parsedDate.isBefore(tdyDate)) {
        print("Logout due to expired refresh token");

        // Clear the stored tokens
        await secureStorage.delete(key: 'accessToken');
        await secureStorage.delete(key: 'refreshToken');
        await secureStorage.delete(key: 'role');
        await secureStorage.delete(key: 'refreshTokenExpDate');
        await secureStorage.write(key: 'isLoggedIn', value: 'false');

        // Redirect to login
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // If the refresh token is valid, obtain a new access token
        final res = await sendRequest(
          path: "/new-access-token",
          context: context,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer $refreshToken",
          },
          isRetry: true,
        );
        print("hello $res");
        if (res!=null) {
          // Save the new access token
          
          await secureStorage.write(
              key: "accessToken", value: res['access_token']
          );

          // Retry the original request with the new access token
          return await sendRequest(
            path: path,
            method: method,
            body: body,
            headers: headers,
            isJson: isJson,
            context: context,
            isRetry: true,
            isMultipart: isMultipart,
            imageFile: imageFile,
          );
        }
      }
    }

    // Return the response
    print("body soda ${response.body}");
    final decodedRes=jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode==200 || response.statusCode==201){
      if(decodedRes is String){
        customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.success).show(context);
      }
      print(decodedRes);
      return decodedRes;
    }
    else if(response.statusCode==422){
      customSnackBar(content: "invalid Inputs", contentType: AnimatedSnackBarType.info).show(context);
      return null;
    }
    else{
      final errorText = decodedRes['detail'] ?? (decodedRes.toString().isNotEmpty ? decodedRes.toString() : "Something went wrong");

      customSnackBar(content: errorText, contentType: AnimatedSnackBarType.error).show(context);
      return null;
    }

    
    
  }
}
