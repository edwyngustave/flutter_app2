import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/delayed_animation.dart';
import 'package:flutter_app2/Pages/welcome_page.dart';
import 'package:flutter_app2/bdd.dart';
import 'package:flutter_app2/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:process_run/shell.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app2/panier_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pw;
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';





class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  int _selectedMenu = 0;
  String finalDate = "";
  bool isLoadingCommandeProfil = false ;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool emailDejaPris = false ;

  Future<void> checkIfEmailExists(String email) async {
    try {
      List<String> signInMethods =
      await _auth.fetchSignInMethodsForEmail(email);

      if (signInMethods.isEmpty) {
        // L'adresse e-mail n'est pas associée à un compte existant
        print('L\'adresse e-mail n\'est pas déjà utilisée.');
        // Vous pouvez alors créer un nouvel utilisateur avec cette adresse e-mail.
      } else {
        // L'adresse e-mail est déjà associée à un compte existant
        print('L\'adresse e-mail est déjà utilisée.');
        emailDejaPris = true;
        // Vous pouvez prendre des mesures en conséquence, par exemple, afficher un message d'erreur à l'utilisateur.
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la vérification de l\'e-mail : $e');
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Remplacez par un ID unique pour votre canal
      'Channel Name', // Nom du canal de notification
      'Channel Description', // Description du canal de notification
      importance: Importance.max,
      priority: Priority.high,
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification (doit être unique)
      'Titre de la notification',
      'Contenu de la notification',
      platformChannelSpecifics,
      payload: 'Custom_Sound', // Données personnalisées à envoyer lorsqu'on clique sur la notification
    );
  }



  @override
  Widget build(BuildContext context) {
    Widget listCommande = Consumer<Mysql>(
      builder: (context, mysql, child) {
        List<Widget> commandes = [];
        for (var i = 0; i < mysql.id6.length; i++)
          commandes.add(
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: double.infinity,
                  child: Card(
                    color: Colors.grey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          if (mysql.pizza6[i].isNotEmpty && (!mysql.pizza6[i].contains("null") || mysql.pizza6[i] != null))
                            Text("Pizza : " + mysql.pizza6[i] + '€', style: TextStyle(color: Colors.white)),
                          if (mysql.wrap6[i].isNotEmpty && (!mysql.wrap6[i].contains("null") || mysql.wrap6[i] != null))
                            SizedBox(height: 10,),
                          if (mysql.wrap6[i].isNotEmpty && (!mysql.wrap6[i].contains("null") || mysql.wrap6[i] != null))
                            Text("Wrap : " + mysql.wrap6[i] + '€', style: TextStyle(color: Colors.white)),
                          if (mysql.boisson6[i].isNotEmpty && (!mysql.boisson6[i].contains("null") || mysql.boisson6[i] != null))
                            SizedBox(height: 10,),
                          if (mysql.boisson6[i].isNotEmpty && (!mysql.boisson6[i].contains("null") || mysql.boisson6[i] != null))
                            Text("Boissons : " + mysql.boisson6[i] + '€', style: TextStyle(color: Colors.white)),
                          if (mysql.dessert6[i] != null && mysql.dessert6[i].isNotEmpty && (!mysql.dessert6[i].contains("null")))
                            SizedBox(height: 10,),
                          if (mysql.dessert6[i] != null && mysql.dessert6[i].isNotEmpty && (!mysql.dessert6[i].contains("null")))
                            Text("Desserts : " + mysql.dessert6[i] + '€', style: TextStyle(color: Colors.white)),
                          if (mysql.commentaire6[i] != null && mysql.commentaire6[i].isNotEmpty && (!mysql.commentaire6[i].contains("null")))
                            SizedBox(height: 10,),
                          if (mysql.commentaire6[i] != null && mysql.commentaire6[i].isNotEmpty && (!mysql.commentaire6[i].contains("null")))
                            Text("Commentaire : " + mysql.commentaire6[i], style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800)),
                          SizedBox(height: 10,),
                          Text(mysql.prixCommande6[i] + "€", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.blue, fontSize: 16)),
                          SizedBox(height: 10,),
                          Text(finalDate,
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
              ),
            ),
          );
        return Column(children: commandes);
      },
    );

    //////////////////////////////////////////////////////////////////////////

    Widget listFidelite = Consumer<Mysql>(
      builder: (context, mysql, child) {
        return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    color: Colors.grey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "Les points de fidélité sont attribués en fonction des commandes que vous avez effectuées. \n \n Lorsque vus avez cumulé 110 points, ceci équivaut à 10€ de réduction sur votre commande(offre non cummulable).\n \n Il est ensuite possible de les utiliser pour bénéficier d'une promotion sur une commande choisie.\n \n C'est au moment de commander que pouvez utiliser vos points.  ",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:Colors.white),
                          ),
                          SizedBox(height: 10,),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Actuellement vous avez : ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: '${mysql.points} points',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.lightGreenAccent, // changer la couleur à vert
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );

    ////////////////////////////////////////////////////////////////////

    Widget listMessage = Consumer<Mysql>(
      builder: (context, mysql, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child:
          Container(
            width: double.infinity,
            child: Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Message de nos services concernant votre commande.",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:Colors.white),
                    ),
                    SizedBox(height: 10,),

                    if (mysql.commentaireAdmin4 != null && mysql.commentaireAdmin4.isNotEmpty && (!mysql.commentaireAdmin4.contains("null")))
                    Text(
                      '${mysql.commentaireAdmin4.toString()}',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:Colors.blue),
                    ),
                    SizedBox(height: 10,),
                    if (mysql.commentaireAdmin4 != null && mysql.commentaireAdmin4.isNotEmpty && (!mysql.commentaireAdmin4.contains("null")))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                          mysql.estRepondu() ;
                          },
                          child: Text("OK"),
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.grey[850]),
                        ),
                        SizedBox(width: 6,),
                        ElevatedButton(
                          onPressed: () {
                            mysql.estRefusDef();
                          },
                          child: Text("Recommander"),
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.grey[850]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    ///////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<Mysql>(builder: (context, mysql, child) {
          return ListView(
            children: [
              Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedMenu = 1;
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.all(8),
                      color: Colors.grey[900],
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.settings_accessibility,
                            color: Colors.white,
                          ),
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        "Informations personnelles",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: _selectedMenu == 1 ? FontWeight.w600 :FontWeight.w400,
                                            color: _selectedMenu == 1 ? Colors.blue : Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        mysql.getCommentaireAdminAClient();
                        _selectedMenu = 2;
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.all(8),
                      color: Colors.grey[900],
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          "Messages",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: _selectedMenu == 2 ? FontWeight.w600 :FontWeight.w400,
                                              color: _selectedMenu == 2 ? Colors.blue : Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 6,),
                                      if (mysql.commentaireAdmin4 != null && mysql.commentaireAdmin4.isNotEmpty && (!mysql.commentaireAdmin4.contains("null")))
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red),
                                          child: Center(
                                            child: Text(
                                              "1",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),),
                        ],
                      ),
                    ),
                  ),
                  /*GestureDetector(
                    onTap: (){
                      setState(() {
                        mysql.getCommentaireAdminAClient();
                        mysql.getFidelite();
                        _selectedMenu = 3;
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.all(8),
                      color: Colors.grey[900],
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.score,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "Fidélité",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: _selectedMenu == 3 ? FontWeight.w600 :FontWeight.w400,
                                          color: _selectedMenu == 3 ? Colors.blue : Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),),
                        ],
                      ),
                    ),
                  ),*/
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoadingCommandeProfil = true;
                      });

                      mysql.getCommentaireAdminAClient();
                      mysql.getCommandeClient2();
                      for(int i = 0; i<mysql.dateCommande6.length;i++){
                        if(mysql.dateCommande6[i].contains("000Z")){
                          mysql.dateCommande6[i] = mysql.dateCommande6[i].replaceAll('.000Z', '');
                          String finalDate = mysql.dateCommande6[i] ;
                          this.finalDate = finalDate;
                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                          print('La date actuelle est : $formattedDate');
                        }}

                      await Future.delayed(Duration(
                          seconds:
                          4));

                      setState(() {
                        isLoadingCommandeProfil = false;
                      });
                      setState(() {
                        _selectedMenu = 4;
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.all(8),
                      color: Colors.grey[900],
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isLoadingCommandeProfil == true ? CircularProgressIndicator():
                          Icon(
                            Icons.shopping_cart_rounded,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "Commandes",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: _selectedMenu == 4 ? FontWeight.w600 :FontWeight.w400,
                                          color: _selectedMenu == 4 ? Colors.blue : Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                              child: _selectedMenu == 1
                                  ? Container()
                                  : _selectedMenu == 2
                                  ?  listMessage
                                  : _selectedMenu == 3
                                  ? listFidelite
                                  : _selectedMenu == 4
                                  ? listCommande
                                  : null))),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async {
                      mysql.deleteCredential();
                      runApp(SplashScreen());
                    },
                    child: Text("DECONNEXION"),
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Colors.grey[900]),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      checkIfEmailExists('edwyn@hotmail.com');
                    },
                    child: Text('Afficher la notification'),
                  )
                ],
              ),
            ),
          ]
          );
        }),
      ),
    );
  }
}
