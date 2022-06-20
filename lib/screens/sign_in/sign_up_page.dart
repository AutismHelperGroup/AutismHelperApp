import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/auth.dart';
import '../common_widgets/buttons/raised_button.dart';
import '../common_widgets/show_alert_dialog.dart';
class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _name => _nameController.text;
  String get _password => _passwordController.text;

  Future<void> _signUpButton(BuildContext context) async {
    final AuthBase? auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final User? user2 = await auth?.createUserWithEmailAndPassword(_email, _password);
      var user = {
          "Name" : _name,
          "Email": _email,
          "IDD": user2!.uid,
          "ProfilePictureURL": 'https://firebasestorage.googleapis.com/v0/b/autismhelperdatabase.appspot.com/o/UsersProfilePhoto%2FuserLogo.png?alt=media&token=30b77c9b-8469-40dc-a2c8-94b48ae1ea51'
      };
      CollectionReference database = FirebaseFirestore.instance.collection('/User');
      await database.doc(user2.uid).set(user)
          .then((value) =>  print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showAlertDialog(
        context,
        content: e.message,
        title: "Sign in failed",
        cancelActionText: "",
        defaultActionText: "OK",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed:() {
            Navigator.of(context).pop();
          },
        ),
        title: Center(child: Image.asset('images/title.png', scale: 18)),
        actions: const [
          SizedBox(width: 50),
        ],
        elevation: 10.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    child: Image.asset('images/logo.png'),
                    height: 80.0,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Welcome !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 25.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name',
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        controller: _emailController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        controller: _passwordController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                        obscureText: true,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  const SizedBox(height: 20),
                  CustomRaisedButton(
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () {
                      _signUpButton(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: signUpRowChildren(context),
                  ),
                ])));
  }

  List<Widget> signUpRowChildren(BuildContext context) {
    return [
      const Text(
        'already have an account?',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black45,
          fontSize: 15.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'login here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
            ),
          )),
    ];
  }
}
