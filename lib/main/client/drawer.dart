import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase/auth.dart';
import '../../firebase/profiles/client.dart';
import '../../main.dart';
import '../../widget_builder.dart';

class ClientDrawer extends StatefulWidget {
  const ClientDrawer({super.key});

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
  String? nickname;
  int? avatarIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferences();
  }

  Future getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    nickname = prefs.getString("nickname");
    avatarIndex = prefs.getInt("avatar");
  }

  String getAvatarName(int index) {
    String gender;
    if (index < 3) {
      gender = "boy";
    } else {
      gender = "girl";
      index -= 3;
    }

    print(gender + (index + 1).toString() + ".png");

    return gender + (index + 1).toString() + ".png";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: GestureDetector(
              onTap: () {},
              child: ClipOval(
                child: avatarIndex != null
                    ? Image.asset(
                        'assets/images/${getAvatarName(avatarIndex!)}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            accountName: Text(nickname ?? "New User"),
            accountEmail: Text(
              "",
            ),
          ),
          Column(
            children: [
              // ListTile(
              //   title: const Text("View Profile"),
              //   onTap: () async {
              //     goToPage(context, ClientProfileView());
              //   },
              // ),
              ListTile(
                title: const Text("Signout"),
                onTap: () async {
                  bool? confirmed = await showSignOutDialog(context);
                  if (confirmed == null) {
                    return;
                  }
                  if (!confirmed) {
                    return;
                  }
                  await Client().updateActiveStatus();
                  await Auth().signOut();
                  showToast("Signed out");
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const MyApp()));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
