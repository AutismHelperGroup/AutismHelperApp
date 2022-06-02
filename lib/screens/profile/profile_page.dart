// ignore_for_file: prefer_const_constructors

import 'package:autism_helper_project/database.dart'; 
import 'package:autism_helper_project/screens/Home/home_page.dart';
import 'package:autism_helper_project/screens/profile/edit_profile_page.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../common_widgets/profile_picture.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  User1 user = User1(
      name : 'Ahmad Maen',
      userProfilePictureUrl :'https://firebasestorage.googleapis.com/v0/b/autismhelperdatabase.appspot.com/o/me.jpg?alt=media&token=4f1810e4-1405-458c-b83d-1f490c011ecf'
  );


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
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true, builder: (_) => HomePage()));
              }),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true, builder: (_) => const ProfilePage())),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, right: 5, left: 5),
                child: ProfilePicture(
                  pictureUrl: user.userProfilePictureUrl,
                  pictureSize: 30,
                ),
              ),
            ), //(ProfilePicture)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    ProfilePicture(
                      pictureUrl: defaultUser.userProfilePictureUrl,
                      pictureSize: 130,
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: CircleAvatar(
                        child: IconButton(
                          icon: Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.white70,
                            size: 25,
                          ),
                          onPressed: () {},
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  defaultUser.userName,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => EditProfile()));
                              },
                              icon: Icon(
                                Icons.edit_outlined,
                                size: 25,
                              )))),
                ),
                SizedBox(height: 15),
                buildNameField(),
                SizedBox(height: 20),
                buildEmailField(),
                SizedBox(height: 20),
                buildPasswordField(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  Padding buildNameField() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: TextEditingController()..text = '\n' + user.name,
        onChanged: (text) => {},
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Name',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20),
        ),
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: TextEditingController()
          ..text = '\n' + user.userEmail,
        onChanged: (text) => {},
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Email',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Padding buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: TextEditingController()..text = user.userPassword,
        onChanged: (text) => {},
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20),
        ),
        obscureText: true,
      ),
    );
  }

  /* void _updateState() {
    setState(() {});
  }
  */

}