import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Make sure you have GetX package added
import 'package:patuhapps/pages/akunlogin.dart'; // Adjust the import based on your file structure

class AppSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Schedule the splash screen delay and navigation to AkunLogin page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        // Using Get.off to replace the current route (prevents going back to the splash screen)
        Get.off(() => AkunLogin());
      });
    });

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color(0x6cdedede),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: Color(0x4d9e9e9e), width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      "assets/images/logoapp.png",
                      height: 120,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "SiPatuh",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 32,
                        color: Color(0xff3a57e8),
                      ),
                    ),
                    Text(
                      "App",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 32,
                        color: Color(0xff3a57ea),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
