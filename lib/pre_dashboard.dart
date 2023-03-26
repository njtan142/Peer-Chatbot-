import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main/client/dashboard.dart';
import 'widget_builder.dart';

class PreDashboard extends StatefulWidget {
  const PreDashboard({super.key});

  @override
  State<PreDashboard> createState() => _PreDashboardState();
}

class _PreDashboardState extends State<PreDashboard> {
  Timer? timer;

  @override
  void initState() {
    setDashboard();
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
      setDashboard();
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Future<void> setDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString("userType");

    if (userType == null) {
      return;
    }

    if (!mounted) {
      return;
    }
    print(userType);

    switch (userType) {
      case "client":
        goToPage(context, ClientDashboard());
        timer!.cancel();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
