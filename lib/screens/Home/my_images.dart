
import 'package:autism_helper_project/models/user.dart';
import 'package:autism_helper_project/screens/albums_screens/edit_image.dart';
import 'package:autism_helper_project/screens/common_widgets/app_bar_design.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/picture.dart';
import '../../services/database.dart';
import '../common_widgets/buttons/raised_button.dart';



class MyImages extends StatefulWidget {
   const MyImages({Key? key, required this.user, required this.database}) : super(key: key);

   final User1 user;
   final Database database;

   @override
  State<MyImages> createState() => _MyImagesState();
}

class _MyImagesState extends State<MyImages> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(
        aTitle: Center(child: Center(child: Center(
          child: Text(
            'My Images' ,
            style: GoogleFonts.abel(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),),),
        aLeading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildContent(),
        ),
      )),
    );
  }

  Widget _buildContent() {
    final Stream<QuerySnapshot> _pictureStream = FirebaseFirestore.instance.collection('Picture')
        .where("UserID", isEqualTo: widget.user.userId).snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _pictureStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                Picture picture = Picture.fromMap(data);
                return SizedBox(
                  width: 150,
                  child: CustomRaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              fullscreenDialog: true, builder: (context) => EditImage(user: widget.user,picture :picture,database: widget.database ,)
                          ),
                      );
                      setState((){});
                      },
                    child: CachedNetworkImage(
                      imageUrl:picture.pictureUrl,
                      width: 150,
                      height: 150,
                    ),
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

}
