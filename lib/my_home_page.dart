import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:my_upload/network_service.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  dynamic _pickImageError; // optional

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Image.network(
                        "https://ichef.bbci.co.uk/news/660/cpsprodpb/51F3/production/_106997902_gettyimages-611696954.jpg",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width)),
                if (_imageFile != null)
                  Expanded(
                    flex: 4,
                    child: Image.file(
                      _imageFile,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text((_pickImageError == null)
                          ? "Please pick image"
                          : _pickImageError),
                    ),
                  )
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      child: Icon(Icons.photo_camera),
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.file_upload),
                      backgroundColor: Colors.red,
                      onPressed: () async {
                        if(_imageFile != null){
                        String result =  await NetWorkService().upload(_imageFile);
                        print(result);
                        }else{
                          //todo
                        }
                      },
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.photo_library),
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    try {
      _imageFile = await ImagePicker.pickImage(
        source: source,
      );
      _cropImage();
    } catch (exception) {
      _pickImageError = exception;
      setState(() {});
    }
  }

  Future<Null> _cropImage() async {
    /**
     * Config Android
     * - AndroidManifest.xml (Add Activity)
     */
     ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      ratioX: 1.0,
      ratioY: 1.2,
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.blue,
      toolbarWidgetColor: Colors.white,
      statusBarColor: Colors.black,
      //circleShape: true
    ).then((file) {
      if (file != null) {
        _imageFile = file;
      }
    });

    if (_imageFile != null) {
      setState(() {});
    }
  }
}
