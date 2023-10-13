import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/conditions_page.dart';
import 'package:flutter_app2/Pages/event_page.dart';
import 'package:flutter_app2/Pages/forgot_password_page.dart';
import 'package:flutter_app2/Pages/home_page.dart';
import 'package:flutter_app2/Pages/test_page.dart';
import 'package:flutter_app2/Pages/welcome_page.dart';
import 'package:flutter_app2/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../timer_page.dart';
import 'delayed_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_page.dart';
import 'inscription_page.dart';
import 'verif_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        //rendre la appBar transparent
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
        //l'icone fleche de retour
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            // rendre le bouton cliquable vers une page
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DelayedAnimation(delay: 1500,
                child: Container(
                 // margin: EdgeInsets.only(top:0),
                  height: 300,
                  child: SvgPicture.asset("assets/images/ilovepizza.svg"),
                )
            ),
            DelayedAnimation(delay: 1500,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        Text("Le changement commence ici.",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Enregistrer votre compte pour accéder à nos produits ainsi qu'à notre programme de fidélité.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ),
            DelayedAnimation(
                delay: 3500,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 50,
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => InscriptionPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            primary: Colors.white24
                          ),
                          // aménager l'intérieur du bouton
                          child: Row(
                            // mettre le texte au centre
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.mail_lock_outlined),
                              // séparer l'icone du texte
                              SizedBox(width: 10),
                              Text("EMAIL", style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              ),)
                            ],
                          )
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MdpForget(), fullscreenDialog: true),);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Color(0xFF576dff),
                          ),
                          // aménager l'intérieur du bouton
                          child: Row(
                            // mettre le texte au centre
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.facebook),
                              // séparer l'icone du texte
                              SizedBox(width: 10),
                              Text("FACEBOOK",style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              ),)
                            ],
                          )
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage(),),);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.white
                          ),
                          // aménager l'intérieur du bouton
                          child: Row(
                            // mettre le texte au centre
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               SvgPicture.asset('assets/images/google-icon.svg', height: 20,),
                              // séparer l'icone du texte
                              SizedBox(width: 10),
                              Text("GOOGLE", style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              ), ),
                            ],
                          )
                      ),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                          child: Text("Se Connecter",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600
                          ),
                          )
                      )
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
