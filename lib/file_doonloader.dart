import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileDownload {
  Dio dio = Dio();
  bool isSuccess = false;

  void startDownloading(BuildContext context, final Function okCallback) async {
    String fileName = "Sam.pdf";
    String baseUrl =
        "https://cds.iisc.ac.in/wp-content/uploads/DS286.AUG2016.Lab2_.cpp_tutorial.pdf";

    String path = await getFilePath(fileName);

    try {
      await dio.download(
        baseUrl,
        path,
        onReceiveProgress: (receivedBytes, totalBytes) {
          okCallback(receivedBytes, totalBytes);
        },
        deleteOnError: true,
        
      ).then((_) async {
        // After download is complete, encrypt the file
        isSuccess = await _encryptFile(path);
        print(isSuccess);
      });
    } catch (e) {
      print("Exception $e");
    }

    if (isSuccess) {
      Navigator.pop(context);
    }
  }

  Future<String> getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        // For iOS
      } else {
        dir = await getDownloadsDirectory();
        print(dir!.path);
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}/$filename"; // Added '/' after dir?.path
  }

  Future<bool> _encryptFile(String filePath) async {
    try {
      File file = File(filePath);
      List<int> fileBytes = await file.readAsBytes();

      final key = 'YourEncryptionKey';
      List<int> encryptedBytes =
          fileBytes.map((byte) => byte ^ key.codeUnitAt(0)).toList();

      // Write encrypted bytes back to the file
      await file.writeAsBytes(encryptedBytes);
      return true;
    } catch (e) {
      print("Encryption failed: $e");
      return false;
    }
  }

  Future<void> openEncryptedFile() async {
    String fileName = "Sample.pdf";
    String path = await getFilePath(fileName);

    if (await File(path).exists()) {
      // Decrypt the file before opening (using the same encryption mechanism used during saving)
      bool isSuccess = await _decryptFile(path);

      if (isSuccess) {
        // Open the decrypted file
        OpenFile.open(path);
      } else {
        print('File decryption failed.');
      }
    } else {
      print('File does not exist.');
    }
  }

  Future<bool> _decryptFile(String filePath) async {
    try {
      File file = File(filePath);
      List<int> fileBytes = await file.readAsBytes();

      // Replace this with your actual decryption mechanism
      // Here, the decryption reverses the XOR encryption used for demonstration purposes
      final key = 'YourEncryptionKey'; // Replace with your encryption key
      List<int> decryptedBytes =
          fileBytes.map((byte) => byte ^ key.codeUnitAt(0)).toList();

      // Write decrypted bytes back to the file
      await file.writeAsBytes(decryptedBytes);
      return true;
    } catch (e) {
      print("Decryption failed: $e");
      return false;
    }
  }
}
