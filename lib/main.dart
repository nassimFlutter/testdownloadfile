import 'package:flutter/material.dart';
import 'package:testdownloadfile/DownloadProgressDialog.dart';
import 'package:testdownloadfile/file_doonloader.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
    home: const MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FileDownload f = FileDownload();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download file in flutter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (dialogcontext) {
                        return DownloadProgressDialog();
                      });
                },
                child: const Text("Download File")),
            ElevatedButton(
                onPressed: () async {
                  await f.openEncryptedFile();
                },
                child: const Text("Open File"))
          ],
        ),
      ),
    );
  }
}
