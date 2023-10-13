import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/social_page.dart';
import 'package:flutter_app2/main.dart';
import 'package:provider/provider.dart';
import 'delayed_animation.dart';
import 'package:flutter_app2/Pages/welcome_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auth_code_textfield/auth_code_textfield.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:flutter_app2/bdd.dart';
import 'inscription_page.dart';
import 'package:flutter_app2/main.dart';
import 'package:flutter/widgets.dart';


class VerifInfoPage extends StatefulWidget {
  //constructeur de la variable de type TextEditingController récupérer dans la page précédente
  final String email;
  final String prenom;
  final String nom;
  final String numero;
  final String addr;
  final String mdpFinal;
  VerifInfoPage({@required this.email = "", @required this.prenom = "",@required this.nom = "",@required this.numero = "",@required this.addr = "",@required this.mdpFinal = "" }) : super();

  @override
  State<VerifInfoPage> createState() => _VerifInfoPageState();
}


class _VerifInfoPageState extends State<VerifInfoPage> {
  TextEditingController _code = TextEditingController();
  bool isLoadingCode = false;


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


    Future<String?> getCodeProv(String email) async {
      try {
        // CollectionReference fait référence à la collection "Verif"
        CollectionReference verifCollection = FirebaseFirestore.instance.collection('Verif');

        // Utilisez la méthode where pour ajouter une condition à la requête
        QuerySnapshot querySnapshot = await verifCollection.where('emailProv', isEqualTo: email).get();

        // Si le document correspondant à la condition existe
        if (querySnapshot.docs.isNotEmpty) {
          // Récupérez la valeur du champ "codeProv" du premier document
          String codeProv = querySnapshot.docs.first.get('codeProv');
          return codeProv;
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

    Future<void> ajouterDocument(String adress, String email,String nom,String prenom, String tel, String collectionName) async {
      try {
        await FirebaseFirestore.instance.collection(collectionName).add({
          'adresse': adress,
          'estBanni': false,
          'mail': email,
          'nbcommande': 0,
          'nom': nom,
          'prenom': prenom,
          'tel': tel,
          'boss': false,

        });

        print('Document ajouté avec succès!');
      } catch (e) {
        print('Erreur lors de l\'ajout du document : $e');
      }
    }

    Future<void> deleteDocument(String emailProv, String codeProv, String collectionName) async {
      try {
        // CollectionReference fait référence à la collection spécifiée
        CollectionReference collectionReference = FirebaseFirestore.instance.collection(collectionName);

        // Utilisez la méthode where pour ajouter une condition à la requête
        QuerySnapshot querySnapshot = await collectionReference
            .where('emailProv', isEqualTo: emailProv)
            .where('codeProv', isEqualTo: codeProv)
            .get();

        // Parcourez les documents résultants et supprimez-les
        querySnapshot.docs.forEach((document) async {
          await collectionReference.doc(document.id).delete();
        });

        print('Document supprimé avec succès!');
      } catch (e) {
        // Gérez les erreurs éventuelles
        print('Erreur lors de la suppression du document : $e');
      }
    }

    
    return Consumer<Mysql>(
      builder: (context, mysql, child){
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 40,
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
        body: ListView(
          children: [
            Container(
            margin: EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DelayedAnimation(delay: 1500, child: Text("Vérifiez votre adresse mail",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  ),
                ),
                ),
                SizedBox(height: 30,),
                DelayedAnimation(delay: 1500, child: Text("Veuillez renseigner le code envoyé à votre adresse mail.",
                  style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                ),
                SizedBox(height: 80,),
            Center(
              child: DelayedAnimation(delay: 2500,
                child: AuthCodeTextfield(
                  controller: _code,
                  autofocus: false,
                  textColor: Colors.white,
                  mode: AuthCodeMode.bottomLine,
                  itemWidth: 50,
                  itemHeight: 60,
                  itemSpacing: 20,
                  itemBottomLineColor: Color.fromRGBO(229, 231, 233, 1),
                  cursorWidth: 1,
                  cursorHeight: 30,
                ),
              ),
            ),
            SizedBox(height: 60,),
            Center(
              child: DelayedAnimation(delay: 1500, child: Text(widget.email.toString(),
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600
                ),
              ),
              ),
            ),
            SizedBox(height: 40,),
            Center(
              child: DelayedAnimation(delay: 4000,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    primary: Colors.white24,
                    padding: EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 13,
                    ),
                  ) ,
                  onPressed: (){
                    setState(() async {
                      if(_code.text != null){
                        setState(() {
                          isLoadingCode = true;
                        });

                        // Afficher le CircularProgressIndicator pendant un certain temps
                        await Future.delayed(Duration(
                            seconds:
                            4)); // Remplacez 2 par la durée souhaitée en secondes

                        String? codeProv = await getCodeProv(widget.email.toString());


                        if(_code.text == codeProv ){
                          await updateFcmToken();
                        print("done!");
                        //ajout des information de l'utilisateur dans la bdd
                       ajouterDocument(widget.addr.toString(), widget.email.toString(), widget.nom.toString(), widget.prenom.toString(), widget.numero.toString(), "Users");
                        //supprime les element de la table verif
                       deleteDocument(widget.email.toString(), codeProv.toString(), "Verif");
                        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: widget.email.toString(),
                          password: widget.mdpFinal.toString(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                                height: 11,
                                child: Text("Inscription en cours...",
                                  style: TextStyle(
                                      fontSize: 11
                                  ),)
                            ),
                          ),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyApp()));
                        setState(() {
                          isLoadingCode = false;
                        });
                      }else{
                          setState(() {
                            isLoadingCode = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                                height: 11,
                                child: Text("Le code saisi est incorrect veuillez réessayer.",
                                  style: TextStyle(
                                      fontSize: 11
                                  ),)
                            ),
                          ),
                        );
                      }
                    }
                    });
                  } ,
                  child: isLoadingCode == true ? CircularProgressIndicator() :
                  Text("S'INSCRIRE",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                ),
            ),

              ],
            ),
          ),
        ]
        ),

      );
  }
    );
  }
}

