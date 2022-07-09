import 'package:autism_helper_project/screens/common_widgets/app_bar_design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/contact_us.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../common_widgets/show_alert_dialog.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key, required this.user, required this.database}) : super(key: key);


  final Database database;
  final User1 user;

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State <ContactUsPage> {

  late ContactUs contactUs;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  String get _name => _nameController.text;
  String get _email => _emailController.text;
  String get _text => _textController.text;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarDesign(
          aTitle: Center(child: Center(
            child: Text(
              'Contact Us',
              style: GoogleFonts.abel(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          )
          ),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                Image.asset('images/logo.png',scale: 4),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Contact Us',
                    style: GoogleFonts.abel(
                        fontSize: 30,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Write a note for us, and we will contact you :',
                    style: GoogleFonts.abel(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                buildNameCard(context),
                const SizedBox(height: 5),
                buildEmailCard(context),
                const SizedBox(height: 5),
                buildTextCard(context),
                const SizedBox(height: 25),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                      onPressed: () => _setContactUsData(),
                      child: const Text(
                        "SEND",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                ),

              ],
            ),
          ),
        ));
  }

  Card buildNameCard(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: TextField(
          controller: _nameController,
          textAlign: TextAlign.start,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Your Name',
          ),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }

  Card buildEmailCard(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: TextField(
          controller: _emailController,
          textAlign: TextAlign.start,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Your Email',
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }

  SizedBox buildTextCard(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        semanticContainer: true,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextField(
            controller: _textController,
            textAlign: TextAlign.start,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Your Message',
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  Future<void> _setContactUsData() async {
    try {
       contactUs = ContactUs(
         message: _text,
         email: _email,
         name: _name,
      );
       widget.database.setContactUs(contactUs);
       _textController.clear();
       _emailController.clear();
       _nameController.clear();

    } on FirebaseAuthException catch (e) {
      showAlertDialog(
        context,
        content: e.message,
        title: "failed",
        cancelActionText: "",
        defaultActionText: "OK",
      );
    }
  }

}
