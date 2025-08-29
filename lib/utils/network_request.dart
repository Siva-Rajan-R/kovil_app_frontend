import 'package:sampleflutter/utils/custom_print.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/utils/delete_local_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sampleflutter/utils/secure_storage_init.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';



const String BASEURL = "https://guruvudhasan.onrender.com";
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

    // checkInternetSpeed(context);
    String? accessToken;
    String? refreshToken;
    String? refreshTokenExpDateStr;

    final eTagBox=Hive.box("eTagBox");
    final eTagCachedDatasBox=Hive.box("eTagCachedDatasBox");

    if (!isLoginPage) {
      // Read access and refresh tokens from secure storage
      accessToken = await secureStorage.read(key: 'accessToken');
      refreshToken = await secureStorage.read(key: 'refreshToken');
      refreshTokenExpDateStr = await secureStorage.read(key: 'refreshTokenExpDate');
      printToConsole("888888888888888888888888888888888888888888$refreshTokenExpDateStr $refreshToken");
      // Check if refresh token has expired
      if (refreshTokenExpDateStr != null) {
        final refreshExp = DateTime.parse(refreshTokenExpDateStr);
        if (DateTime.now().isAfter(refreshExp)) {
          // Session expired
          printToConsole("vanakamm");
          await deleteStoredLocalStorageValues();
          customSnackBar(content: "Session expired. Please log in again 0",contentType: AnimatedSnackBarType.info).show(context);
          Navigator.of(context).pushReplacementNamed('/login');
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
    if (eTagBox.containsKey('eTag$path')){
      final cachedETag=eTagBox.get('eTag$path');
      printToConsole("i got the etag $cachedETag");
      requestHeaders['If-None-Match']=cachedETag;
    }

    // Create Dio instance with base options
    BaseOptions options = BaseOptions(
      baseUrl: _baseUrl,
      headers: requestHeaders,
    );  // Set base URL and default headers:contentReference[oaicite:9]{index=9}
    final dio = Dio(options);  // Instantiate Dio client:contentReference[oaicite:10]{index=10}

    dynamic responseData;
    Response response;

    try {
      // Prepare data for request
      dynamic requestData;
      Options requestOptions = Options(method: method);

      if (isMultipart) {
        // Build multipart/form-data request with file upload
        FormData formData = FormData();
        printToConsole("${(body != null)}");
        if (body != null) {
          // Add other fields to form data
          body.forEach((key, value) {
            formData.fields.add(MapEntry(key, value.toString()));
            printToConsole("$key $value");
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
        printToConsole("--------------------------------------------------------${formData.fields} $body");
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
          printToConsole('Upload progress: $sent/$total');
          if (onUploadProgress!=null){
            onUploadProgress(sent/total);
          }
          // customSnackBar(content: 'Upload progress: $sent/$total', contentType: AnimatedSnackBarType.success).show(context);
        },
        onReceiveProgress: (int received, int total) {
          // Log download progress to console
          printToConsole('Download progress: $received/$total');
          if (onUploadProgress!=null){
            onUploadProgress(received/total);
          }
        },
      );

      printToConsole("copmpleted----------------------");
      responseData = response.data;

      printToConsole(responseData);
      // If response is unauthorized and not yet retried, attempt to refresh token:contentReference[oaicite:14]{index=14}
      
    } on DioException catch (dioError) {

      if (dioError.response!.statusCode==304){
        if (eTagCachedDatasBox.containsKey('eTagCachedData$path')){
          final cachedETagData=eTagCachedDatasBox.get('eTagCachedData$path');
          printToConsole("i got the etagcached data $cachedETagData");
          return cachedETagData;
        }
      }

      if (dioError.response!.statusCode == 401 && !isRetry) {
        printToConsole("ullokjnjinhb");
        if (refreshToken != null) {
          printToConsole("ullokjnjinhb");
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
            printToConsole(refreshResp.data);
            printToConsole("${refreshResp.statusCode}");
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
            // await deleteStoredLocalStorageValues();
            customSnackBar(content: "Session expired. Please log in again 1",contentType: AnimatedSnackBarType.info).show(context);
            // Navigator.of(context).pushReplacementNamed('/login');
            return null;
          }
        } else {
          // No refresh token stored
          await deleteStoredLocalStorageValues();
          customSnackBar(content: "Session expired. Please log in again 2",contentType: AnimatedSnackBarType.info).show(context);
          await Navigator.of(context).pushReplacementNamed('/login');
          return null;
        }
      }
      // Handle Dio-specific errors
      printToConsole("${dioError.response}  ${dioError.response?.statusCode}");
      if (dioError.response != null && dioError.response?.statusCode == 401) {
        printToConsole("Session expired. Please log in again 3");
        // Unauthorized and already retried or no refresh token
        await deleteStoredLocalStorageValues();
        customSnackBar(content: "Session expired. Please log in again 3",contentType: AnimatedSnackBarType.info).show(context);
        await Navigator.of(context).pushReplacementNamed('/login');
        return null;
      } else if (dioError.response != null && (dioError.response?.statusCode == 422 || dioError.response?.statusCode == 409 || dioError.response?.statusCode == 404)) {
        // Other errors
        final responseData=dioError.response!.data;
        printToConsole("422 error${dioError.response!.data}");
        String? errorMsg = ((responseData['detail'] is !List)? responseData['detail'] : responseData['detail'][0]['msg']) ?? (responseData.toString().isNotEmpty ? responseData.toString() : "invalid inputs");
        customSnackBar(content: "$errorMsg",contentType: AnimatedSnackBarType.info).show(context);
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

    printToConsole("==============================$responseData ${response.headers.value("etag")} ${response.headers.value("ETag")}");
    
    final newETag=response.headers.value("etag");
    printToConsole("taggg ggg $newETag");
    if (newETag!=null){
      await eTagBox.put('eTag$path', newETag);
      await eTagCachedDatasBox.put('eTagCachedData$path', responseData);
    }
    return responseData;
  }
}
