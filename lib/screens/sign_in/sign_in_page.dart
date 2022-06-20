import 'package:autism_helper_project/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import '../common_widgets/buttons/raised_button.dart';
import '../common_widgets/show_alert_dialog.dart';
import 'sign_up_page.dart';
import 'validator.dart';


class SignInPage extends StatefulWidget with EmailAndPasswordValidators {
   SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

   @override
   void dispose() {
     _emailController.dispose();
     _passwordController.dispose();
     _emailFocusNode.dispose();
     _passwordFocusNode.dispose();
     super.dispose();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset('images/title.png', scale: 18)),
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
              logoBox(),
              const SizedBox(height: 15),
              welcomeBackText(),
              const SizedBox(height: 15),
              logInToYourAccountText(),
              const SizedBox(height: 15),
              buildEmailCard(context),
              const SizedBox(height: 10),
              buildPasswordCard(),
              const SizedBox(height: 20),
              CustomRaisedButton(
                child: signInButtonLabel(),
                onPressed: (){  _signInButton(context); },
              ),
              const SizedBox(height: 10),
              signInWithText(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: signInWithRowChildren(context),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  signUpRowChildren(context),
              ),
              const SizedBox(height: 10),
              CustomRaisedButton(
                child: const Text(
                  'Continue without an account',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                onPressed: (){ _signInwWthAnonymous(context);},
              ),
            ],
          )),
    );
  }

  SizedBox logoBox() {
    return SizedBox(
            child: Image.asset('images/logo.png'),
            height: 80.0,
          );
  }

  Text welcomeBackText() {
     return const Text(
       'Welcome Back!',
       textAlign: TextAlign.center,
       style: TextStyle(
         color: Colors.black45,
         fontSize: 25.0,
         fontWeight: FontWeight.normal,
       ),
     );
   }

  Text logInToYourAccountText() {
    return const Text(
            'Login to your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
            ),
          );
  }

  void _emailEditingComplete(BuildContext context) {
     /*final newFocus = emailValidator.isValid(_email)
         ? _passwordFocusNode
         : _emailFocusNode;*/
     FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  Card buildEmailCard(BuildContext context) {

    return Card(
            elevation: 2,
            child:  Padding(
              padding: const EdgeInsets.only(left: 16.0 ),
              child : TextField(
                controller: _emailController,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _emailFocusNode,
                onEditingComplete: (){_emailEditingComplete(context);},
              ),
            ),
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          );
  }

  Card buildPasswordCard() {
     return Card(
       elevation: 2,
       child: Padding(
         padding: const EdgeInsets.only(left: 16.0 ),
         child : TextField(
           controller: _passwordController,
           textAlign: TextAlign.start,
           decoration:  const InputDecoration(
             border: InputBorder.none,
             hintText:'Password',
           ),
           obscureText: true,
           focusNode: _passwordFocusNode,
         ),
       ),
       shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
     );
  }

  Text signInButtonLabel() {
     return const Text(
       'Sign in',
       style: TextStyle(
         color: Colors.white,
         fontWeight: FontWeight.bold,
         fontSize: 17,
       ),
     );
   }

  Future<void> _signInButton(BuildContext context) async {
    final AuthBase? auth = Provider.of<AuthBase>(context ,listen: false);
    try {
       await auth?.signInWithEmailAndPassword(_email, _password);
     } on FirebaseAuthException catch (e) {
      showAlertDialog (
        context,
        content: e.message,
        title: "Sign in failed",
        cancelActionText: "",
        defaultActionText: "OK",
      );
     }
   }

  Text signInWithText() {
     return const Text(
       '--------------------- Or sign in with ---------------------',
       textAlign: TextAlign.center,
       style: TextStyle(
         color: Colors.black45,
         fontSize: 15.0,
         fontWeight: FontWeight.normal,
       ),
     );
   }

  //////////////////////////////////////////////////////

  List<Widget> signUpRowChildren(BuildContext context) {
    return [
              const Text(
                'Don\'t have an account? ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextButton(
                  onPressed: () {_signUpButton(context); },
                  child: const Text(
                    'Sign up here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  )
              ),
            ];
  }

  List<Widget> signInWithRowChildren(BuildContext context) {
    return <Widget>[
              CustomRaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('images/twitter.png'),
                  )
              ),
              const SizedBox(width: 35),
              CustomRaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('images/Facebook.png'),
                  )
              ),
              const SizedBox(width: 35),
              CustomRaisedButton(
                  onPressed: (){_signInWithGoogle(context);},
                  color: Colors.white,
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset('images/google.png'),
                  )
              ),
            ];
  }

  ////////////////////////////////////////////////////////

  Future<void> _signInwWthAnonymous(BuildContext context) async {
    final AuthBase? auth = Provider.of<AuthBase>(context ,listen: false);
     try {
       await auth?.signInAnonymously();

     } on FirebaseAuthException catch (e) {
       showAlertDialog (
         context,
         content: e.message,
         title: "Sign in failed",
         cancelActionText: "",
         defaultActionText: "OK",
       );
     }
     finally{
     }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final AuthBase? auth = Provider.of<AuthBase>(context ,listen: false);
    try {
      final User? user2 = await auth?.signInWithGoogle();
      var user = {
        "Name" : user2!.displayName,
        "Email": user2.email,
        "IDD": user2.uid,
        "ProfilePictureURL": 'https://firebasestorage.googleapis.com/v0/b/autismhelperdatabase.appspot.com/o/UsersProfilePhoto%2FuserLogo.png?alt=media&token=30b77c9b-8469-40dc-a2c8-94b48ae1ea51'
      };
      CollectionReference database = FirebaseFirestore.instance.collection('/User');
      await database.doc(user2.uid).set(user)
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      showAlertDialog (
        context,
        content: e.message,
        title: "Sign in failed",
        cancelActionText: "",
        defaultActionText: "OK",
      );
    }
    finally{
    }
  }

  void _signUpButton(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) =>  SignUpPage(),
    ),);
  }

}
