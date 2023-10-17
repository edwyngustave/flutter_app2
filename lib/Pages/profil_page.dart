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
  List<Map<String, dynamic>> commandesDataListClient = [];
  String userId = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool emailDejaPris = false ;



  Future<void> fetchDataClient() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    if (user != null) {
      // L'ID de l'utilisateur actuellement connecté
      userId = user.uid;
      print('Current User ID: $userId');
    } else {
      // L'utilisateur n'est pas connecté
      print('No user is currently signed in.');
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Commandes')
          .where('iduserCom', isEqualTo: userId)
          .where('estFinie', isEqualTo: true)
          //.orderBy('createdAt')
          .get();

      List<Map<String, dynamic>> dataList = [];

      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> commandeData =
        document.data() as Map<String, dynamic>;

        commandeData['documentId'] = document.id;

        dataList.add(commandeData);
      });

      setState(() {
        commandesDataListClient = dataList;
      });
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }

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
        return Column(
          children: [
            for (var commandeDataClient in commandesDataListClient)
              GestureDetector(
                onTap: () {
                  setState(() {
                    print(mysql.wrap);
                  });
                },
                child: Padding(
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
                              "Pizza: ${commandeDataClient['pizza']?.isNotEmpty == true ? commandeDataClient['pizza'] : 'Non spécifié'}",
                              style:
                              TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Wrap: ${commandeDataClient['wrap']?.isNotEmpty == true ? commandeDataClient['wrap'] : 'Non spécifié'}",
                              style:
                              TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Boissons: ${commandeDataClient['boissons']?.isNotEmpty == true ? commandeDataClient['boissons'] : 'Non spécifié'}",
                              style:
                              TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Horaire souhaité : ${commandeDataClient['horraireCommande']?.isNotEmpty == true ? commandeDataClient['horraireCommande'] : 'Non spécifié'}",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Prix Commande : ${commandeDataClient['prixTotalCommande'] != null ? '${commandeDataClient['prixTotalCommande']}€' : 'Non spécifié'}",
                              style: TextStyle(
                                color: Colors.lightGreenAccent,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Date de la commande: ${commandeDataClient['dateCommande'] != null ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(commandeDataClient['dateCommande'])) : 'date inconnue'}",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );

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

                      await fetchDataClient();

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
                                      "Commandes terminées",
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
