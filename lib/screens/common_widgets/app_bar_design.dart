import 'package:autism_helper_project/models/user.dart';
import 'package:autism_helper_project/screens/common_widgets/profile_picture.dart';
import 'package:autism_helper_project/screens/common_widgets/show_alert_dialog.dart';
import 'package:autism_helper_project/screens/profile/profile_page.dart';
import 'package:autism_helper_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarDesign extends StatefulWidget implements PreferredSizeWidget {
  const AppBarDesign({Key? key, required this.aTitle, required this.aLeading}) : super(key: key);
  final Widget aTitle;
  final Widget aLeading;

  @override
  State<AppBarDesign> createState() => _AppBarDesignState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}

class _AppBarDesignState extends State<AppBarDesign> {
  User1 user = User1(
      userId: '000',
      name: 'User',
      userProfilePictureUrl:
      'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80');

  late Database database = Provider.of<Database>(context, listen: false,);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.aTitle,
      leading: widget.aLeading,
      actions: [
        GestureDetector(
          onTap: () async {
            if (user.userId != '000') {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              user = await Navigator.of(context).push(
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => ProfilePage(user: user,database: database,)
                  )
              );
              setState((){});
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
              pictureUrl: user.userProfilePictureUrl,
              pictureSize: 30,
              pictureRadius: 60,
            ),
          ),
        ), //(ProfilePicture)
      ],
    );
  }


}