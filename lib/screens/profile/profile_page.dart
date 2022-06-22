import 'package:autism_helper_project/models/user.dart';
import 'package:autism_helper_project/screens/common_widgets/app_bar_design.dart';
import 'package:autism_helper_project/screens/common_widgets/profile_picture.dart';
import 'package:autism_helper_project/screens/profile/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user, required this.database}) : super(key: key);

  final User1 user;
  final Database database;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late User1 user ;

  @override
  Widget build(BuildContext context) {
    user = widget.user;
    return Scaffold(
        appBar: AppBarDesign(
          aTitle: Center(child: Text( 'Profile Page',
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
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Column(
                children: [
                  ProfilePicture(
                    pictureUrl : user.userProfilePictureUrl,
                    pictureSize: 130,
                    pictureRadius: 200,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child:  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: IconButton(
                                  onPressed: () async {
                                    user = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) => EditProfilePage(user: widget.user,database : widget.database)
                                        )
                                    );
                                    setState((){});
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 25,
                                  )))),
                    ),
                  ),
                  Container(child: const Text('Name :',style: TextStyle(color: Colors.blueGrey),),alignment: Alignment.centerLeft,margin: const EdgeInsets.only(left: 7 ),),
                  buildNameField(),
                  const SizedBox(height: 15),
                  Container(child: const Text('Email :' ,style: TextStyle(color: Colors.blueGrey),),alignment: Alignment.centerLeft,margin: const EdgeInsets.only(left: 7),),
                  buildEmailField(),
                  const SizedBox(height: 15),
                  Container(child: const Text('Password :' ,style: TextStyle(color: Colors.blueGrey),),alignment: Alignment.centerLeft,margin: const EdgeInsets.only(left: 7),),
                  buildPasswordField(),
                ],
              ),

            ),
          ),
        ));

  }


  Padding buildNameField() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextFormField(
        controller: TextEditingController()..text = user.name,
        onChanged: (text) => {},
        enabled: false,
        decoration: const InputDecoration(
          fillColor: Colors.white,
          border: InputBorder.none,
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
        enabled: false,
        controller: TextEditingController()
          ..text = user.email,
        onChanged: (text) => {},
        decoration: const InputDecoration(
          border: InputBorder.none,
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
        enabled: false,
        controller: TextEditingController()
          ..text = 'YourPassword',
        obscureText: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

