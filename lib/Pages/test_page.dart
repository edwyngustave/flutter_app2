import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/home_page.dart';
import 'package:flutter_app2/Pages/welcome_page.dart';
import 'package:flutter_app2/bdd.dart';
import 'package:flutter_app2/main.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../notification_service.dart';
import 'delayed_animation.dart';
import 'package:intl/intl.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _selectedPage = 0;
  int _selectedStep = 0;
  bool setHorraire = false;
  List<String> horaires = [];
  List<String> UsersFire = [];
  List<String> UsersBanni = [];
  List<String> indisponibleCreneau = [];

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
      payload:
          'Default_Sound', // Données personnalisées à envoyer lorsqu'on clique sur la notification
    );
  }

  Future<void> updateAllCreneauToFalse() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot creneauDocs =
          await firestore.collection('CreneauH').get();

      for (final doc in creneauDocs.docs) {
        // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
        await doc.reference.update({
          'vide': false,
        });
      }

      print('Mise à jour réussie pour tous les éléments');
    } catch (error) {
      print('Erreur lors de la mise à jour : $error');
    }
  }

  Future<void> updateCreneauToFalse(String creneauName) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot creneauDocs = await firestore
          .collection('CreneauH')
          .where('hours', isEqualTo: creneauName)
          .get();

      if (creneauDocs.docs.isNotEmpty) {
        // Si un document correspond au nom du créneau
        final DocumentReference creneauDocRef = creneauDocs.docs[0].reference;

        // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
        await creneauDocRef.update({
          'vide': false,
        });

        print('Mise à jour réussie');
      } else {
        print('Document introuvable pour le créneau : $creneauName');
      }
    } catch (error) {
      print('Erreur lors de la mise à jour : $error');
    }
  }

  Future<void> updateCreneauToTrue(String creneauNameT) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot creneauDocs = await firestore
          .collection('CreneauH')
          .where('hours', isEqualTo: creneauNameT)
          .get();

      if (creneauDocs.docs.isNotEmpty) {
        // Si un document correspond au nom du créneau
        final DocumentReference creneauDocRefT = creneauDocs.docs[0].reference;

        // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
        await creneauDocRefT.update({
          'vide': true,
        });

        print('Mise à jour réussie');
      } else {
        print('Document introuvable pour le créneau : $creneauNameT');
      }
    } catch (error) {
      print('Erreur lors de la mise à jour : $error');
    }
  }

  Future<void> updateUserBanniToTrue(String userName) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot creneauDocs = await firestore
          .collection('Users')
          .where('mail', isEqualTo: userName)
          .get();

      if (creneauDocs.docs.isNotEmpty) {
        // Si un document correspond au nom du créneau
        final DocumentReference UsersTDocRef = creneauDocs.docs[0].reference;

        // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
        await UsersTDocRef.update({
          'estBanni': true,
        });

        print('Mise à jour réussie');
      } else {
        print('Document introuvable pour le créneau : $userName');
      }
    } catch (error) {
      print('Erreur lors de la mise à jour : $error');
    }
  }

  Future<void> updateUserBanniToFalse(String userNameF) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot UsersFDocs = await firestore
          .collection('Users')
          .where('mail', isEqualTo: userNameF)
          .get();

      if (UsersFDocs.docs.isNotEmpty) {
        // Si un document correspond au nom du créneau
        final DocumentReference creneauDocRef = UsersFDocs.docs[0].reference;

        // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
        await creneauDocRef.update({
          'estBanni': false,
        });

        print('Mise à jour réussie');
      } else {
        print('Document introuvable pour le créneau : $userNameF');
      }
    } catch (error) {
      print('Erreur lors de la mise à jour : $error');
    }
  }

  Future<List<String>> getUserBanni() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot UsersBanniDocs = await firestore
          .collection('Users')
          .where('estBanni', isEqualTo: true)
          .get();

      UsersBanni.clear();

      if (UsersBanniDocs.docs.isNotEmpty) {
        for (final us in UsersBanniDocs.docs) {
          final String mailBanni = us['mail'] as String;
          UsersBanni.add(mailBanni);
        }

        print(UsersBanni);
      } else {
        print('Liste Vide');
      }
    } catch (error) {
      print('Erreur lors de la mise à jour : $error');
    }
    return UsersBanni;
  }

  Future<List<String>> getUsersFromFirestore() async {
    try {
      final QuerySnapshot UsersFireSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      // Créez une liste pour stocker les horaires récupérés
      UsersFire = [];

      for (final doc in UsersFireSnapshot.docs) {
        final String UserFi = doc['mail'] as String;
        UsersFire.add(UserFi);
      }
      print(UsersFire);
      return UsersFire;
    } catch (error) {
      print('Erreur lors de la récupération des horaires : $error');
      return [];
    }
  }

  Future<List<String>> getHorairesFromFirestore() async {
    try {
      final QuerySnapshot CreneauSnapshot = await FirebaseFirestore.instance
          .collection('CreneauH')
          .orderBy('hours', descending: false)
          .get();

      // Créez une liste pour stocker les horaires récupérés
      horaires = [];

      for (final doc in CreneauSnapshot.docs) {
        final String horaire = doc['hours'] as String;
        horaires.add(horaire);
      }
      print(horaires);
      return horaires;
    } catch (error) {
      print('Erreur lors de la récupération des horaires : $error');
      return [];
    }
  }

  Future<void> checkTrueAddresses() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Address')
        .where('est', isEqualTo: true)
        .get();

    querySnapshot.docs.forEach((document) {
      bool est = document['est'] as bool;
      if (est) {
        print('Adresse ${document.id} a la valeur "est" à true.');
      }
    });
  }

  Future<void> updateAddressToTrue(String addressId) async {
    // Référence à l'adresse que vous souhaitez mettre à true.
    final addressRef =
        FirebaseFirestore.instance.collection('Address').doc(addressId);

    // Mettre à jour le champ "est" à true.
    await addressRef.update({'est': true});
  }

  Future<void> updateIngredyToTrue(String ingredyId) async {
    // Référence à l'adresse que vous souhaitez mettre à true.
    final ingredyRef =
        FirebaseFirestore.instance.collection('Ingredients').doc(ingredyId);

    // Mettre à jour le champ "est" à true.
    await ingredyRef.update({'empty': true});
  }

  Future<void> updateAllIngredysToFalse() async {
    // Récupérer une référence à la collection "Address"
    CollectionReference ingredysRef =
        FirebaseFirestore.instance.collection('Ingredients');

    // Récupérer tous les documents de la collection
    QuerySnapshot querySnapshot = await ingredysRef.get();

    // Parcourir les documents et mettre à jour le champ "est" à false pour chacun d'eux
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      await ingredysRef.doc(document.id).update({'empty': false});
    }
  }

  Future<void> updateAllAddressesToFalse() async {
    // Récupérer une référence à la collection "Address"
    CollectionReference addressesRef =
        FirebaseFirestore.instance.collection('Address');

    // Récupérer tous les documents de la collection
    QuerySnapshot querySnapshot = await addressesRef.get();

    // Parcourir les documents et mettre à jour le champ "est" à false pour chacun d'eux
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      await addressesRef.doc(document.id).update({'est': false});
    }
  }

  Future<List<String>> fetchIndisponibleCreneau() async {
    // 1. Récupérez les créneaux avec "vide" à true
    final QuerySnapshot CreneauSnapshot = await FirebaseFirestore.instance
        .collection('CreneauH')
        .where('vide', isEqualTo: true)
        .get();

    // Créez une liste pour stocker les créneaux indisponibles
    indisponibleCreneau =
        CreneauSnapshot.docs.map((doc) => doc['hours'] as String).toList();

    print(indisponibleCreneau);

    // Renvoyez la liste des créneaux indisponibles
    return indisponibleCreneau;
  }

  TextEditingController _com = TextEditingController();

  List<String> horairesSoir = [
    '18h30',
    '18h35',
    '18h40',
    '18h45',
    '18h50',
    '18h55',
    '19h00',
    '19h05',
    '19h10',
    '19h15',
    '19h20',
    '19h25',
    '19h30',
    '19h35',
    '19h40',
    '19h45',
    '19h50',
    '19h55',
    '20h00',
    '20h05',
    '20h10',
    '20h15',
    '20h20' '20h25',
    '20h30',
    '20h35',
    '20h40',
    '20h45',
    '20h50',
    '20h55',
    '21h00',
    '21h05',
    '21h10',
    '21h15',
    '21h20',
    '21h25',
    '21h30',
  ];

  String horaireSelectionneSoir = "18h30";

  List<String> horairesMidi = [
    '12h00',
    '12h05',
    '12h10',
    '12h15',
    '12h20',
    '12h25',
    '12h30',
    '12h35',
    '12h40',
    '12h45',
    '12h50',
    '12h55',
    '13h00',
    '13h05',
    '13h10',
    '13h15',
    '13h20',
    '13h25',
    '13h30',
    '13h35',
    '13h40',
    '13h45',
  ];

  String horaireSelectionneMidi = "12h00";

  List<String> ajoutPoint = ['10', '20', '30', '40', '50'];

  String pointSelectionne = '10';

  bool isLoading = false;

  List<Map<String, dynamic>> commandesDataList = [];
  List<Map<String, dynamic>> commandesDataListEnCours = [];
  List<Map<String, dynamic>> commandesDataListEstFinie = [];
  List<Map<String, dynamic>> commandesDataListRefuser = [];

  var userDoc;
  String userDocFin = "" ;
  String? iduserCom = "";

  @override
  Widget build(BuildContext context) {


    void handleNewOrder(String employeeToken) {
      // Logique de traitement de la nouvelle commande

      // Envoyer la notification
      sendNotificationCommandeAccepter(employeeToken);
    }

    void handleNewOrderFinie(String employeeToken) {
      // Logique de traitement de la nouvelle commande

      // Envoyer la notification
      sendNotificationCommandeFinie(employeeToken);
    }


    Future<void> estReValider(String idCommande3) async {
      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final DocumentSnapshot commandeDoc = await firestore
            .collection('Commandes')
            .doc(idCommande3)
            .get();

        if (commandeDoc.exists) {
          // Si un document correspond au nom du créneau
          final DocumentReference commandeDocRef = commandeDoc.reference;

          // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
          await commandeDocRef.update({
            'refusDef': false,
            'enCours': true
          });

          print('Mise à jour réussie');
        } else {
          print('Document introuvable pour le créneau : $idCommande3');
        }
      } catch (error) {
        print('Erreur lors de la mise à jour : $error');
      }
    }

    Future<void> estFinie(String idCommande2) async {
      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final DocumentSnapshot commandeDoc = await firestore
            .collection('Commandes')
            .doc(idCommande2)
            .get();

        if (commandeDoc.exists) {
          // Si un document correspond au nom du créneau
          final DocumentReference commandeDocRef = commandeDoc.reference;

          // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
          await commandeDocRef.update({
            'estFinie': true,
            'enCours': false
          });

          print('Mise à jour réussie');
        } else {
          print('Document introuvable pour le créneau : $idCommande2');
        }
      } catch (error) {
        print('Erreur lors de la mise à jour : $error');
      }
    }

    Future<void> estValider(String idCommande1) async {
      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final DocumentSnapshot commandeDoc = await firestore
            .collection('Commandes')
            .doc(idCommande1)
            .get();

        if (commandeDoc.exists) {
          // Si un document correspond au nom du créneau
          final DocumentReference commandeDocRef = commandeDoc.reference;

          // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
          await commandeDocRef.update({
            'enAttente': false,
            'enCours': true
          });

          print('Mise à jour réussie');
        } else {
          print('Document introuvable pour le créneau : $idCommande1');
        }
      } catch (error) {
        print('Erreur lors de la mise à jour : $error');
      }
    }

    Future<void> estRefuser(String idCommande1) async {
      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final DocumentSnapshot commandeDoc = await firestore
            .collection('Commandes')
            .doc(idCommande1)
            .get();

        if (commandeDoc.exists) {
          // Si un document correspond au nom du créneau
          final DocumentReference commandeDocRef = commandeDoc.reference;

          // Utilisez la méthode update pour définir la valeur du champ "vide" sur false
          await commandeDocRef.update({
            'enAttente': false,
            'refusDef': true
          });

          print('Mise à jour réussie');
        } else {
          print('Document introuvable pour le créneau : $idCommande1');
        }
      } catch (error) {
        print('Erreur lors de la mise à jour : $error');
      }
    }

    Future<void> fetchDataRefuser() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Commandes')
            .where('refusDef', isEqualTo: true)
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
          commandesDataListRefuser = dataList;
        });
      } catch (e) {
        print("Erreur lors de la récupération des données : $e");
      }
    }

    Future<void> fetchDataFinie() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Commandes')
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
          commandesDataListEstFinie = dataList;
        });
      } catch (e) {
        print("Erreur lors de la récupération des données : $e");
      }
    }

    Future<void> fetchDataEnAttente() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Commandes')
            .where('enAttente', isEqualTo: true)
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
          commandesDataList = dataList;
        });
      } catch (e) {
        print("Erreur lors de la récupération des données : $e");
      }
    }

    Future<void> fetchDataEnCours() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Commandes')
            .where('enCours', isEqualTo: true)
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
          commandesDataListEnCours = dataList;
        });
      } catch (e) {
        print("Erreur lors de la récupération des données : $e");
      }
    }

    Future<String?> getIduserCom(String documentId) async {
      try {
        // Utilisez la méthode 'snapshots()' pour obtenir un Stream au lieu d'une seule requête
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Commandes').doc(documentId).get();

        // Vérifiez si le document existe
        if (documentSnapshot.exists) {
          // Utilisez le cast pour déterminer le type correct
          iduserCom = documentSnapshot.get('iduserCom') as String?;
          return iduserCom;
        } else {
          print('Le document avec l\'ID $documentId n\'existe pas.');
          return null;
        }
      } catch (e) {
        print('Erreur lors de la récupération des données : $e');
        return null;
      }
    }



    Future<String> getFcmTokenFromDatabase(String idUserComToken) async {
      final database = FirebaseFirestore.instance;
      userDoc = await database.collection('UserToken').doc(idUserComToken).get();
      userDocFin = userDoc['token'].toString();
      return userDoc['token'];
    }

    Widget menuComande = Consumer<Mysql>(builder: (context, mysql, child) {
      return ListView(children: [
        Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                        onPressed: () async {
                          fetchDataEnCours();
                          setState(() {
                            _selectedStep = 0;
                          });
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white70,
                          shape: StadiumBorder(),
                          backgroundColor: _selectedStep == 0
                              ? Colors.grey[850]
                              : Colors.black,
                        ),
                        child: Text(
                          "En cours",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: _selectedStep == 0
                                ? Colors.white
                                : Colors.white70,
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            fetchDataEnAttente();
                            _selectedStep = 1;
                          });
                        },
                        style: TextButton.styleFrom(
                            primary: Colors.white70,
                            backgroundColor: _selectedStep == 1
                                ? Colors.grey[850]
                                : Colors.black,
                            shape: StadiumBorder()),
                        child: Text(
                          "A Valider",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: _selectedStep == 1
                                ? Colors.white
                                : Colors.white70,
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () async {
                          await fetchDataFinie();
                          setState(() {
                            _selectedStep = 2;
                          });
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white70,
                          shape: StadiumBorder(),
                          backgroundColor: _selectedStep == 2
                              ? Colors.grey[850]
                              : Colors.black,
                        ),
                        child: Text(
                          "Terminées",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: _selectedStep == 2
                                ? Colors.white
                                : Colors.white70,
                          ),
                        )),
                    TextButton(
                        onPressed: () async {
                          await fetchDataRefuser();
                          setState(() {
                            _selectedStep = 3;
                          });
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white70,
                          shape: StadiumBorder(),
                          backgroundColor: _selectedStep == 3
                              ? Colors.grey[850]
                              : Colors.black,
                        ),
                        child: Text(
                          "Refusée",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: _selectedStep == 3
                                ? Colors.white
                                : Colors.white70,
                          ),
                        )),
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            if (_selectedStep == 2)
              Column(
                children: [
                  for (var commandeDataFinie in commandesDataListEstFinie)
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
                                    "Nom du client: ${commandeDataFinie['nomClient']?.isNotEmpty == true ? commandeDataFinie['nomClient'] : 'Client inconnu'}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blue),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Pizza: ${commandeDataFinie['pizza']?.isNotEmpty == true ? commandeDataFinie['pizza'] : 'Non spécifié'}",
                                    style:
                                    TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Wrap: ${commandeDataFinie['wrap']?.isNotEmpty == true ? commandeDataFinie['wrap'] : 'Non spécifié'}",
                                    style:
                                    TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Boissons: ${commandeDataFinie['boissons']?.isNotEmpty == true ? commandeDataFinie['boissons'] : 'Non spécifié'}",
                                    style:
                                    TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Horaire souhaité : ${commandeDataFinie['horraireCommande']?.isNotEmpty == true ? commandeDataFinie['horraireCommande'] : 'Non spécifié'}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w800),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Prix Commande : ${commandeDataFinie['prixTotalCommande'] != null ? '${commandeDataFinie['prixTotalCommande']}€' : 'Non spécifié'}",
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
                                    "Date de la commande: ${commandeDataFinie['dateCommande'] != null ? commandeDataFinie['dateCommande'] : 'date inconnue'}",
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
              ),
            if (setHorraire == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<Mysql>(builder: (context, mysql, child) {
                    return Center(
                      child: DropdownButton<String>(
                          dropdownColor: Colors.grey[700],
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 20,
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          underline: Container(
                            height: 2,
                            color: Colors.grey[700],
                          ),
                          onChanged: (String? newValue) {
                            if (mysql.horraireNoDispo.contains(newValue)) {
                              return; // sortir de la méthode onChanged sans mettre à jour l'état si la valeur sélectionnée n'est pas disponible
                            }
                            setState(() {
                              horaireSelectionneSoir = newValue ?? '';
                              horaireSelectionneMidi = newValue ?? '';
                            });
                            print(horaireSelectionneSoir);
                          },
                          value: mysql.locId == '4' || mysql.locId == '6'
                              ? horaireSelectionneSoir
                              : horaireSelectionneMidi,
                          items: mysql.locId == '4' || mysql.locId == '6'
                              ? horairesSoir.map<DropdownMenuItem<String>>(
                                  (String value) {
                                  bool isRed =
                                      mysql.horraireNoDispo.contains(value);
                                  return DropdownMenuItem<String>(
                                    key: Key(value),
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color:
                                              isRed ? Colors.red : Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList()
                              : horairesMidi.map<DropdownMenuItem<String>>(
                                  (String value1) {
                                  bool isRed =
                                      mysql.horraireNoDispo.contains(value1);
                                  return DropdownMenuItem<String>(
                                    key: Key(value1),
                                    value: value1,
                                    child: Text(
                                      value1,
                                      style: TextStyle(
                                          color:
                                              isRed ? Colors.red : Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList()),
                    );
                  }),
                  for (var i = 0; i < mysql.nomCli2.length; i++)
                    TextButton(
                      child: Text("OK",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600)),
                      onPressed: () async {
                        await mysql.getLocationId();
                        setState(() {
                          if (mysql.hCommande2[i].toString().isNotEmpty) {
                            mysql.horraireValider(mysql.id2[i].toString(),
                                mysql.hCommande2[i].toString());
                          }
                          mysql.estValider(mysql.id2[i].toString());
                          mysql.UpdateHoraire(
                              mysql.id2[i].toString(),
                              mysql.locId == '4' || mysql.locId == '6'
                                  ? horaireSelectionneSoir
                                  : horaireSelectionneMidi);
                          print(mysql.horraireNoDispo);
                          setHorraire = !setHorraire;
                        });
                      },
                    ),
                  TextButton(
                    child: Text("Annuler",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    onPressed: () async {
                      await mysql.getLocationId();
                      setState(() {
                        print(horaireSelectionneMidi);
                        setHorraire = !setHorraire;
                      });
                    },
                  ),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            if (_selectedStep == 1)
              Column(
                children: [
                  for (var commandeData in commandesDataList)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              print(DateTime.now());
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[850],
                                    title: Text("Fais-ton choix !",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    content: Text("Valider/Refuser",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white)),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text("Changer l'horaire",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                        onPressed: () {
                                          setState(() {
                                            //mysql.getHorraireNotDispo();
                                            print(mysql.horraireNoDispo);
                                            setHorraire = !setHorraire;
                                            Navigator.pop(context);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(),
                                            backgroundColor: Colors.grey[700],
                                            elevation: 20),
                                      ),
                                      ElevatedButton(
                                        child: Text("Refuser",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                        onPressed: () async {
                                          await estRefuser(commandeData['documentId']);
                                          setState(() {
                                            /* mysql.estRefuser(
                                                mysql.id2[i].toString()); */
                                            print(commandeData);
                                            Navigator.pop(context);
                                            _selectedStep = 4;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(),
                                            backgroundColor: Colors.grey[700],
                                            elevation: 20),
                                      ),
                                      ElevatedButton(
                                        child: Text("Valider",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                        onPressed: () async {
                                          await estValider(commandeData['documentId']);
                                          await getIduserCom(commandeData['documentId']);
                                          await getFcmTokenFromDatabase(iduserCom.toString());
                                          handleNewOrder(userDocFin);
                                          print(userDocFin);
                                          setState(() {
                                            /*  if (mysql.hCommande2[i]
                                                .toString()
                                                .isNotEmpty) {
                                              mysql.horraireValider(
                                                  mysql.id2[i].toString(),
                                                  mysql.hCommande2[i]
                                                      .toString());
                                            }
                                            mysql.estValider(
                                                mysql.id2[i].toString()); */
                                            Navigator.pop(context);
                                          });
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
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Container(
                                  width: double.infinity,
                                  child: Card(
                                    color: Colors.grey[900],
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          // Afficher les données de la commande ici
                                          Text(
                                            "Nom du client: ${commandeData['nomClient']?.isNotEmpty == true ? commandeData['nomClient'] : 'Client inconnu'}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Pizza: ${commandeData['pizza']?.isNotEmpty == true ? commandeData['pizza'] : 'Non spécifié'}",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Wrap: ${commandeData['wrap']?.isNotEmpty == true ? commandeData['wrap'] : 'Non spécifié'}",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Boissons: ${commandeData['boissons']?.isNotEmpty == true ? commandeData['boissons'] : 'Non spécifié'}",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Horaire souhaité : ${commandeData['horraireCommande']?.isNotEmpty == true ? commandeData['horraireCommande'] : 'Non spécifié'}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w800),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Prix Commande : ${commandeData['prixTotalCommande'] != null ? '${commandeData['prixTotalCommande']}€' : 'Non spécifié'}",
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
                                            "Date de la commande: ${commandeData['dateCommande'] != null ? commandeData['dateCommande'] : 'date inconnue'}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.blue,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),

                                          // ... Ajouter d'autres champs selon vos besoins
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            if (_selectedStep == 0)
              Column(
                children: [
                  for (var commandeDataEnCours in commandesDataListEnCours)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[850],
                                    title: Text("Fais-ton choix !",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    content: Text("Fini ?",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white)),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text("Non",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(),
                                            backgroundColor: Colors.grey[700],
                                            elevation: 20),
                                      ),
                                      ElevatedButton(
                                        child: Text("Commande Finie",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                        onPressed: () async {
                                          await estFinie(commandeDataEnCours['documentId']);
                                          await getIduserCom(commandeDataEnCours['documentId']);
                                          await getFcmTokenFromDatabase(iduserCom.toString());
                                          handleNewOrderFinie(userDocFin);
                                          print(userDocFin);
                                          setState(() {
                                            Navigator.pop(context);
                                          });
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
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Container(
                                  width: double.infinity,
                                  child: Card(
                                    color: Colors.grey[900],
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Nom du client: ${commandeDataEnCours['nomClient']?.isNotEmpty == true ? commandeDataEnCours['nomClient'] : 'Client inconnu'}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Pizza: ${commandeDataEnCours['pizza']?.isNotEmpty == true ? commandeDataEnCours['pizza'] : 'Non spécifié'}",
                                            style:
                                            TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Wrap: ${commandeDataEnCours['wrap']?.isNotEmpty == true ? commandeDataEnCours['wrap'] : 'Non spécifié'}",
                                            style:
                                            TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Boissons: ${commandeDataEnCours['boissons']?.isNotEmpty == true ? commandeDataEnCours['boissons'] : 'Non spécifié'}",
                                            style:
                                            TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Horaire souhaité : ${commandeDataEnCours['horraireCommande']?.isNotEmpty == true ? commandeDataEnCours['horraireCommande'] : 'Non spécifié'}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w800),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Prix Commande : ${commandeDataEnCours['prixTotalCommande'] != null ? '${commandeDataEnCours['prixTotalCommande']}€' : 'Non spécifié'}",
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
                                            "Date de la commande: ${commandeDataEnCours['dateCommande'] != null ? commandeDataEnCours['dateCommande'] : 'date inconnue'}",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            if (_selectedStep == 3)
              Column(
                children: [
                  for (var commandeDataRefuser in commandesDataListRefuser)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[850],
                                    title: Text("Fais-ton choix !",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    content: Text(
                                        "Re-Basculer dans le menu En Cours ? / Laisser un motif pour le client",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white)),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text("Re-basculer",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                        onPressed: () async {
                                          await estReValider(commandeDataRefuser['documentId']);
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(),
                                            backgroundColor: Colors.grey[700],
                                            elevation: 20),
                                      ),
                                      ElevatedButton(
                                        child: Text("Donner un motif",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Colors.grey[850],
                                                  title: Text("Dis nous tout",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                  content: Text(
                                                      "Donner un motif",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: Colors
                                                                  .white)),
                                                  actions: <Widget>[
                                                    FormBuilderTextField(
                                                      name: "com",
                                                      controller: _com,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    ElevatedButton(
                                                      child: Text("OK",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white)),
                                                      onPressed: () {
                                                        setState(() {

                                                          Navigator.pop(
                                                              context);
                                                          _com.clear();
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              shape:
                                                                  StadiumBorder(),
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      700],
                                                              elevation: 20),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
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
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Container(
                                  width: double.infinity,
                                  child: Card(
                                    color: Colors.grey[900],
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Nom du client: ${commandeDataRefuser['nomClient']?.isNotEmpty == true ? commandeDataRefuser['nomClient'] : 'Client inconnu'}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Pizza: ${commandeDataRefuser['pizza']?.isNotEmpty == true ? commandeDataRefuser['pizza'] : 'Non spécifié'}",
                                            style:
                                            TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Wrap: ${commandeDataRefuser['wrap']?.isNotEmpty == true ? commandeDataRefuser['wrap'] : 'Non spécifié'}",
                                            style:
                                            TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Boissons: ${commandeDataRefuser['boissons']?.isNotEmpty == true ? commandeDataRefuser['boissons'] : 'Non spécifié'}",
                                            style:
                                            TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Horaire souhaité : ${commandeDataRefuser['horraireCommande']?.isNotEmpty == true ? commandeDataRefuser['horraireCommande'] : 'Non spécifié'}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w800),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Prix Commande : ${commandeDataRefuser['prixTotalCommande'] != null ? '${commandeDataRefuser['prixTotalCommande']}€' : 'Non spécifié'}",
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
                                            "Date de la commande: ${commandeDataRefuser['dateCommande'] != null ? commandeDataRefuser['dateCommande'] : 'date inconnue'}",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ]);
    });

    ////////////////////////////////////////////////////////////////////
    final _formKey = GlobalKey<FormBuilderState>();
    //les variable de ce type permettent de récupérer les valeurs saisi par l'utilisateur
    TextEditingController _pizza = TextEditingController();
    TextEditingController _desc = TextEditingController();
    TextEditingController _prixM = TextEditingController();
    TextEditingController _prixL = TextEditingController();
    TextEditingController _sauce = TextEditingController();

    Widget listAjoutPizza =
        KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      // Calculez la hauteur de décalage en fonction de la visibilité du clavier
      double offset = isKeyboardVisible ? -10.0 : 0.0;
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Transform.translate(
          offset: Offset(0, offset),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  //on assigne la variable type TextEditindController dans la propiété controller
                  controller: _pizza,
                  name: "pizza",
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Nom de la pizza",
                    labelStyle: TextStyle(
                        color: Colors.white24,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  //la propriété validator permet de vérifier chaque champ
                  validator: FormBuilderValidators.required(
                      errorText: "Ce champ doit être rempli"),
                ),
                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  controller: _desc,
                  name: "desc",
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(
                        color: Colors.white24,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: "Ce champ doit être rempli"),
                ),
                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  controller: _prixM,
                  name: "prixM",
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Prix Medium",
                    labelStyle: TextStyle(
                        color: Colors.white24,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Ce champ doit être rempli"),
                  ]),
                ),
                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  controller: _prixL,
                  name: "prixL",
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Prix Large",
                    labelStyle: TextStyle(
                        color: Colors.white24,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: "Ce champ doit être rempli"),
                ),
                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  controller: _sauce,
                  name: "sauce",
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "base",
                    labelStyle: TextStyle(
                        color: Colors.white24,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Ce champ doit être rempli"),
                  ]),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    String pizzaValue = _pizza.text.toString().toUpperCase();
                    String descValue = _desc.text.toString();
                    String prixMValue = _prixM.text.toString();
                    String prixLValue = _prixL.text.toString();
                    String sauceValue = _sauce.text.toString();

                    CollectionReference eventsRef =
                        FirebaseFirestore.instance.collection("Events");
                    eventsRef.add({
                      "pizza": pizzaValue,
                      "desc": descValue,
                      "prixM": prixMValue,
                      "prixL": prixLValue,
                      "sauce": sauceValue
                    });
                    setState(() {
                      _selectedPage = 0;
                    });
                  },
                  child: Text("Ajouter"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.grey[900]),
                ),
              ],
            ),
          ),
        ),
      );
    });

    /////////////////////////////////////////////////////////////////////

    final _formKey2 = GlobalKey<FormBuilderState>();
    //les variable de ce type permettent de récupérer les valeurs saisi par l'utilisateur
    TextEditingController _adress = TextEditingController();

    Widget listAjoutAdress = Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: FormBuilder(
        key: _formKey2,
        child: Column(
          children: [
            FormBuilderTextField(
              //on assigne la variable type TextEditindController dans la propiété controller
              controller: _adress,
              name: "adress",
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Entrez une nouvelle localisation",
                labelStyle: TextStyle(
                    color: Colors.white24,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              //la propriété validator permet de vérifier chaque champ
              validator: FormBuilderValidators.required(
                  errorText: "Ce champ doit être rempli"),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                String adressValue = _adress.text.toString();

                CollectionReference adressRef =
                    FirebaseFirestore.instance.collection("Address");
                adressRef.add({"nom": adressValue, "est": false});
                setState(() {
                  _selectedPage = 0;
                });
              },
              child: Text("Ajouter"),
              style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(), backgroundColor: Colors.grey[900]),
            ),
          ],
        ),
      ),
    );

    ///////////////////////////////////////////////////////////////////

    Widget listPizzaActive = Center(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Events").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            return Text("Aucune pizza du jour active");
          }

          List<dynamic> events = [];
          snapshot.data!.docs.forEach((element) {
            events.add(element);
          });
          return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index].data();
                final documentId = events[index].id;
                final pizza = event["pizza"];
                final desc = event["desc"];
                final priM = event["prixM"];
                final prixL = event["prixL"];
                final sauce = event["sauce"];

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[850],
                          title: Text("Gestion des pizzas",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          content: Text(
                              "Voulez vous supprimer cette pizza du jour ? ",
                              style: GoogleFonts.poppins(color: Colors.white)),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text("Annuler",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white)),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor: Colors.grey[700],
                                  elevation: 20),
                            ),
                            ElevatedButton(
                              child: Text("OUI",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white)),
                              onPressed: () {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection("Events")
                                      .doc(documentId)
                                      .delete()
                                      .then((_) {
                                    print("pizza bien supprimé");
                                  }).catchError((error) {
                                    print("error : $error");
                                  });
                                  Navigator.pop(context);
                                });
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
                  },
                  child: Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: Image.asset(
                        "assets/images/queenmom.jpeg",
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        "$pizza",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "$desc " + " - " "$priM€ - $prixL€",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );

    ////////////////////////////////////////////////////////////////////

    Widget listAddress = StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Address').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement si les données sont en cours de chargement.
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // Gérer les erreurs éventuelles.
          return Text('Une erreur s\'est produite : ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Aucune adresse trouvée.
          return Text('Aucune adresse trouvée.');
        }

        // Si les données sont disponibles, construisez la liste de boutons.
        final addresses = snapshot.data!.docs;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final addressData =
                      addresses[index].data() as Map<String, dynamic>;
                  final address = addressData['nom']
                      as String; // Remplacez 'adresse' par le nom de votre champ.
                  final est = addressData['est'] as bool;
                  final selectedAddressId = addresses[index].id;

                  return TextButton(
                    onPressed: () async {
                      // Gérer le clic sur le bouton ici, par exemple, afficher l'adresse.
                      print('Adresse sélectionnée : $address');
                      await updateAddressToTrue(selectedAddressId);
                    },
                    child: Text(
                      address,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: est ? Colors.white : Colors.blue),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text("NUL PART",
                  style: GoogleFonts.poppins(color: Colors.white)),
              onPressed: () {
                updateAllAddressesToFalse();
              },
              style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.grey[700],
                  elevation: 20),
            ),
            ElevatedButton(
              onPressed: () {
                _showNotification();
              },
              child: Text('Afficher la notification'),
            )
          ],
        );
      },
    );
    /////////////////////////////////////////////////////////////////////////

    Widget listUser = Consumer<Mysql>(builder: (context, mysql, child) {
      List<bool> _selectedUser = List.generate(UsersFire.length, (_) => false);
      return Wrap(
          spacing: 15,
          children: List.generate(UsersFire.length, (index) {
            return Column(
              children: <Widget>[
                TextButton(
                  child: Text(
                    UsersFire[index],
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: UsersBanni.contains(UsersFire[index])
                            ? Colors.red
                            : Colors.blue),
                  ),
                  onPressed: () async {
                    setState(() {
                      _selectedUser[index] = !_selectedUser[index];
                      if (!mysql.userSelected.contains(UsersFire[index])) {
                        mysql.userSelected.add(UsersFire[index]);
                      } else {
                        mysql.userSelected.remove(UsersFire[index]);
                      }
                      print(mysql.userSelected);
                      print(UsersFire.indexOf(UsersFire[index]));

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[850],
                            title: Text("Gestion des utilisateurs",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                            content: Text("Gérer les utilisateurs",
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text("Bloquer",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)),
                                onPressed: () {
                                  updateUserBanniToTrue(UsersFire[index]);
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.grey[700],
                                    elevation: 20),
                              ),
                              ElevatedButton(
                                child: Text("Débloquer",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)),
                                onPressed: () {
                                  updateUserBanniToFalse(UsersFire[index]);
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.grey[700],
                                    elevation: 20),
                              ),
                              ElevatedButton(
                                child: Text("Points",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)),
                                onPressed: () async {
                                  await mysql
                                      .getFideliteForAdmin(UsersFire[index]);
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[850],
                                          title: Text(
                                              "Gestion des points utilisateurs",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Points : ${mysql.pointsForAmdin}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white)),
                                              DropdownButton<String>(
                                                  dropdownColor:
                                                      Colors.grey[700],
                                                  icon: Icon(
                                                      Icons.arrow_downward),
                                                  iconSize: 20,
                                                  elevation: 16,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      pointSelectionne =
                                                          newValue ?? '';
                                                    });
                                                    print(pointSelectionne);
                                                  },
                                                  value: pointSelectionne,
                                                  items: ajoutPoint.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      key: Key(value),
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    );
                                                  }).toList()),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: Text("Ajouter",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                mysql.addFideliteForAdmin(
                                                    UsersFire[index],
                                                    pointSelectionne);
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: StadiumBorder(),
                                                  backgroundColor:
                                                      Colors.grey[700],
                                                  elevation: 20),
                                            ),
                                            ElevatedButton(
                                              child: Text("Voir Points",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                mysql.getFideliteForAdmin(
                                                    UsersFire[index]);
                                                setState(() {
                                                  mysql.getFideliteForAdmin(
                                                      UsersFire[index]);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: StadiumBorder(),
                                                  backgroundColor:
                                                      Colors.grey[700],
                                                  elevation: 20),
                                            ),
                                            ElevatedButton(
                                              child: Text("Retour",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: StadiumBorder(),
                                                  backgroundColor:
                                                      Colors.grey[700],
                                                  elevation: 20),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.grey[700],
                                    elevation: 20),
                              ),
                              ElevatedButton(
                                child: Text("Commandes",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)),
                                onPressed: () async {
                                  await mysql
                                      .getCommandeClient7(UsersFire[index]);
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[850],
                                          title: Text(
                                              "Gestion des Commandes utilisateurs",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600)),
                                          content: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: [
                                                for (var i = 0;
                                                    i < mysql.id7.length;
                                                    i++)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        print(mysql.wrap7);
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Card(
                                                          color:
                                                              Colors.grey[900],
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Column(
                                                              children: [
                                                                if (mysql
                                                                        .pizza7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql.pizza7[i].contains(
                                                                            "null") ||
                                                                        mysql.pizza7[i] !=
                                                                            null))
                                                                  Text(
                                                                      "Pizza : " +
                                                                          mysql.pizza7[
                                                                              i] +
                                                                          '€',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                if (mysql
                                                                        .wrap7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql.wrap7[i].contains(
                                                                            "null") ||
                                                                        mysql.wrap7[i] !=
                                                                            null))
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                if (mysql
                                                                        .wrap7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql.wrap7[i].contains(
                                                                            "null") ||
                                                                        mysql.wrap7[i] !=
                                                                            null))
                                                                  Text(
                                                                      "Wrap : " +
                                                                          mysql.wrap7[
                                                                              i] +
                                                                          '€',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                if (mysql
                                                                        .boisson7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql.boisson7[i].contains(
                                                                            "null") ||
                                                                        mysql.boisson7[i] !=
                                                                            null))
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                if (mysql
                                                                        .boisson7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql.boisson7[i].contains(
                                                                            "null") ||
                                                                        mysql.boisson7[i] !=
                                                                            null))
                                                                  Text(
                                                                      "Boissons : " +
                                                                          mysql.boisson7[
                                                                              i] +
                                                                          '€',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                if (mysql.dessert7[
                                                                            i] !=
                                                                        null &&
                                                                    mysql
                                                                        .dessert7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql
                                                                        .dessert7[
                                                                            i]
                                                                        .contains(
                                                                            "null")))
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                if (mysql.dessert7[
                                                                            i] !=
                                                                        null &&
                                                                    mysql
                                                                        .dessert7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql
                                                                        .dessert7[
                                                                            i]
                                                                        .contains(
                                                                            "null")))
                                                                  Text(
                                                                      "Desserts : " +
                                                                          mysql.dessert7[
                                                                              i] +
                                                                          '€',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                if (mysql.commentaire7[
                                                                            i] !=
                                                                        null &&
                                                                    mysql
                                                                        .commentaire7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql
                                                                        .commentaire7[
                                                                            i]
                                                                        .contains(
                                                                            "null")))
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                if (mysql.commentaire7[
                                                                            i] !=
                                                                        null &&
                                                                    mysql
                                                                        .commentaire7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql
                                                                        .commentaire7[
                                                                            i]
                                                                        .contains(
                                                                            "null")))
                                                                  Text(
                                                                      "Commentaire : " +
                                                                          mysql.commentaire7[
                                                                              i],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight:
                                                                              FontWeight.w800)),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                if (mysql.hCommande7[
                                                                            i] !=
                                                                        null &&
                                                                    mysql
                                                                        .hCommande7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql
                                                                        .hCommande7[
                                                                            i]
                                                                        .contains(
                                                                            "null")))
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                if (mysql.hCommande7[
                                                                            i] !=
                                                                        null &&
                                                                    mysql
                                                                        .hCommande7[
                                                                            i]
                                                                        .isNotEmpty &&
                                                                    (!mysql
                                                                        .hCommande7[
                                                                            i]
                                                                        .contains(
                                                                            "null")))
                                                                  Text(
                                                                      "Horraire Souhaité : " +
                                                                          mysql.hCommande7[
                                                                              i],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight:
                                                                              FontWeight.w800)),
                                                                Text(
                                                                    mysql.dateCommande7[
                                                                        i],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                    mysql.prixCommande7[
                                                                            i] +
                                                                        "€",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        color: Colors
                                                                            .blue)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: Text("Retour",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: StadiumBorder(),
                                                  backgroundColor:
                                                      Colors.grey[700],
                                                  elevation: 20),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.grey[700],
                                    elevation: 20),
                              ),
                              ElevatedButton(
                                child: Text("Retour",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)),
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
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
                    });
                  },
                  style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.grey[900]),
                ),
                SizedBox(height: 10),
              ],
            );
          }));
    });

    //////////////////////////////////////////////////////////////////////////

    Widget listIngredy = StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Ingredients').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement si les données sont en cours de chargement.
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // Gérer les erreurs éventuelles.
          return Text('Une erreur s\'est produite : ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Aucune adresse trouvée.
          return Text('Aucune adresse trouvée.');
        }

        // Si les données sont disponibles, construisez la liste de boutons.
        final ingredys = snapshot.data!.docs;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: ingredys.length,
                itemBuilder: (context, index) {
                  final ingredyData =
                      ingredys[index].data() as Map<String, dynamic>;
                  final ingredy = ingredyData['nameIngredy']
                      as String; // Remplacez 'adresse' par le nom de votre champ.
                  final empty = ingredyData['empty'] as bool;
                  final selectedIngredyId = ingredys[index].id;

                  return TextButton(
                    onPressed: () async {
                      // Gérer le clic sur le bouton ici, par exemple, afficher l'adresse.
                      await updateIngredyToTrue(selectedIngredyId);
                    },
                    child: Text(
                      ingredy,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: empty ? Colors.white : Colors.blue),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text("TOUT EST DISPO",
                  style: GoogleFonts.poppins(color: Colors.white)),
              onPressed: () {
                updateAllIngredysToFalse();
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
    //////////////////////////////////////////////
    //////////////////////////////////////////////////
    /////////////////////////////////////////////////

    Widget listcreneau = Consumer<Mysql>(builder: (context, mysql, child) {
      List<bool> _selectedCreneau =
          List.generate(horaires.length, (_) => false);
      return Wrap(
          spacing: 15,
          children: List.generate(horaires.length, (index) {
            return Column(
              children: <Widget>[
                TextButton(
                  child: Text(
                    horaires[index],
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: indisponibleCreneau.contains(horaires[index])
                            ? Colors.white
                            : Colors.blue),
                  ),
                  onPressed: () {
                    // Affichez la valeur de "pizzasEnCoursSurMemeCreneau"
                    print(
                        "pizzasEnCoursSurMemeCreneau: ${mysql.pizzaData2.isNotEmpty ? mysql.pizzaData2[0]['pizzasEnCoursSurMemeCreneau'] : 0}");

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[850],
                          title: Text("A table !",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          content: Text(
                              "Vous avez actuellement ${mysql.pizzaData2.isNotEmpty ? mysql.pizzaData2[0]['pizzasEnCoursSurMemeCreneau'] : 0} pizza(s) sur ce créneau horaire. Voulez-vous le bloquer ? ",
                              style: GoogleFonts.poppins(color: Colors.white)),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text("Bloquer",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white)),
                              onPressed: () {
                                setState(() {
                                  _selectedCreneau[index] =
                                      !_selectedCreneau[index];
                                  mysql.creneauSelected.add(horaires[index]);
                                  updateCreneauToTrue(horaires[index]);
                                  print(mysql.creneauSelected);
                                  print(horaires.indexOf(horaires[index]));
                                  Navigator.pop(context);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor: Colors.grey[700],
                                  elevation: 20),
                            ),
                            ElevatedButton(
                              child: Text("Débloquer",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white)),
                              onPressed: () {
                                setState(() {
                                  _selectedCreneau[index] = false;
                                  mysql.creneauSelected.remove(horaires[index]);
                                  updateCreneauToFalse(horaires[index]);
                                  print(mysql.creneauSelected);
                                  print(horaires.indexOf(horaires[index]));
                                  Navigator.pop(context);
                                  print(horaires
                                      .indexOf(horaires[index])
                                      .toInt());
                                });
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
                  },
                  style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor:
                          mysql.creneauSelected.contains(horaires[index])
                              ? Colors.grey[600]
                              : Colors.grey[900]),
                ),
                SizedBox(height: 10),
              ],
            );
          }).toList()
            ..add(Column(
              children: <Widget>[
                TextButton(
                  child: Text(
                    'TOUT EST DISPONIBLE',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      mysql.creneauSelected.clear();
                      updateAllCreneauToFalse();
                    });
                  },
                  style: TextButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.grey[900],
                  ),
                ),
                SizedBox(height: 10),
              ],
            )));
    });

    ///////////////////////////////////////////////////
    ////////////////////////////////////////////
    //////////////////////////////////////////

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            //bouton rajouter dans la appBar qui permet d'appeler un menu latéral
            DrawerHeader(
                //degradé de couleur
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.grey, Colors.black38])),
                child: Center(
                  child: CircleAvatar(
                    child: SvgPicture.asset("assets/images/ilovepizza.svg"),
                    radius: 70,
                  ),
                )),
            //Un élément du menu
            ListTile(
              title: Text(
                "Commande",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              //icone a gauche du text
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              //Icone a droite du text
              trailing: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  _selectedPage = 1;
                  Navigator.pop(context);
                });
              },
            ),
            //Divider permet de créer une ligne de séparation pour les éléments du menu
            //Divider(height: 4,color: Colors.grey,),
            Consumer<Mysql>(builder: (context, mysql, child) {
              return ListTile(
                title: Text(
                  "Utilisateur",
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                //icone a gauche du text
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.white,
                ),
                //Icone a droite du text
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () async {
                  await getUsersFromFirestore();
                  await getUserBanni();
                  setState(() {
                    print(UsersFire);
                    _selectedPage = 2;
                    Navigator.pop(context);
                  });
                },
              );
            }),
            //Divider(height: 4,color: Colors.grey,),
            ListTile(
              title: Text(
                "Ingredient",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              //icone a gauche du text
              leading: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              //Icone a droite du text
              trailing: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  _selectedPage = 3;
                  Navigator.pop(context);
                });
              },
            ),
            //Divider(height: 4,color: Colors.grey,),
            ListTile(
              title: Text(
                "Créneau horaire",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              //icone a gauche du text
              leading: Icon(
                Icons.people,
                color: Colors.white,
              ),
              //Icone a droite du text
              trailing: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () async {
                await fetchIndisponibleCreneau();
                await getHorairesFromFirestore();
                setState(() {
                  _selectedPage = 4;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text(
                "Localisations",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              //icone a gauche du text
              leading: Icon(
                Icons.location_on_sharp,
                color: Colors.white,
              ),
              //Icone a droite du text
              trailing: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  checkTrueAddresses();
                  _selectedPage = 5;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text(
                "Ajout Pizza du jour",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              //icone a gauche du text
              leading: Icon(
                Icons.local_pizza,
                color: Colors.white,
              ),
              //Icone a droite du text
              trailing: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  _selectedPage = 6;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text(
                "Gestion Pizza Active",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              //icone a gauche du text
              leading: Icon(
                Icons.local_pizza,
                color: Colors.white,
              ),
              //Icone a droite du text
              trailing: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  _selectedPage = 7;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text(
                "Ajouter une localisation",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              //icone a gauche du text
              leading: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              //Icone a droite du text
              trailing: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  _selectedPage = 8;
                  Navigator.pop(context);
                });
              },
            ),
            Consumer<Mysql>(builder: (context, mysql, child) {
              return ListTile(
                title: Text(
                  "DECONNEXION",
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                //icone a gauche du text
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                //Icone a droite du text
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () async {
                  mysql.deleteCredential();
                  runApp(SplashScreen());
                },
              );
            }),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Gestion de service"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Center(
          child: Container(
            alignment: Alignment.topCenter,
            child: _selectedPage == 1
                ? menuComande
                : _selectedPage == 2
                    ? listUser
                    : _selectedPage == 5
                        ? listAddress
                        : _selectedPage == 3
                            ? listIngredy
                            : _selectedPage == 4
                                ? listcreneau
                                : _selectedPage == 6
                                    ? listAjoutPizza
                                    : _selectedPage == 7
                                        ? listPizzaActive
                                        : _selectedPage == 8
                                            ? listAjoutAdress
                                            : Container(),
          ),
        ),
      ),
    );
  }
}
