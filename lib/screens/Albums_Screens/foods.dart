// ignore_for_file: prefer_const_constructors

<<<<<<< Updated upstream
import 'package:autism_helper_project/database.dart';
import 'package:flutter/material.dart';

import '../../Widgets/profile_picture.dart';

=======
import 'package:flutter/material.dart';

>>>>>>> Stashed changes
class Foods extends StatelessWidget {
  const Foods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      appBar: AppBar(
        title: Center(child: Image.asset('images/title.png', scale: 18)),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_box_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          GestureDetector(
            onTap:(){} /*_signOut*/,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, right: 5, left: 5),
              child: ProfilePicture(
                pictureUrl: defaultUser.profilePictureUrl,
                pictureSize: 30,
              ),
            ),
          ),//(ProfilePicture)
        ],
      ),
      body: SafeArea(child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildContent(),
=======
      body: SafeArea(child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Foods'),
>>>>>>> Stashed changes
        ),
      )),
    );

  }
<<<<<<< Updated upstream
  Widget _buildContent() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 3,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                child: Image.network(
                  images[index].url,
                  width: 400,
                  height:120,
                ),
              ), //(Picture)
            ],
          );
        });
  }
=======

>>>>>>> Stashed changes

}
