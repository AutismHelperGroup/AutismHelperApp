// ignore_for_file: prefer_const_constructors
import 'package:autism_helper_project/database.dart';
import 'package:autism_helper_project/screens/Home/home_page.dart';
import 'package:autism_helper_project/screens/common_widgets/profile_picture.dart';
import 'package:autism_helper_project/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';

class AddImage extends StatelessWidget {
  const AddImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset('images/title.png', scale: 18)),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true, builder: (_) => const ProfilePage())),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, right: 5, left: 5),
              child: ProfilePicture(
                pictureUrl: defaultUser.userProfilePictureUrl,
                pictureSize: 30,
              ),
            ),
          ), //(ProfilePicture)
        ],
      ),
    );
  }
}
