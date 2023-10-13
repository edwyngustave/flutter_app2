import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/login_page.dart';
import 'package:flutter_app2/Pages/verif_info.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'delayed_animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app2/main.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:process_run/process_run.dart';
import 'package:flutter_app2/bdd.dart';
import 'package:http/http.dart';


class MdpForget extends StatelessWidget {

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
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            // rendre le bouton cliquable vers une page
            runApp(MyApp());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DelayedAnimation(delay: 1500, child: Text("Mot de passe oublié",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  ),
                  SizedBox(height: 30,),
                  DelayedAnimation(delay: 1500, child: Text("Remplissez le formulaire étape par étape pour pouvoir réinitialiser votre mot de passe, si votre email est enregistré chez ilovepizza, un mail avec un lien de réinitialisation vous sera envoyé.",
                    style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  ),
                  SizedBox(height: 80,
                  ),
                  LoginForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class LoginForm extends StatefulWidget {

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey2 = GlobalKey<FormBuilderState>();
  TextEditingController _mail = TextEditingController();

  bool isLoadingForgotPass = false;
  bool isLoadingForgotPass2 = false;

  @override
  Widget build(BuildContext context) {


    final modele = Provider.of<Mysql>(context, listen: false);
    //méthode qui permet d'enregistrer les log du compte sur le tel, de l'utilisateur

    return Consumer<Mysql>(
        builder: (context, mysql, child) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: FormBuilder(
              key: _formKey2,
              child: Column(
                children: [
                  DelayedAnimation(delay: 1500,
                      child: FormBuilderTextField(
                        controller: _mail,
                        name: 'email',
                        style: TextStyle(
                            color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Votre E-mail",
                          labelStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: "Ce champ doit être rempli"),
                              FormBuilderValidators.email(
                                  errorText: "Adresse mail invalide")
                            ]),
                      )
                  ),
                  SizedBox(height: 100,),
                  DelayedAnimation(delay: 5000,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            primary: Colors.white24,
                            padding: EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 13,
                            )
                        ),
                        onPressed: () async {
                          if(_formKey2.currentState!.saveAndValidate()){

                            setState(() {
                              isLoadingForgotPass = true;
                            });

                            //Mettre la méthode qui traite les éléments ici
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: _mail.text.toString());

                            // Afficher le CircularProgressIndicator pendant un certain temps
                            await Future.delayed(Duration(
                                seconds:
                                4));
                            // Remplacez 2 par la durée souhaitée en secondes

                            setState(() {
                              isLoadingForgotPass = false;
                            });

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[850],
                                  title: Text("Réinitialiser votre mot de passe ",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  content: Text(
                                      "Si votre email est enregistré chez ilovepizza, "
                                          "un mail avec un lien de réinitialisation vous sera envoyé."
                                          "Cliquez sur le lien de réinitialisation, entrez votre nouveau mot de passe et réessayer de vous connecter.",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white)),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text("OK",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white)),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(),),);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          backgroundColor: Colors.grey[700],
                                          elevation: 20),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: isLoadingForgotPass == true ? CircularProgressIndicator() :
                        Text("Réinitialiser mot de passe ",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500
                          ),),
                      )
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
