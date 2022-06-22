import 'dart:io';
import 'package:autism_helper_project/models/user.dart';
import 'package:autism_helper_project/screens/common_widgets/app_bar_design.dart';
import 'package:autism_helper_project/screens/common_widgets/profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../models/picture.dart';
import '../../services/database.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key, required this.user, required this.database})
      : super(key: key);

  final User1 user;
  final Database database;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {


  String item = '0';
  var labelBoxController = TextEditingController();
  Picture picture = Picture(
    pictureUrl: 'https://static.vecteezy.com/system/resources/previews/003/513/803/large_2x/single-banana-cartoon-illustration-isolated-free-vector.jpg',
  );



  // List of items in our dropdown menu
  @override
  Widget build(BuildContext context) {
    picture.userID = widget.user.userId;
    return Scaffold(
      appBar: AppBarDesign(
        aTitle: Center(
          child: Text(
            'Add a new image',
            style: GoogleFonts.abel(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
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
              const SizedBox(height: 50),
              Stack(
                children: [
                  ProfilePicture(
                    pictureUrl:  picture.pictureUrl,
                    pictureSize: 220,
                    pictureRadius: 20,
                  ),
                  Positioned(
                    bottom: 7,
                    right: 7,
                    child: CircleAvatar(
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white70,
                          size: 23,
                        ),
                        onPressed: () {
                          yourChoice(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildNameField(),
              const SizedBox(height: 20),
              buildDropDown(),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          Navigator.pop(context, picture);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(width: 100),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          widget.database.setPicture(picture);
                          Navigator.pop(context, picture);
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
            textAlign: TextAlign.center,
            onChanged: (text) => {picture.pictureLabel = text},
            decoration: const InputDecoration.collapsed(
              border: InputBorder.none,
              hintText: 'Image Label',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
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
              child: Text('Persons                           '),
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
