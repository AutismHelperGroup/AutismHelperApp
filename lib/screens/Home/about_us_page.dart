import 'package:autism_helper_project/models/about_us.dart';
import 'package:autism_helper_project/screens/common_widgets/app_bar_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user.dart';
import '../../services/database.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key, required this.user, required this.database}) : super(key: key);

  final User1 user;
  final Database database;


  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  late DocumentReference<Map<String, dynamic>> pageData;
  late AboutUs aboutUsData = AboutUs();
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    pageData = widget.database.getAboutUsData();
    return Scaffold(
        appBar: AppBarDesign(
          aTitle: Center(child: Center(
            child: Text(
              'About Us',
              style: GoogleFonts.abel(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),),
          aLeading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          user: widget.user,
        ),
        body: buildContent());
  }

  SingleChildScrollView buildContent() {
    pageData.get().then((DocumentSnapshot data) {
      if (data.exists) {
        aboutUsData = AboutUs.fromMap(data);
        if(!isDone){
          setState((){isDone = true;});
        }
      }
    });
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  aboutUsData.text,
                  style: GoogleFonts.abel(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('images/logo.png',scale: 4),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Email : ${aboutUsData.email}\n\nPhone : ${aboutUsData.phoneNumber}\n\nAddress : ${aboutUsData.address}',
                  style: GoogleFonts.abel(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}