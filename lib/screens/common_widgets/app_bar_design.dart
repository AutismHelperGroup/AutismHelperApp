import 'package:autism_helper_project/models/user.dart';
import 'package:autism_helper_project/screens/common_widgets/profile_picture.dart';
import 'package:autism_helper_project/screens/common_widgets/show_alert_dialog.dart';
import 'package:autism_helper_project/screens/profile/profile_page.dart';
import 'package:autism_helper_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarDesign extends StatefulWidget implements PreferredSizeWidget {
  const AppBarDesign({Key? key, required this.aTitle, required this.aLeading, required this.user}) : super(key: key);
  final Widget aTitle;
  final Widget aLeading;
  final User1 user;

  @override
  State<AppBarDesign> createState() => _AppBarDesignState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}

class _AppBarDesignState extends State<AppBarDesign> {

  late Database database = Provider.of<Database>(context, listen: false,);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.aTitle,
      leading: widget.aLeading,
      actions: [
        GestureDetector(
          onTap: () async {
            if (widget.user.userId != '000') {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              await Navigator.of(context).push(
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => ProfilePage(user: widget.user,database: database,)
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
              pictureUrl: widget.user.userProfilePictureUrl,
              pictureSize: 30,
              pictureRadius: 60,
            ),
          ),
        ), //(ProfilePicture)
      ],
    );
  }


}