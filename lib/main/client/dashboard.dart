import 'dart:async';

import 'package:chatbot/main/client/chatbox.dart';
import 'package:chatbot/main/client/drawer.dart';
import 'package:chatbot/main/client/profile_completer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase/profiles/client.dart';
import '../../widget_builder.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  bool completeProfile = true;
  String? nickname;
  int? avatarIndex;

  @override
  void initState() {
    super.initState();
    checkProfileComplete();
  }

  Future checkProfileComplete() async {
    final prefs = await SharedPreferences.getInstance();

    nickname = prefs.getString("nickname");
    avatarIndex = prefs.getInt("avatar");

    print("Nickname: $nickname");
    print("Avatar: $avatarIndex");

    bool complete = nickname != null && avatarIndex != null;
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: ClientDrawer(),
      body: Center(
          child: Column(
        children: [
          !completeProfile
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Your profile is not complete yet"),
                          TextButton(
                              onPressed: () {
                                goToPage(
                                    context,
                                    ClientProfileCompleter(
                                      nickname: nickname,
                                      avatarIndex: avatarIndex,
                                    ));
                              },
                              child: Text("Edit profile")),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
          whiteSpace(20),
          actionButton(
            context,
            "Engage Chat",
            width: 300,
            height: 50,
            textsize: 20,
            onPressed: () {
              goToPage(context, ChatScreen());
            },
          )
        ],
      )),
    );
  }
}
