import 'package:chatbot/firebase/profiles/client.dart';
import 'package:chatbot/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProfileCompleter extends StatefulWidget {
  const ClientProfileCompleter({super.key, this.nickname, this.avatarIndex});
  final String? nickname;
  final int? avatarIndex;

  @override
  State<ClientProfileCompleter> createState() => _ClientProfileCompleterState();
}

class _ClientProfileCompleterState extends State<ClientProfileCompleter> {
  bool done = false;
  bool selected = false;
  int? selectedIndex;
  final nicknameInputController = new TextEditingController();
  String nicknameInput = "";
  String? nickname = "";
  int? avatarIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      setState(() {
        nickname = widget.nickname;
        avatarIndex = widget.avatarIndex;
      });
    }
  }

  Future onAvatarSave() async {
    final prefs = await SharedPreferences.getInstance();
    avatarIndex = selectedIndex;
    if (avatarIndex != null) {
      prefs.setInt("avatar", avatarIndex!);
    }

    if (nickname != null) {
      done = true;
    }
    setState(() {});
  }

  Future onNicknameSave() async {
    final prefs = await SharedPreferences.getInstance();
    nickname = nicknameInput;
    if (nickname != null) {
      prefs.setString("nickname", nickname!);
    }
    done = true;
    setState(() {});
  }

  Widget renderAvatar(BuildContext context,
      {required String filename, required int index}) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            selectedIndex = index;
          });
        }
      },
      child: Container(
        decoration: selectedIndex == index
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.fromARGB(255, 40, 238, 119),
                  width: 4,
                ),
              )
            : null,
        child: ClipOval(
          child: Image.asset(
            'assets/images/$filename',
            height: 100 - (selectedIndex == index ? 8 : 0),
            width: 100 - (selectedIndex == index ? 8 : 0),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget avatarSelection(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Select an avatar",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                whiteSpace(30),
                Card(
                  elevation: 0,
                  color: Color.fromARGB(0, 0, 0, 0),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: AlignmentDirectional.center,
                      child: Wrap(
                        verticalDirection: VerticalDirection.down,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          renderAvatar(context, filename: "boy1.png", index: 0),
                          renderAvatar(context, filename: "boy2.png", index: 1),
                          renderAvatar(context, filename: "boy3.png", index: 2),
                          renderAvatar(context,
                              filename: "girl1.png", index: 3),
                          renderAvatar(context,
                              filename: "girl2.png", index: 4),
                          renderAvatar(context,
                              filename: "girl3.png", index: 5),
                        ],
                      ),
                    ),
                  ),
                ),
                whiteSpace(20),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: selectedIndex != null
                    ? actionButton(context, "Save",
                        onPressed: onAvatarSave,
                        width: 300,
                        height: 50,
                        textsize: 25)
                    : Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget n

  Future closePage() async {
    Future.delayed(Duration(seconds: 2), () {
      restart();
    });
  }

  Widget nicknameForm(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "How should I call you?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            whiteSpace(20),
            createInput(
              context,
              300,
              "Nickname",
              onChanged: (input) {
                if (mounted) {
                  setState(() {
                    nicknameInput = input;
                  });
                }
              },
            ),
            nicknameInput != ""
                ? actionButton(context, "Save", onPressed: onNicknameSave)
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!done) {
      if (avatarIndex == null) {
        return avatarSelection(context);
      }
      if (nickname == null) {
        return nicknameForm(context);
      }
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    closePage();
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Thank You $nickname",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
          ),
          whiteSpace(5),
          Text(
            "for completing your profile",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      )),
    );
  }
}
