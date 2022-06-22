import 'dart:io';

import 'package:autism_helper_project/screens/common_widgets/app_bar_design.dart';
import 'package:autism_helper_project/screens/common_widgets/profile_picture.dart';
import 'package:autism_helper_project/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../models/picture.dart';
import '../../models/user.dart';
class EditImage extends StatefulWidget {
  const EditImage({Key? key, required this.picture, required this.user, required this.database }) : super(key: key);

  final Picture picture;
  final User1 user;
  final Database database;


  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {

  String item = '0';
  late Picture picture;

  // List of items in our dropdown menu
  @override
  Widget build(BuildContext context) {
    picture = widget.picture;
    item = picture.albumID;
    return Scaffold(
      appBar: AppBarDesign(
        aTitle: Center(child: Text(
          'Edit an image',
          style: GoogleFonts.abel(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),),
        aLeading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context,picture);
            }),

      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Stack(
                children: [
                  ProfilePicture(
                    pictureUrl: picture.pictureUrl,
                    pictureSize: 220,
                    pictureRadius: 20,
                  ),
                  Positioned(
                    bottom: 1,
                    right: 10,
                    child: CircleAvatar(
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white70,
                          size: 23,
                        ),
                        onPressed: () { yourChoice(context);},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildNameField(),
              const SizedBox(height: 20),
              buildDropDown(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                        onPressed: () {
                          Navigator.pop(context,picture);
                          },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                        onPressed: () {
                          widget.database.deletePicture(picture);
                          Navigator.pop(context,picture);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                        onPressed: () {
                          widget.database.updateImage(picture);
                          Navigator.pop(context,picture);
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildNameField() {
    return Padding(
      padding: const EdgeInsets.only(left: 100.0, right: 100.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            initialValue: picture.pictureLabel,
            textAlign: TextAlign.center,
            onChanged: (text) => {picture.pictureLabel = text},
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
        ),
      ),
    );
  }

  SizedBox buildDropDown() {
    return SizedBox(
      width: 200,
      child:
      DropdownButton(
        value: item,
        items: const [
          DropdownMenuItem(
            child: Text('Persons                          '),
            value: '0',
          ),
          DropdownMenuItem(
            child: Text('Feelings'),
            value: '1',
          ),
          DropdownMenuItem(
            child: Text('Places'),
            value: '2',
          ),
          DropdownMenuItem(
            child: Text('Games'),
            value: '3',
          ),
          DropdownMenuItem(
            child: Text('Drinks'),
            value: '4',
          ),
          DropdownMenuItem(
            child: Text('Foods'),
            value: '5',
          ),
        ],
        onChanged: dropdownCallback,
      ),
    );
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        item = selectedValue;
        picture.albumID = selectedValue;
      });
    }
  }

  void yourChoice(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(selectImage(ImageSource.camera)) ,
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () => Navigator.of(context).pop(selectImage(ImageSource.gallery)),
              )
            ]
        )
    );
  }

  Future selectImage(ImageSource source) async {
    String imageUrl="";
    try {

      var newImage = await ImagePicker().pickImage(source: source);//getting picture from phone

      var imageFile = File(newImage!.path);

      String fileName = basename(imageFile.path);

      Reference storageRef = FirebaseStorage.instance.ref().child("UserImage/$fileName");

      UploadTask uploadTask = storageRef.putFile(imageFile);


      await uploadTask.whenComplete( () async {
        var url = await storageRef.getDownloadURL();
        imageUrl = url.toString();
      }).catchError( (onError) {
        if (kDebugMode) {  print(onError);   }
      });


      picture.pictureUrl = imageUrl;
      setState((){});


    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }


}