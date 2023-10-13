import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'delayed_animation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/widgets.dart';
import 'social_page.dart';


class WelcomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Column(
              children: [
              DelayedAnimation(delay: 1500,
              child: Container(
                margin: EdgeInsets.only(top:100),
                height: 300,
                child: SvgPicture.asset("assets/images/ilovepizza.svg"),
              )
          ),
                DelayedAnimation(
                  delay: 2500,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(top: 200),
                    child: ElevatedButton(
                      //style du bouton
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white12,
                        //bouton arrondi
                        shape: StadiumBorder(),
                      ),
                      child: Text(
                        "COMMENCER",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SocialPage(),
                        )
                        );
                      },
                    ),
                  ),
                ),

              ]
          )
      ),
    ),
    );
  }
}
