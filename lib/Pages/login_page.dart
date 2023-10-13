import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/test_page.dart';
import 'package:flutter_app2/bdd.dart';
import 'package:flutter_app2/main.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'delayed_animation.dart';
import 'package:flutter_app2/Pages/welcome_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatelessWidget {
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
            Navigator.pop(context);
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
                  DelayedAnimation(
                    delay: 1500,
                    child: Text(
                      "Connectez-vous via votre adresse mail",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  DelayedAnimation(
                    delay: 1500,
                    child: Text(
                      "Il est recommandé de vous connecter avec adresse e-mail pour mieux protéger vos informations.",
                      style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 80,
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
  var _obsucurText = true;
  TextEditingController _mail = TextEditingController();
  TextEditingController _mdp = TextEditingController();
  bool isLoadingLogin = false;

  @override
  Widget build(BuildContext context) {

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    Future<void> updateFcmToken() async {

      String userId = "";

      final database = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;

      // Récupérer l'utilisateur actuellement connecté
      User? user = auth.currentUser;

      if (user != null) {
        // L'ID de l'utilisateur actuellement connecté
        userId = user.uid;
        print('Current User ID: $userId');
      } else {
        // L'utilisateur n'est pas connecté
        print('No user is currently signed in.');
      }

      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");

      await database.collection('UserToken').doc(userId).set({
        'iduser': userId,
        'token': token,
      }, SetOptions(merge: true));
    }


    final modele = Provider.of<Mysql>(context, listen: false);
    //méthode qui permet d'enregistrer les log du compte sur le tel, de l'utilisateur

    Future<bool?> getBoss(String email) async {
      try {
        // CollectionReference fait référence à la collection "Verif"
        CollectionReference verifCollection =
            FirebaseFirestore.instance.collection('Users');

        // Utilisez la méthode where pour ajouter une condition à la requête
        QuerySnapshot querySnapshot =
            await verifCollection.where('mail', isEqualTo: email).get();

        // Si le document correspondant à la condition existe
        if (querySnapshot.docs.isNotEmpty) {
          // Récupérez la valeur du champ "codeProv" du premier document
          bool estBoss = querySnapshot.docs.first.get('boss');
          return estBoss;
        } else {
          // Aucun document ne correspond à la condition
          return null;
        }
      } catch (e) {
        // Gérez les erreurs éventuelles
        print("Erreur lors de la récupération du codeProv : $e");
        return null;
      }
    }

    return Consumer<Mysql>(builder: (context, mysql, child) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: FormBuilder(
          key: _formKey2,
          child: Column(
            children: [
              DelayedAnimation(
                  delay: 3500,
                  child: FormBuilderTextField(
                    controller: _mail,
                    name: 'email',
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Votre E-mail",
                      labelStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Ce champ doit être rempli"),
                      FormBuilderValidators.email(
                          errorText: "Adresse mail invalide")
                    ]),
                  )),
              SizedBox(
                height: 30,
              ),
              DelayedAnimation(
                  delay: 4500,
                  child: FormBuilderTextField(
                      name: 'mdpC',
                      controller: _mdp,
                      style: TextStyle(color: Colors.white),
                      //obscurText permet de masquer le texte d'un champ. la valeur attribué est
                      // une variable qui a comme valeur un boolean
                      obscureText: _obsucurText,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Colors.white24,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                        labelText: "Mot De Passe",
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: Colors.white24,
                          ),
                          onPressed: () {
                            // seState permet d'actualiser le champ au moment du clic sur l'icone concerné
                            setState(() {
                              _obsucurText = !_obsucurText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ce champ doit être rempli";
                        }
                        return null;
                      })),
              SizedBox(
                height: 100,
              ),
              DelayedAnimation(
                delay: 4500,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MdpForget()));
                    },
                    child: Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    )),
              ),
              DelayedAnimation(
                  delay: 5000,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.white24,
                        padding: EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 13,
                        )),
                    onPressed: () async {
                      if (_formKey2.currentState!.saveAndValidate()) {
                        setState(() {
                          isLoadingLogin = true;
                        });


                        await updateFcmToken();

                        // Afficher le CircularProgressIndicator pendant un certain temps
                        await Future.delayed(Duration(
                            seconds:
                                5)); // Remplacez 2 par la durée souhaitée en secondes
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _mail.text.toString(),
                            password: _mdp.text.toString(),
                          );

                          getBoss(_mail.text.toString());
                          mysql.saveCredential(
                              _mail.text.toString(),
                              _mdp.text.toString(),
                              mysql.idDevResult.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                  height: 11,
                                  child: Text(
                                    "Connexion en cours...",
                                    style: TextStyle(fontSize: 11),
                                  )),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyApp(),
                                fullscreenDialog: true),
                          );
                          bool? estBoss =
                              await getBoss(_mail.text.toString());
                          print(estBoss);
                          if (estBoss == true) {
                            await updateFcmToken();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                    height: 11,
                                    child: Text(
                                      "Connexion en cours...",
                                      style: TextStyle(fontSize: 11),
                                    )),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestPage(),
                                  fullscreenDialog: true),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          print('FirebaseAuthException: ${e.code}');
                          if (e.code == 'user-not-found') {
                            print('Wrong password provided for that user.');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                    height: 11,
                                    child: Text(
                                      "Identifiants incorrects.",
                                      style: TextStyle(fontSize: 11),
                                    )),
                              ),
                            );
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                    height: 11,
                                    child: Text(
                                      "Identifiants incorrects.",
                                      style: TextStyle(fontSize: 11),
                                    )),
                              ),
                            );
                          }else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                            print('Wrong password provided for that user.');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                    height: 11,
                                    child: Text(
                                      "Identifiants incorrects.",
                                      style: TextStyle(fontSize: 11),
                                    )),
                              ),
                            );
                          }
                        }
                        setState(() {
                          isLoadingLogin = false;
                        });
                      }
                    },
                    child: isLoadingLogin == true
                        ? CircularProgressIndicator()
                        : Text(
                            "SE CONNECTER",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                  )),
            ],
          ),
        ),
      );
    });
  }
}
