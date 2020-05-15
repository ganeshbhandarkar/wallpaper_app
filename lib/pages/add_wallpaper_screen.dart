import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// to get the image path

import 'package:path/path.dart' as path;

class WallpaperAdd extends StatefulWidget {
  @override
  _WallpaperAddState createState() => _WallpaperAddState();
}

class _WallpaperAddState extends State<WallpaperAdd> {
  final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();

  List<ImageLabel> detectedLabels;

  File _image;
  bool _isuploading = false;
  bool _iscompleted = false;

  var labelsInString;


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void dispose() {
    labeler.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Add Wallpaper"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: _loadImage,
                child: _image != null
                    ? Image.file(_image)
                    : Image(
                        image: AssetImage("assets/placeholder.jpg"),
                      ),
              ),
              Text("Click on Image to upload"),
              SizedBox(
                height: 20,
              ),
              detectedLabels != null
                  ? Wrap(
                      spacing: 10,
                      children: detectedLabels.map((l) {
                        return Chip(
                          label: Text(l.text),
                        );
                      }).toList(),
                    )
                  : Container(),
              SizedBox(height: 40,),
              if(_isuploading) ... [
                Text("Uploading Wallpaper"),
              ],
              if(_iscompleted) ... [
                Text("Uploaded"),
              ],
              SizedBox(height: 40,),
              RaisedButton(
                onPressed: _uploadImage,
                child: Text("Upload Image"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);

    List<ImageLabel> labels = await labeler.processImage(visionImage);

//    for(var label in labels){
//      print("${label.text} [${label.confidence}]");
//    }

    labelsInString = [];

    for(var l in labels){
      labelsInString.add(l.text);
    }

    setState(() {
      detectedLabels = labels;
      _image = image;
    });
  }

  void _uploadImage() async{

    if(_image!=null){

      String _fileName = path.basename(_image.path);

      FirebaseUser user = await _auth.currentUser();

      String uid = user.uid;

      StorageUploadTask task = _storage.ref().child("wallpapers").child(uid).child(_fileName).putFile(_image);

      task.events.listen((e){
        if(e.type == StorageTaskEventType.progress){
          setState(() {
            _isuploading = true;
          });
        }
        if(e.type == StorageTaskEventType.success){

          e.snapshot.ref.getDownloadURL().then((url){

            _db.collection("wallpapers").add({
              "url" : url,
              "date" : DateTime.now(),
              "uploaded_by" : user.uid,
              "tags" : labelsInString,
            });

                  Navigator.pop(context);
          });
          setState(() {
           _isuploading = false;
            _iscompleted = true;
          });
        }
      });

    }else{

      _showDialog();

    }

  }

  void _showDialog(){

    showDialog(
      context: context,
      builder: (cxt){
        return AlertDialog(
          title: Text("Error"),
          content: Text("select the image to upload"),
          actions: <Widget>[
            RaisedButton(
              onPressed: (){
                Navigator.of(cxt).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      }
    );

  }
}
