// ignore_for_file: prefer_const_constructors

import 'package:autism_helper_project/screens/Home/about_us_page.dart';
import 'package:autism_helper_project/screens/Home/my_images.dart';
import 'package:autism_helper_project/screens/profile/profile_page.dart';
import 'package:autism_helper_project/services/Translator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/auth.dart';
import '../../models/album.dart';
import '../../models/picture.dart';
import '../../services/database.dart';
import '../albums_screens/album_page.dart';
import '../common_widgets/buttons/raised_button.dart';
import '../common_widgets/profile_picture.dart';
import 'package:autism_helper_project/models/user.dart';
import '../common_widgets/show_alert_dialog.dart';
import 'contact_us_page.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final FlutterTts flutterTts = FlutterTts();
  var _icon = Icons.toggle_off_outlined;

  User1 user = User1(
      userId: '000',
      name: 'User',
      userProfilePictureUrl:
          'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80');
  Translator translator = Translator();


  late Database database = Provider.of<Database>(context, listen: false,);
  late DocumentReference<Map<String, dynamic>> userData = database.getUser();


  bool isDone = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    userData.get().then((DocumentSnapshot data) {
      if (data.exists) {
        user = User1.fromMap(data);
        if (!isDone) {
          setState(() {});
          isDone = true;
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset('images/title.png', scale: 18)),
        leading: menu(),
        actions: [
          GestureDetector(
            onTap: () {
              if (user.userId != '000') {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => ProfilePage(
                          user: user,
                        )));
              } else {
                showAlertDialog(
                  context,
                  title: 'Warning',
                  content: 'You need to sign up to view profile',
                  defaultActionText: 'OK',
                  cancelActionText: '',
                );
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12, bottom: 12, right: 5, left: 5),
              child: ProfilePicture(
                picture: Image.network(user.userProfilePictureUrl),
                pictureSize: 30,
                pictureRadius: 60,
              ),
            ),
          ), //(ProfilePicture)
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    final Database database = Provider.of<Database>(
      context,
      listen: false,
    );
    final Stream<QuerySnapshot> _albumStream =
        database.readAlbums() as Stream<QuerySnapshot>;
    return StreamBuilder<QuerySnapshot>(
        stream: _albumStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  Album album = Album.fromMap(data);
                  return SizedBox(
                    width: 150,
                    child: CustomRaisedButton(
                      onPressed: () => selectImage(album),
                      color: Color(album.albumColor),
                      child: Image.network(
                        album.url,
                        width: 150,
                        height: 150,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }

  /* Future<void> _setUserData(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
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
  */

  PopupMenuButton menu() {
    setState(() {});
    return PopupMenuButton(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 4.0,
        ),
        elevation: 20,
        offset: Offset(0, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        icon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("My Images"),
                value: 0,
              ),
              PopupMenuItem(
                child: Text("About Us"),
                value: 1,
              ),
              PopupMenuItem(
                child: Text("Contact Us"),
                value: 2,
              ),
              PopupMenuItem(
                child: Text("Sign Out"),
                value: 3,
              ),
            ],
        onSelected: (result) {
          if (result == 0) {
            if (user.userId != '000') {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => MyImages(user: user)));
            } else {
              showAlertDialog(
                context,
                title: 'warning',
                content: 'You need to sign up to add photo',
                defaultActionText: 'OK',
                cancelActionText: '',
              );
            }
          }
          if (result == 1) {
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => AboutUsPage(
                      user: user,
                      database: database,
                    )));
          } else if (result == 2) {
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ContactUsPage(
                      user: user,
                      database: database,
                    )));
          } else if (result == 3) {
            _confirmSignOut();
          }
        });
  }

  Future<void> _confirmSignOut() async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  Future<void> _signOut() async {
    final AuthBase? auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth?.signOut();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          if (kDebugMode) {
            print("Anonymous auth hasn't been enabled for this project.");
          }
          break;
        default:
          if (kDebugMode) {
            print("Unknown error.");
          }
      }
    }
  }

  IconButton buildDarkModeButton() {
    return IconButton(
      icon: Icon(
        _icon,
        color: Colors.black,
        size: 50,
      ),
      onPressed: () {
        setState(() {
          if (_icon == Icons.toggle_off_outlined) {
            _icon = Icons.toggle_on_outlined;
            //themeChange.darkTheme = true;
          } else {
            _icon = Icons.toggle_off_outlined;
            //themeChange.darkTheme = false;
          }
        });
      },
    );
  }

  selectImage(Album album) async {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    Picture picture = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AlbumPage(user: user, album: album, database: database),
          fullscreenDialog: true,
        )
    );

    translator.addPicture(picture);

    Future speak() async {
      await flutterTts.speak(translator.sentence);
    }

    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text(translator.sentence),
      actions: [
        TextButton(
          child: Text('Dismiss'),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.speaker_phone),
        onPressed: () => speak(),
      ),
      backgroundColor: Colors.white,
    ));
  }
}
