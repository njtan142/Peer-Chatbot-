import 'package:chatbot/main/client/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'main.dart';
import 'widget_builder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (mounted) {
        replacePage(context, ClientDashboard());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "E-Consultation",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  whiteSpace(10),
                  Text(
                    "It's okay to be not okay",
                    style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(100.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
