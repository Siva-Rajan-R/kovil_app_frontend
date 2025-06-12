import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/utils/delete_local_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sampleflutter/utils/secure_storage_init.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';





// https://kovil-app-backend.vercel.app
// String BASEURL = "https://muddy-danette-sivarajan-1b1beec7.koyeb.app";

// class NetworkService {
//   static Future sendRequest({
//     required String path,
//     required BuildContext context,
//     String method = 'GET',
//     Map<String, String>? headers,
//     dynamic body,
//     bool isJson = true,
//     bool isRetry = false,
//     bool isMultipart = false, // Flag to check if it's a multipart request
//     File? imageFile,
//     bool isLoginPage=false,
//     String nameOfImageField="" // Optional image file for multipart
//   }) async {

//     // 🔌 Check network before hitting the backend
//       var connectivityResult = await Connectivity().checkConnectivity();
//       print(connectivityResult);
//       if (connectivityResult == ConnectivityResult.none) {
//         print("helopo");
//         customSnackBar(
//           content: "No internet connection. Please turn on your data or Wi-Fi.",
//           contentType: AnimatedSnackBarType.info,
//         ).show(context);
//         return null; // Skip API call if there's no internet
//       }
//   try {
//     final url = "$BASEURL$path";
//     final uri = Uri.parse(url);
//     final accessToken = await secureStorage.read(key: 'accessToken');
//     print(uri);

//     if (accessToken==null && isLoginPage==false){
//       customSnackBar(content: "session expired,Please re-login", contentType: AnimatedSnackBarType.info).show(context);
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }
//     Map<String, String> defaultHeaders = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': "Bearer $accessToken",
//     };
    
//     if (headers != null) {
//       defaultHeaders.addAll(headers);
//     }
    
//     http.Response response;

//     if (isMultipart) {
//       // If it's a multipart request, use MultipartRequest
//       var request = http.MultipartRequest(method, uri)
//         ..headers.addAll(defaultHeaders);

//       // Add form fields if available (e.g., feedback, tips, etc.)
//       if (body != null) {
//         body.forEach((key, value) {
//           request.fields[key] = value.toString();
//         });
//       }

//       // If image file is provided, add it to the request
//       if (imageFile != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           nameOfImageField, // Name of the field expected by the backend
//           imageFile.path,
//           contentType: MediaType('image', 'jpeg'), // Adjust the content type as needed (e.g., 'png', 'jpeg')
//         ));
//       }

//       // Send the request and return the response
//       final streamedResponse = await request.send();

//       // Convert the streamed response to a normal response
//       response = await http.Response.fromStream(streamedResponse);
//     } else {
//       // Handle regular requests (GET, POST, PUT, DELETE)
//       if (method == 'POST') {
//         response = await http.post(
//           uri,
//           headers: defaultHeaders,
//           body: isJson ? jsonEncode(body) : body,
//         );
//       } else if (method == 'PUT') {
//         response = await http.put(
//           uri,
//           headers: defaultHeaders,
//           body: isJson ? jsonEncode(body) : body,
//         );
//       } else if (method == 'DELETE') {
//         response = await http.delete(
//           uri,
//           headers: defaultHeaders,
//           body: isJson ? jsonEncode(body) : body,
//         );
//       } else {
//         // Default is GET
//         response = await http.get(
//           uri,
//           headers: defaultHeaders,
//         );
//       }
//     }

//     // Check if the response is unauthorized (401)
//     print(response.statusCode);
//     if (response.statusCode == 401 && !isRetry) {
//       final String? refreshToken = await secureStorage.read(key: 'refreshToken');
//       final String? accessToken = await secureStorage.read(key: 'accessToken');
//       final String? refreshTokenExpDate = await secureStorage.read(key: "refreshTokenExpDate");
//       final DateTime parsedDate = DateTime.parse(refreshTokenExpDate!);
//       final DateTime tdyDate = DateTime.now();

    
//       print("refresh token: $refreshToken accesstoken $accessToken");
//       // Check if the refresh token is expired
//       if (parsedDate.isBefore(tdyDate)) {
//         print("Logout due to expired refresh token");

//         // Clear the stored tokens
//         await deleteStoredLocalStorageValues();
        
//         // Redirect to login
//         Navigator.pushReplacementNamed(context, '/login');
//       } else {
//         // If the refresh token is valid, obtain a new access token
//         final res = await sendRequest(
//           path: "/new-access-token",
//           context: context,
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             'Authorization': "Bearer $refreshToken",
//           },
//           isRetry: true,
//         );
//         print("hello $res");
//         if (res!=null) {
//           // Save the new access token
          
//           await secureStorage.write(
//               key: "accessToken", value: res['access_token']
//           );

//           // Retry the original request with the new access token
//           return await sendRequest(
//             path: path,
//             method: method,
//             body: body,
//             headers: headers,
//             isJson: isJson,
//             context: context,
//             isRetry: true,
//             isMultipart: isMultipart,
//             imageFile: imageFile,
//           );
//         }
//       }
//     }

//     // Return the response
//     print("body soda ${response.body}");
//     final decodedRes=jsonDecode(utf8.decode(response.bodyBytes));
//     if(response.statusCode==200 || response.statusCode==201){
//       if(decodedRes is String){
//         customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.success).show(context);
//       }
//       print(decodedRes);
//       return decodedRes;
//     }
//     else if(response.statusCode==422){
//       final errorText = ((decodedRes['detail'] is !List)? decodedRes['detail'] : decodedRes['detail'][0]['msg']) ?? (decodedRes.toString().isNotEmpty ? decodedRes.toString() : "invalid inputs");
//       customSnackBar(content: errorText, contentType: AnimatedSnackBarType.info).show(context);
//       return null;
//     }
//     else{
//       final errorText = decodedRes['detail'] ?? (decodedRes.toString().isNotEmpty ? decodedRes.toString() : "Something went wrong");

//       customSnackBar(content: errorText, contentType: AnimatedSnackBarType.error).show(context);
//       return null;
//     }

//   }
//   catch(e){
//     print("errror pa $e");
//   }
    
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';  // For BuildContext and Navigator
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// https://muddy-danette-sivarajan-1b1beec7.koyeb.app

Future<void> checkInternetSpeed(BuildContext context) async {
  final internetSpeedTest = InternetSpeedTest();
  await internetSpeedTest.startDownloadTesting(
    onDone: (transferRate,unit){
      print("$transferRate $unit");
      if (transferRate<1){
        customSnackBar(content: "Your Internet Speed is Too Low , It takes some Time...", contentType: AnimatedSnackBarType.info).show(context);
      }
      else{
        print("internet speed is good");
      }
    }, 
    onProgress: (percent, transferRate, unit) {
      print("$transferRate $percent $unit");
    },
    onError: (errorMessage, speedTestError) => print(" $errorMessage $speedTestError"),
  );
  
}
const String BASEURL = "https://muddy-danette-sivarajan-1b1beec7.koyeb.app";
class NetworkService{
  // Replace with your actual base URL
  static const String _baseUrl = BASEURL; 

  static Future<dynamic> sendRequest({
    required String path,
    required BuildContext context,
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
    bool isJson = true,
    bool isRetry = false,
    bool isMultipart = false,
    File? imageFile,
    bool isLoginPage = false,
    String nameOfImageField = '',
    Function(double)? onUploadProgress,
  }) async {
    // Check internet connectivity before sending request:contentReference[oaicite:7]{index=7}
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      customSnackBar(content: "No internet connection",contentType: AnimatedSnackBarType.info).show(context);
      return null;
    }

    checkInternetSpeed(context);
    String? accessToken;
    String? refreshToken;
    String? refreshTokenExpDateStr;

    if (!isLoginPage) {
      // Read access and refresh tokens from secure storage
      accessToken = await secureStorage.read(key: 'accessToken');
      refreshToken = await secureStorage.read(key: 'refreshToken');
      refreshTokenExpDateStr = await secureStorage.read(key: 'refreshTokenExpDate');
      print("$refreshTokenExpDateStr $refreshToken");
      // Check if refresh token has expired
      if (refreshTokenExpDateStr != null) {
        final refreshExp = DateTime.parse(refreshTokenExpDateStr);
        if (DateTime.now().isAfter(refreshExp)) {
          // Session expired
          print("vanakamm");
          await deleteStoredLocalStorageValues();
          customSnackBar(content: "Session expired. Please log in again 0",contentType: AnimatedSnackBarType.info).show(context);
          // Navigator.of(context).pushReplacementNamed('/login');
          return null;
        }
      }
    }

    // Build headers
    Map<String, String> requestHeaders = {};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    // Add authorization header if token available and not login page
    if (!isLoginPage && accessToken != null) {
      requestHeaders['Authorization'] = 'Bearer $accessToken';
    }
    // Set content type header if JSON (and not multipart)
    if (isJson && !isMultipart) {
      requestHeaders['Content-Type'] = 'application/json';
    }

    // Create Dio instance with base options
    BaseOptions options = BaseOptions(
      baseUrl: _baseUrl,
      headers: requestHeaders,
    );  // Set base URL and default headers:contentReference[oaicite:9]{index=9}
    final dio = Dio(options);  // Instantiate Dio client:contentReference[oaicite:10]{index=10}

    dynamic responseData;

    try {
      Response response;
      // Prepare data for request
      dynamic requestData;
      Options requestOptions = Options(method: method);

      if (isMultipart) {
        // Build multipart/form-data request with file upload
        FormData formData = FormData();
        print((body != null));
        if (body != null) {
          // Add other fields to form data
          body.forEach((key, value) {
            formData.fields.add(MapEntry(key, value.toString()));
            print("$key $value");
          });
        }
        if (imageFile != null) {
          // Attach file to form data:contentReference[oaicite:11]{index=11}
          String fileName = imageFile.path.split('/').last;
          formData.files.add(MapEntry(
            nameOfImageField,
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
          ));
        }
        requestData = formData;
        print("--------------------------------------------------------${formData.fields} $body");
        // Let Dio set content-type to multipart/form-data automatically
      } else {
        // Non-multipart (JSON or raw)
        if (body != null) {
          requestData = isJson ? jsonEncode(body) : body;
        }
      }

      // Send request with progress callbacks for upload/download:contentReference[oaicite:12]{index=12}:contentReference[oaicite:13]{index=13}
      response = await dio.request(
        path,
        data: requestData,
        options: requestOptions,
        onSendProgress: (int sent, int total) {
          // Log upload progress to console
          print('Upload progress: $sent/$total');
          if (onUploadProgress!=null){
            onUploadProgress(sent/total);
          }
          // customSnackBar(content: 'Upload progress: $sent/$total', contentType: AnimatedSnackBarType.success).show(context);
        },
        onReceiveProgress: (int received, int total) {
          // Log download progress to console
          print('Download progress: $received/$total');
          if (onUploadProgress!=null){
            onUploadProgress(received/total);
          }
        },
      );

      print("copmpleted----------------------");
      responseData = response.data;

      print(responseData);
      // If response is unauthorized and not yet retried, attempt to refresh token:contentReference[oaicite:14]{index=14}
      
    } on DioException catch (dioError) {
      if (dioError.response!.statusCode == 401 && !isRetry) {
        print("ullokjnjinhb");
        if (refreshToken != null) {
          print("ullokjnjinhb");
          // Attempt to get a new access token
          try {
            Response refreshResp = await dio.get(
              '/new-access-token',
              options: Options(
                  headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': "Bearer $refreshToken",
                },
              )
            );
            print(refreshResp.data);
            print(refreshResp.statusCode);
            if (refreshResp.statusCode == 200 && refreshResp.data != null) {
              // Save new tokens (assuming response gives new accessToken, refreshToken, and expiry)
              String newAccess = refreshResp.data['access_token'];
              await secureStorage.write(key: 'accessToken', value: newAccess);
              // Retry original request with new token
              
              return await sendRequest(
                path: path,
                context: context,
                method: method,
                headers: headers,
                body: body,
                isJson: isJson,
                isRetry: true,
                isMultipart: isMultipart,
                imageFile: imageFile,
                isLoginPage: isLoginPage,
                nameOfImageField: nameOfImageField,
              );
            } else {
              // Refresh token invalid or expired
              throw Exception('Unable to refresh token');
            }
          } catch (e) {
            // Token refresh failed
            await deleteStoredLocalStorageValues();
            customSnackBar(content: "Session expired. Please log in again 1",contentType: AnimatedSnackBarType.info).show(context);
            Navigator.of(context).pushReplacementNamed('/login');
            return null;
          }
        } else {
          // No refresh token stored
          await deleteStoredLocalStorageValues();
          customSnackBar(content: "Session expired. Please log in again 2",contentType: AnimatedSnackBarType.info).show(context);
          Navigator.of(context).pushReplacementNamed('/login');
          return null;
        }
      }
      // Handle Dio-specific errors
      print("${dioError.response}  ${dioError.response?.statusCode}");
      if (dioError.response != null && dioError.response?.statusCode == 401) {
        print("Session expired. Please log in again 3");
        // Unauthorized and already retried or no refresh token
        customSnackBar(content: "Session expired. Please log in again 3",contentType: AnimatedSnackBarType.info).show(context);
        Navigator.of(context).pushReplacementNamed('/login');
        return null;
      } else if (dioError.response != null && (dioError.response?.statusCode == 422 || dioError.response?.statusCode == 409)) {
        // Other errors
        final responseData=dioError.response!.data;
        print("422 error${dioError.response!.data}");
        String? errorMsg = ((responseData['detail'] is !List)? responseData['detail'] : responseData['detail'][0]['msg']) ?? (responseData.toString().isNotEmpty ? responseData.toString() : "invalid inputs");
        customSnackBar(content: "Error: $errorMsg",contentType: AnimatedSnackBarType.error).show(context);
        return null;
      }
      else{
        customSnackBar(content: "Error: Something Went Wrong (${dioError.response!.statusCode})",contentType: AnimatedSnackBarType.error).show(context);
        return null;
      }
    } catch (e) {
      // General error handling
      customSnackBar(content: "An unexpected error occurred: $e",contentType: AnimatedSnackBarType.error).show(context);
      return null;
    }

    if(responseData is String){
      customSnackBar(content: responseData,contentType: AnimatedSnackBarType.success).show(context);
    }

    print("==============================$responseData");
    return responseData;
  }
}
