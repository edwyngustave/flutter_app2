import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/bdd.dart';
import 'package:flutter_app2/panier_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'delayed_animation.dart';
import 'package:flutter_app2/bdd.dart';
import 'event_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _refreshButton = 0;
  String selectedAddress = "";

  // Déclarez _addressStream ici
  late Stream<QuerySnapshot> _addressStream;

  @override
  void initState() {
    super.initState();
    // Initialisez _addressStream dans initState()
    _addressStream = FirebaseFirestore.instance.collection('Address').snapshots();
  }

  List<Map<String, dynamic>> commandesDataListEnCours = [];

  @override
  Widget build(BuildContext context) {

    Future<void> fetchDataEnCours() async {
      String userId = "";

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

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Commandes')
            .where('enCours', isEqualTo: true)
            .where('iduserCom', isEqualTo: userId)
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

    //Scafold = une page
    return ListView(
        children: [
      StreamBuilder<QuerySnapshot>(
        stream: _addressStream, // Utilisez _addressStream ici
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Gérer les erreurs éventuelles.
            return Text('Une erreur s\'est produite : ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Aucune adresse trouvée.
            return Text('Aucune adresse trouvée.');
          }

          // Si les données sont disponibles, recherchez l'adresse où "est" est égal à true.
          final addresses = snapshot.data!.docs;

          for (final addressDocument in addresses) {
            final addressData = addressDocument.data() as Map<String, dynamic>;
            final est = addressData['est'] as bool;
            final nom = addressData['nom'] as String;

            if (est) {
              selectedAddress = nom; // Utilisez la variable de classe selectedAddress
              break; // Sortez de la boucle dès que vous trouvez une adresse avec "est" à true.
            }
          }

          if (selectedAddress != null) {
            // Affichez le nom de l'adresse sélectionnée.
            return Text('Adresse sélectionnée : $selectedAddress');
          } else {
            // Aucune adresse avec "est" égal à true n'a été trouvée.
            return Text('Aucune adresse avec "est" égal à true.');
          }
        },
      ),

      // Vos autres widgets et interfaces utilisateur ici
      Consumer<Mysql>(builder: (context, mysql, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DelayedAnimation(
              delay: 1000,
              child: Container(
                height: 300,
                child: SvgPicture.asset(
                  "assets/images/I LOVE PIZZA.svg",
                ),
              ),
            ),
            DelayedAnimation(
                delay: 1500,
                child: Column(
                  children: [
                    Text("Pizza du jour : ", style: GoogleFonts.poppins(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),),
                    EventList(),
                  ],
                )  ),
            SizedBox(height: 30,),
            DelayedAnimation(
              delay: 1500,
              child: Column(
                children: [
                  Text(
                    "Nous sommes actuellement au : ",
                    style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 10,),
                  if(selectedAddress!=null)
                  DelayedAnimation(delay:200,
                    child: Text(
                      "$selectedAddress",
                      style: GoogleFonts.poppins(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  if(selectedAddress==null)
                  Text(
                    "Nous ne sommes pas encore en service",
                    style: GoogleFonts.poppins(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        mysql.loc.toString(),
                        style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Text(
                    "07.83.80.77.40",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            DelayedAnimation(
              delay: 1500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900], shape: StadiumBorder()),
                onPressed: () async {
                  await fetchDataEnCours();
                  List<dynamic> pizzaData = mysql.pizzaData;
                  setState(() {
                    for (var data in pizzaData) {
                      print(
                          'pour ${data['horraireCommande']} : ${data['pizzasEnCoursSurMemeCreneau']}');
                    }
                    _refreshButton = 1;
                  });
                },
                child: Text("ACTUALISER"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (_refreshButton == 1)
              for (var commandeData in commandesDataListEnCours)
                DelayedAnimation(delay:200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        // shape: StadiumBorder(),
                        color: Colors.grey[900],
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Pizza : ${commandeData['pizza']?.isNotEmpty == true ? commandeData['pizza'] : 'Non spécifié'}",
                                style:
                                TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Wrap : ${commandeData['wrap']?.isNotEmpty == true ? commandeData['wrap'] : 'Non spécifié'}",
                                style:
                                TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Boissons : ${commandeData['boissons']?.isNotEmpty == true ? commandeData['boissons'] : 'Non spécifié'}",
                                style:
                                TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Prête pour : ${commandeData['horraireCommande']?.isNotEmpty == true ? commandeData['horraireCommande'] : 'Non spécifié'}",
                                style: TextStyle(
                                    color: Colors.blue,
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
                                "Vous serez notifié si votre commande est prête avant l'heure :) ",
                                style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(
                                height: 10,
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
      }),
    ]);
  }
}
class EventList extends StatefulWidget {

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  int sizeOf = 0 ;
  bool _showButtons = false;
  int showText = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Events').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('Aucun événement trouvé.');
        }

        return Consumer<PanierVar>(builder: (context, panierV, child) {

          return Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final Map<String, dynamic> event =
              document.data() as Map<String, dynamic>;
              final String pizza = event['pizza'] ?? '';
              final String desc = event['desc'] ?? '';
              final String prixM = event['prixM'] ?? '';
              final String prixL = event['prixL'] ?? '';
              final String sauce = event['sauce'] ?? '';

              if (event['pizza'] == null) {

              }

              return GestureDetector(
                onTap: () {},
                child: Card(
                  margin: EdgeInsets.all(3),
                  color: Colors.grey[900],
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/queenmom.jpeg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "$pizza $prixM" +
                                      "€" +
                                      "-" +
                                      "$prixL" +
                                      "€",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "$desc\n$sauce",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                  if (_showButtons == false)
                                    Container(
                                      child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showButtons =
                                                  true;
                                                });
                                              },
                                              icon: Icon(Icons.add),
                                              color: Colors.white,
                                            ),
                                          ]),
                                    ),
                      if (_showButtons == true)
                        Container(
                          child: Row(
                            children: [
                              DelayedAnimation(delay:200,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _showButtons =
                                      false;
                                    });
                                  },
                                  icon: Icon(Icons.remove),
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                  children: [
                                DelayedAnimation(delay:200,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DelayedAnimation(delay:200,
                                              child: AlertDialog(
                                                backgroundColor:
                                                Colors.grey[850],
                                                title: Text("A table !",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w600)),
                                                content: Text(
                                                    "Votre Pizza a bien été ajouté à votre panier",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white)),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: Text("OK",
                                                        style:
                                                        GoogleFonts.poppins(
                                                            color: Colors
                                                                .white)),
                                                    onPressed: () {
                                                      setState(() {
                                                        panierV.increment();
                                                        panierV.selectedPizz
                                                            .add({
                                                          "pizzaM": pizza,
                                                          "prixM": prixM,
                                                          "tailleM": 'MEDIUM'
                                                        });
                                                        //compteurPanier++ ;
                                                        print(panierV
                                                            .selectedPizz);
                                                        //compteurPanier++ ;
                                                        Navigator.pop(context);
                                                        _showButtons =
                                                        !_showButtons!;
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        shape:
                                                        StadiumBorder(),
                                                        backgroundColor:
                                                        Colors
                                                            .grey[700],
                                                        elevation: 20),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      });
                                    },
                                    child: Text(
                                      "MEDIUM",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DelayedAnimation(delay:200,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DelayedAnimation(delay:200,
                                              child: AlertDialog(
                                                backgroundColor:
                                                Colors.grey[850],
                                                title: Text("A table !",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w600)),
                                                content: Text(
                                                    "Votre Pizza a bien été ajouté à votre panier",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white)),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: Text("OK",
                                                        style:
                                                        GoogleFonts.poppins(
                                                            color: Colors
                                                                .white)),
                                                    onPressed: () {
                                                      setState(() {
                                                        panierV.increment();
                                                        panierV.selectedPizz
                                                            .add({
                                                          "pizzaL": pizza,
                                                          "prixL": prixL,
                                                          "tailleL": 'LARGE'
                                                        });
                                                        //compteurPanier++ ;
                                                        Navigator.pop(context);
                                                        _showButtons =
                                                        !_showButtons!;
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        shape:
                                                        StadiumBorder(),
                                                        backgroundColor:
                                                        Colors
                                                            .grey[700],
                                                        elevation: 20),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      });
                                    },
                                    child: Text(
                                      "LARGE",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                    ],
                  ),
                            ],
                          ),
                ),
              ),]),),);
            }).toList(),
          );
        }
        );
      },
    );
  }
}
