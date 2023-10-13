import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'delayed_animation.dart';

class ConditionsPage extends StatelessWidget {
  const ConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(""),
        //rendre la appBar transparent
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
        //l'icone fleche de retour
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            // rendre le bouton cliquable vers une page de retour
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DelayedAnimation(delay: 1500, child: Text("Accepter les conditions générales d'utilisation",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DelayedAnimation(delay: 1500, child: Text("Accepter les conditions générales d'utilisation",
                    style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
