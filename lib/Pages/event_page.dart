import 'dart:math';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Pages/descPizzaPage.dart';
import 'package:flutter_app2/Recipe.dart';
import 'package:flutter_app2/bdd.dart';
import 'package:flutter_app2/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'delayed_animation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app2/panier_page.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app2/notification_service.dart';



class IngredientState extends ChangeNotifier {

  bool _selectedIngredientState = false;

  bool get selectedIngredientState => _selectedIngredientState;

  void setSelectedIngredientState(bool newState) {
    _selectedIngredientState = newState;
    notifyListeners();
  }
}

class EventPage extends StatefulWidget {
  @override
  State<EventPage> createState() => _EventPageState();
  
}

class _EventPageState extends State<EventPage> {
  Future<void> ajouterElements(
      List<Map<String, String>> elements, String collectionName) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);

      for (var element in elements) {
        await collectionRef.add(element);
      }

      print(
          "${elements.length} éléments ajoutés avec succès à la collection $collectionName.");
    } catch (e) {
      print("Erreur lors de l'ajout des éléments : $e");
    }
  }

  final List<String> indisponiblePizzas = [];
  List<String> indisponibleIngredients = [];
  final List<String> indisponibleIngredientsTrouves = [];
  List<String> indisponibleCreneau = [];
  String? periodValue;

  String selectedOption = "";
  int _selectedPage = 0;
  int _selectedStep = 0;
  bool setHorraire = false;
  bool msgIngredientMiss = false ;

  String selectedMinutes = "";

  bool colorButton = false;

  //declaration liste bool
  Map<int, bool> _showButtons = Map<int, bool>();
  int selectedTypeCompo = 0;
  int selectedSizeOf = 0;
  String eventPizzaIndisponible = "";
  List<String> eventIngredientIndisponible = [];
  List<String> eventPizzaIndisponibleList = [];
  List<String> ingredientCible = [];

  String eventSauceIndisponible = "";
  List<String> eventSauceIndisponibleList = [];
  String eventGarnitureIndisponible = "";
  List<String> eventGarnitureIndisponibleList = [];
  String eventAccompIndisponible = "";
  List<String> eventAccompIndisponibleList = [];
  String eventCheeseIndisponible = "";
  List<String> eventCheeseIndisponibleList = [];

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
    '20h20',
    '20h25',
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

  bool isLoading2 = false;
  bool isLoading3 = false;
  bool isLoadingHoraire = false;

  String? selectedIngredient;
  bool selectedIngredientState = false;

  var userDoc;
  String userDocFin = "" ;

  Map<String, int> pizzasEnCoursSurMemeCreneau = {};
  List<String> horraireNoDispo = [];


  void initState() {
    super.initState();
    fetchIndisponibleData();// Appel de votre méthode lors de l'initialisation de la page
  }




  Future<String> getFcmTokenFromDatabase() async {
    final database = FirebaseFirestore.instance;
    userDoc = await database.collection('UserToken').doc("L7dxFo5XCrO3PsZmGq7bp8GI0FH3").get();
    userDocFin = userDoc['token'].toString();
     return userDoc['token'];
  }


  Future<bool> getLocation() async {
    try {
      // Initialisez Firestore (assurez-vous d'avoir configuré Firebase au préalable)
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Effectuez la requête Firestore pour obtenir les documents de la collection "Address" où "est" est égal à true
      QuerySnapshot addressSnapshot = await firestore
          .collection('Address')
          .where('est', isEqualTo: true)
          .limit(1) // Si vous ne vous attendez qu'à un seul résultat, limitez la requête à 1
          .get();

      // Vérifiez s'il y a des résultats

      if (addressSnapshot != null && addressSnapshot.docs.isNotEmpty) {
        return true;
      } else {
        // Aucun document trouvé dans la collection "Address" où "est" est égal à true
        return false;
      }
      print(periodValue.toString());
    } catch (e) {
      print("Une erreur est survenue : $e");
      return false;
    }
  }

  void handleNewOrder(String employeeToken) {
    // Logique de traitement de la nouvelle commande

    // Envoyer la notification
    sendNotification(employeeToken);
  }

  Future<bool> isUserBanned() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Utilisez l'adresse e-mail de l'utilisateur pour rechercher dans la collection Users
        String email = user.email ?? "";
        QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('mail', isEqualTo: email)
            .get();
        print(email);

        if (usersSnapshot.docs.isNotEmpty) {
          // Il devrait y avoir un seul document correspondant à l'adresse e-mail
          bool estBanni = usersSnapshot.docs.first['estBanni'];
          print(estBanni);
          return estBanni;
        } else {
          print('Utilisateur non trouvé dans la collection Users');
          return false;
        }
      } else {
        print('Utilisateur non authentifié');
        return false;
      }
    } catch (e) {
      print('Erreur lors de la récupération de la valeur estBanni: $e');
      return false;
    }
  }

  Future<String?> getPeriodValueWhereEstIsTrue() async {
    try {
      // Initialisez Firestore (assurez-vous d'avoir configuré Firebase au préalable)
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Effectuez la requête Firestore pour obtenir les documents de la collection "Address" où "est" est égal à true
      QuerySnapshot addressSnapshot = await firestore
          .collection('Address')
          .where('est', isEqualTo: true)
          .limit(
              1) // Si vous ne vous attendez qu'à un seul résultat, limitez la requête à 1
          .get();

      // Vérifiez s'il y a des résultats

      if (addressSnapshot != null && addressSnapshot.docs.isNotEmpty) {
        final data = addressSnapshot.docs[0].data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('period')) {
          periodValue = data['period'] as String?;
        }
      } else {
        // Aucun document trouvé dans la collection "Address" où "est" est égal à true
        return null;
      }
      print(periodValue.toString());
    } catch (e) {
      print("Une erreur est survenue : $e");
      return null; // Gérer les erreurs selon vos besoins
    }
  }

  Future<void> fetchIndisponibleData() async {
    // 1. Récupérez les ingrédients avec "empty" à true
    final QuerySnapshot ingredientsSnapshot = await FirebaseFirestore.instance
        .collection('Ingredients')
        .where('empty', isEqualTo: true)
        .get();

    indisponibleIngredients = ingredientsSnapshot.docs
        .map((doc) => doc['nameIngredy'] as String)
        .toList();

// 2. Parcourez les pizzas et vérifiez si un ingrédient est indisponible
    final QuerySnapshot pizzasSnapshot =
        await FirebaseFirestore.instance.collection('Pizzas').get();

// Effacez les valeurs précédentes dans la liste avant de la mettre à jour
    indisponiblePizzas.clear();

    pizzasSnapshot.docs.forEach((pizzaDoc) {
      final List<String> pizzaIngredients = pizzaDoc['desc'].toString().split(
          ', '); // Assurez-vous que les ingrédients sont séparés par ", " dans le champ "desc"

      for (final ingredientIn in pizzaIngredients) {
        if (indisponibleIngredients.contains(ingredientIn)) {
          indisponiblePizzas.add(pizzaDoc['pizza'] as String);
          break; // Si l'ingrédient est indisponible, marquez la pizza et passez à la suivante
        }
      }
    });
    print(indisponibleIngredients);
    print(indisponiblePizzas);
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

  Future<void> getPizzaCountTest() async {
    CollectionReference commandesCollection = FirebaseFirestore.instance.collection('Commandes');
    try {
      // Exécutez la requête Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await commandesCollection
          .where('horraireCommande', isNotEqualTo: null)
          .where('enCours', isEqualTo: true)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      // Compter les pizzas en cours sur le même créneau

      // Traitement des résultats
      querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        String horraireCommande = document['horraireCommande'];
        List<String> pizzas = document['pizza'].toString().split('\n');

        // Mise à jour du compteur de pizzas pour chaque créneau horaire
        pizzasEnCoursSurMemeCreneau[horraireCommande] ??= 0;

        for (String pizza in pizzas) {
          List<String> pizzaInfo = pizza.split(' - ');

          if (pizzaInfo.isNotEmpty) {
            pizzasEnCoursSurMemeCreneau[horraireCommande] = (pizzasEnCoursSurMemeCreneau[horraireCommande] ?? 0) + 1;

            // Ajoutez l'horaire à horraireNoDispo si sa valeur est égale à 3
          }
        }
      });

      // Affichage des résultats
      pizzasEnCoursSurMemeCreneau.forEach((key, value) {
        print('$key : $value');

        if (value == 3) {
          horraireNoDispo.add(key);
          updateCreneauToTrue(key);
        }

      });

      // Mettre à jour les variables d'état
      print(pizzasEnCoursSurMemeCreneau);
      // Affichez la liste horraireNoDispo
      print('Horaires non disponibles : $horraireNoDispo');
    } catch (e) {
      print("Une erreur est survenue : $e");
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

  @override
  Widget build(BuildContext context) {

    IngredientState ingredientState = IngredientState();
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////

    Widget listPizza = StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Pizzas")
            .orderBy("prixM")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("Aucune pizzas");
          }

          List<dynamic> pizzas = [];
          snapshot.data!.docs.forEach((element) {
            pizzas.add(element);
          });

          for (int i = 0; i < pizzas.length; i++) {
            _showButtons.putIfAbsent(i, () => false);
          }

          List<String> findIndisponibleIngredients(
              String descEvent, List<String> indisponibleIngredient) {
            indisponibleIngredientsTrouves.clear();
            for (final ingredientEnfin in descEvent.split(', ')) {
              if (indisponibleIngredient.contains(ingredientEnfin)) {
                indisponibleIngredientsTrouves.add(ingredientEnfin);
              }
            }
            print(indisponibleIngredientsTrouves);
            return indisponibleIngredientsTrouves;
          }

          return Consumer<PanierVar>(builder: (context, panierV, child) {
            return ListView.builder(
                //padding du debut
                // nombre d'éléments à l'interieur de la liste
                itemCount: pizzas.length,
                //receptionner le contexte actuel ainsi que sa position
                itemBuilder: (context, index) {
                  final indexEvent = panierV.events[index];
                  final descEvent = indexEvent['desc'];
                  final event = pizzas[index].data();
                  final documentId = pizzas[index].id;
                  final logo = event["logo"];
                  final pizza = event["pizza"];
                  final prixM = event["prixM"].toString();
                  final prixL = event["prixL"].toString();
                  final taille = event["taille"];
                  final desc = event['desc'];
                  final sauce = event['sauce'];

                  return GestureDetector(
                    onTap: () {
                      if (indisponiblePizzas != null)
                        for (var item in indisponiblePizzas)
                          if (item == pizza) return null;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescPizzaPage(
                                recipe: Recipe(
                                    "assets/images/$logo.jpeg",
                                    "$descEvent",
                                    "$pizza",
                                    "$prixM",
                                    "$prixL",
                                    "$taille"),
                                ingredientState: ingredientState,
                                indisponibleIngredientsTrouves:
                                    indisponibleIngredientsTrouves),
                          ));
                    },
                    child: Card(
                      margin: EdgeInsets.all(3),
                      color: Colors.grey[900],
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/$logo.jpeg",
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
                                          color: (indisponiblePizzas != null &&
                                                  indisponiblePizzas
                                                      .contains(pizza))
                                              ? Colors.red
                                              : Colors.white),
                                    ),
                                  ),
                                  Text(
                                    "$descEvent\n$sauce",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white70),
                                  ),
                                  //Mettre le future builder qui filtre les pizza disponible
                                  if (indisponiblePizzas != null)
                                    for (var item in indisponiblePizzas)
                                      if (item == pizza)
                                        Column(
                                          children: [
                                            Consumer<Mysql>(builder:
                                                (context, mysql, child) {
                                              return TextButton(
                                                onPressed: () {
                                                  msgIngredientMiss = true;
                                                  setState(() {
                                                    findIndisponibleIngredients(
                                                        desc,
                                                        indisponibleIngredients);
                                                    int nombreIngredy =
                                                        indisponibleIngredientsTrouves
                                                            .length;
                                                    nombreIngredy > 1
                                                        ? showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          850],
                                                                  title: Text(
                                                                      "Indisponible.",
                                                                      style: GoogleFonts.poppins(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .w600)),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                          "Cette pizza n'est malheureusement pas disonible pendant ce service. Tu peux"
                                                                          " toujours en composer une qui y ressemble selon tes goûts :) .",
                                                                          style:
                                                                              GoogleFonts.poppins(color: Colors.white)),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      ElevatedButton(
                                                                        child: Text(
                                                                            "OK",
                                                                            style:
                                                                                GoogleFonts.poppins(color: Colors.white)),
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            shape:
                                                                                StadiumBorder(),
                                                                            backgroundColor:
                                                                                Colors.grey[700],
                                                                            elevation: 20),
                                                                      ),
                                                                    ],
                                                                  ));
                                                            },
                                                          )
                                                        : showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return DelayedAnimation(delay:100,
                                                                child: AlertDialog(
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          850],
                                                                  title: Text(
                                                                      "Remplacer L'ingredient indisponible",
                                                                      style: GoogleFonts.poppins(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                  content: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                          "Les ingrédients indisponibles sont : ",
                                                                          style: GoogleFonts.poppins(
                                                                              color:
                                                                                  Colors.white)),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                          /* "${mysql.ingreList.join(', ')} "  bbb + */
                                                                          indisponibleIngredientsTrouves.join(
                                                                              ', '),
                                                                          style: GoogleFonts.poppins(
                                                                              color:
                                                                                  Colors.red)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          "En appuyant sur 'OK' vous serez rediriger vers "
                                                                          "la description de la pizza, il vous suffira de cliquer "
                                                                          "sur 'Ajouter au panier', choisir la taille de votre pizza et cliquer "
                                                                          "sur 'PERSONNALISER' et enfin choisir votre ingredient de remplacement. ",
                                                                          style: GoogleFonts.poppins(
                                                                              color:
                                                                                  Colors.white)),
                                                                    ],
                                                                  ),
                                                                  actions: <Widget>[
                                                                    ChangeNotifierProvider<
                                                                        IngredientState>(
                                                                      create: (context) =>
                                                                          IngredientState(),
                                                                      child:
                                                                          ElevatedButton(
                                                                        child: Text(
                                                                            "OK",
                                                                            style:
                                                                                GoogleFonts.poppins(color: Colors.white)),
                                                                        onPressed:
                                                                            () async {
                                                                          await Future.delayed(Duration(
                                                                              milliseconds:
                                                                                  1000));
                                                                          var ingredientState = Provider.of<IngredientState>(
                                                                              context,
                                                                              listen:
                                                                                  false);
                                                                          ingredientState
                                                                              .setSelectedIngredientState(true);
                                                                          setState(() {
                                                                            msgIngredientMiss=false;
                                                                          });
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => DescPizzaPage(
                                                                                    recipe: Recipe("assets/images/$logo.jpeg", "$desc", "$pizza", "$prixM", "$prixL", "$taille"),
                                                                                    ingredientState: ingredientState,
                                                                                    // Ajoutez cette ligne pour passer ingredientState
                                                                                    indisponibleIngredientsTrouves: indisponibleIngredientsTrouves),
                                                                              ));
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            shape:
                                                                                StadiumBorder(),
                                                                            backgroundColor: Colors.grey[
                                                                                700],
                                                                            elevation:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                      child: Text(
                                                                          "Annuler",
                                                                          style: GoogleFonts.poppins(
                                                                              color:
                                                                                  Colors.white)),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedIngredientState =
                                                                              false;
                                                                          msgIngredientMiss = false;
                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          shape:
                                                                              StadiumBorder(),
                                                                          backgroundColor:
                                                                              Colors.grey[
                                                                                  700],
                                                                          elevation:
                                                                              20),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "INFORMATIONS ",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                          if (_showButtons[index] == false)
                            Container(
                              child: Row(children: [
                                IconButton(
                                  onPressed: () {
                                    if (indisponiblePizzas != null)
                                      for (var item in indisponiblePizzas)
                                        if (item == pizza) return null;
                                    setState(() {
                                      _showButtons[index] =
                                          !_showButtons[index]!;
                                      //print(_showButtons[index]);
                                    });
                                  },
                                  icon: Icon(Icons.add),
                                  color: Colors.white,
                                ),
                              ]),
                            ),
                          if (_showButtons[index] == true)
                            Container(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showButtons[index] =
                                            !_showButtons[index]!;
                                      });
                                    },
                                    icon: Icon(Icons.remove),
                                    color: Colors.white,
                                  ),
                                  Column(children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
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
                                                        _showButtons[index] =
                                                            !_showButtons[
                                                                index]!;
                                                        selectedIngredientState =
                                                            false;
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
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
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
                                                        _showButtons[index] =
                                                            !_showButtons[
                                                                index]!;
                                                        selectedIngredientState =
                                                            false;
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
                                  ]),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                });
          });
        });

////////////////////////////////////////////////////////////////

    Widget listSauce = ListView(children: [
      Consumer<PanierVar>(builder: (context, panierV, child) {
        List<bool> _selectedButtons =
            List.generate(panierV.sauces.length, (_) => false);
        return DelayedAnimation(
          delay: 1000,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Composez votre wrap/pizza cuit(e) au feu de bois en 4 étapes : ",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Etape 1, choisissez la base : ",
                style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selectedTypeCompo = 1;
                        });
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.white70,
                          backgroundColor: selectedTypeCompo == 1
                              ? Colors.grey[850]
                              : Colors.black,
                          shape: StadiumBorder()),
                      child: Text(
                        "Wrap",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: selectedTypeCompo == 1
                              ? Colors.white
                              : Colors.white70,
                        ),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selectedTypeCompo = 2;
                        });
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.white70,
                          backgroundColor: selectedTypeCompo == 2
                              ? Colors.grey[850]
                              : Colors.black,
                          shape: StadiumBorder()),
                      child: Text(
                        "Pizza",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: selectedTypeCompo == 2
                              ? Colors.white
                              : Colors.white70,
                        ),
                      )),
                  if (selectedTypeCompo == 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSizeOf = 1;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedSizeOf == 1
                            ? Colors.grey[850]
                            : Colors.black,
                      ),
                      child: Text(
                        "MEDIUM",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  if (selectedTypeCompo == 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSizeOf = 2;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedSizeOf == 2
                            ? Colors.grey[850]
                            : Colors.black,
                      ),
                      child: Text(
                        "LARGE",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Wrap(
                spacing: 15,
                children: List.generate(panierV.sauces.length, (index) {
                  return TextButton(
                    child: Text(
                      panierV.sauces[index],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: panierV.selectedSauces
                                  .contains(panierV.sauces[index])
                              ? Colors.white
                              : (indisponibleIngredients != null &&
                                      indisponibleIngredients
                                          .contains(panierV.sauces[index]))
                                  ? Colors.red
                                  : Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {
                        (indisponibleIngredients != null &&
                                indisponibleIngredients
                                    .contains(panierV.sauces[index]))
                            ? null
                            : _selectedButtons[index] =
                                !_selectedButtons[index];
                        print(_selectedButtons);
                      });
                      if (_selectedButtons[index]) {
                        if (!panierV.selectedSauces
                            .contains(panierV.sauces[index])) {
                          panierV.selectedSauces.add(panierV.sauces[index]);
                        } else {
                          panierV.selectedSauces.remove(panierV.sauces[index]);
                        }
                      }
                      print(panierV.selectedSauces);
                      // Code pour ajouter la sauce au panier
                    },
                    style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor:
                          panierV.selectedSauces.contains(panierV.sauces[index])
                              ? Colors.grey[600]
                              : Colors.grey[900],
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 70,
              ),
              selectedTypeCompo == 1
                  ? Text(
                      "Les extras 0,50€/Produit",
                      style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    )
                  : selectedTypeCompo == 2 && selectedSizeOf == 1
                      ? Text(
                          "Les extras 1€/Produit",
                          style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : selectedTypeCompo == 2 && selectedSizeOf == 2
                          ? Text(
                              "Les extras 2€/Produit",
                              style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            )
                          : SizedBox(
                              height: 20,
                            ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedTypeCompo == 0) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey[850],
                              title: Text("Faites votre choix",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                              content: Text(
                                  "Veuillez choisir un produit à composer, un wrap ou une pizza.",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white)),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text("OK",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white)),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.of(context).pop();
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
                      } else {
                        _selectedStep = 1;
                        print(panierV.selectedSauces);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.grey[900]),
                  child: Text(
                    "SUIVANT",
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ))
            ],
          ),
        );
      }),
    ]);
    ////////////////////////////////////////////////////

    Widget listGarniture = ListView(children: [
      Consumer<PanierVar>(builder: (context, panierV, child) {
        List<bool> _selectedButtons1 =
            List.generate(panierV.garnitures.length, (_) => false);
        return DelayedAnimation(
          delay: 500,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Composez votre wrap cuit au feu de bois en 4 étapes : ",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Etape 2, choisissez la garniture : ",
                style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 50,
              ),
              Wrap(
                spacing: 15,
                children: List.generate(panierV.garnitures.length, (index) {
                  return TextButton(
                    child: Text(
                      panierV.garnitures[index],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: panierV.selectedSauces
                                  .contains(panierV.garnitures[index])
                              ? Colors.white
                              : (indisponibleIngredients != null &&
                                      indisponibleIngredients
                                          .contains(panierV.garnitures[index]))
                                  ? Colors.red
                                  : Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {
                        (indisponibleIngredients != null &&
                                indisponibleIngredients
                                    .contains(panierV.garnitures[index]))
                            ? null
                            : _selectedButtons1[index] =
                                !_selectedButtons1[index];
                        print(_selectedButtons1);
                      });
                      if (_selectedButtons1[index]) {
                        if (!panierV.selectedSauces
                            .contains(panierV.garnitures[index])) {
                          panierV.selectedSauces.add(panierV.garnitures[index]);
                        } else {
                          panierV.selectedSauces
                              .remove(panierV.garnitures[index]);
                        }
                      }
                      print(panierV.selectedSauces);
                      // Code pour ajouter la sauce au panier
                    },
                    style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: panierV.selectedSauces
                              .contains(panierV.garnitures[index])
                          ? Colors.grey[600]
                          : Colors.grey[900],
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 40,
              ),
              selectedTypeCompo == 1
                  ? Text(
                      "Les extras 0,50€/Produit",
                      style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    )
                  : selectedTypeCompo == 2 && selectedSizeOf == 1
                      ? Text(
                          "Les extras 1€/Produit",
                          style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : selectedTypeCompo == 2 && selectedSizeOf == 2
                          ? Text(
                              "Les extras 2€/Produit",
                              style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            )
                          : SizedBox(
                              height: 20,
                            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStep = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.grey[900]),
                      child: Text(
                        "RETOUR",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStep = 2;
                          print(panierV.selectedSauces);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.grey[900]),
                      child: Text(
                        "SUIVANT",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        );
      }),
    ]);

    //////////////////////////////////////////////////////////

    Widget listAccomp = ListView(children: [
      Consumer<PanierVar>(builder: (context, panierV, child) {
        List<bool> _selectedButtons2 =
            List.generate(panierV.accompagnements.length, (_) => false);
        return DelayedAnimation(
          delay: 500,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Composez votre wrap cuit au feu de bois en 4 étapes : ",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Etape 3, choisissez les accompagnements : ",
                style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 50,
              ),
              Wrap(
                spacing: 15,
                children:
                    List.generate(panierV.accompagnements.length, (index) {
                  return TextButton(
                    child: Text(
                      panierV.accompagnements[index],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: panierV.selectedSauces
                                  .contains(panierV.accompagnements[index])
                              ? Colors.white
                              : (indisponibleIngredients != null &&
                                      indisponibleIngredients.contains(
                                          panierV.accompagnements[index]))
                                  ? Colors.red
                                  : Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {
                        (indisponibleIngredients != null &&
                                indisponibleIngredients
                                    .contains(panierV.accompagnements[index]))
                            ? null
                            : _selectedButtons2[index] =
                                !_selectedButtons2[index];
                        print(_selectedButtons2);
                      });
                      if (_selectedButtons2[index]) {
                        if (!panierV.selectedSauces
                            .contains(panierV.accompagnements[index])) {
                          panierV.selectedSauces
                              .add(panierV.accompagnements[index]);
                        } else {
                          panierV.selectedSauces
                              .remove(panierV.accompagnements[index]);
                        }
                      }
                      print(panierV.selectedSauces);
                      // Code pour ajouter la sauce au panier
                    },
                    style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: panierV.selectedSauces
                              .contains(panierV.accompagnements[index])
                          ? Colors.grey[600]
                          : Colors.grey[900],
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 40,
              ),
              selectedTypeCompo == 1
                  ? Text(
                      "Les extras 0,50€/Produit",
                      style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    )
                  : selectedTypeCompo == 2 && selectedSizeOf == 1
                      ? Text(
                          "Les extras 1€/Produit",
                          style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : selectedTypeCompo == 2 && selectedSizeOf == 2
                          ? Text(
                              "Les extras 2€/Produit",
                              style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            )
                          : SizedBox(
                              height: 20,
                            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStep = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.grey[900]),
                      child: Text(
                        "RETOUR",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStep = 3;
                          print(panierV.selectedSauces);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.grey[900]),
                      child: Text(
                        "SUIVANT",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        );
      }),
    ]);

    //////////////////////////////////////////////////////////////////

    Widget listCheese = ListView(children: [
      Consumer<PanierVar>(builder: (context, panierV, child) {
        List<bool> _selectedButtons3 =
            List.generate(panierV.fromages.length, (_) => false);
        return DelayedAnimation(
          delay: 500,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Composez votre wrap cuit au feu de bois en 4 étapes : ",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Etape 4, choisissez le fromage : ",
                style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 50,
              ),
              Wrap(
                spacing: 15,
                children: List.generate(panierV.fromages.length, (index) {
                  return TextButton(
                    child: Text(
                      panierV.fromages[index],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: panierV.selectedSauces
                                  .contains(panierV.fromages[index])
                              ? Colors.white
                              : (indisponibleIngredients != null &&
                                      indisponibleIngredients
                                          .contains(panierV.fromages[index]))
                                  ? Colors.red
                                  : Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {
                        (indisponibleIngredients != null &&
                                indisponibleIngredients
                                    .contains(panierV.fromages[index]))
                            ? null
                            : _selectedButtons3[index] =
                                !_selectedButtons3[index];
                        print(_selectedButtons3);
                      });
                      if (_selectedButtons3[index]) {
                        if (!panierV.selectedSauces
                            .contains(panierV.fromages[index])) {
                          panierV.selectedSauces.add(panierV.fromages[index]);
                        } else {
                          panierV.selectedSauces
                              .remove(panierV.fromages[index]);
                        }
                      }
                      print(panierV.selectedSauces);
                      // Code pour ajouter la sauce au panier
                    },
                    style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: panierV.selectedSauces
                              .contains(panierV.fromages[index])
                          ? Colors.grey[600]
                          : Colors.grey[900],
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 40,
              ),
              selectedTypeCompo == 1
                  ? Text(
                      "Les extras 0,50€/Produit",
                      style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    )
                  : selectedTypeCompo == 2 && selectedSizeOf == 1
                      ? Text(
                          "Les extras 1€/Produit",
                          style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : selectedTypeCompo == 2 && selectedSizeOf == 2
                          ? Text(
                              "Les extras 2€/Produit",
                              style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            )
                          : SizedBox(
                              height: 20,
                            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStep = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.grey[900]),
                      child: Text(
                        "RETOUR",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          print(panierV.selectedSauces);
                          if (panierV.selectedSauces.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[850],
                                  title: Text("Attention",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  content: Text(
                                      "Il est impossible d'ajouter au panier un Wrap sans ingrédients.",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white)),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text("OK",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
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
                          } else {
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
                                      "Votre Wrap/Pizza a bien été ajouté à votre panier",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white)),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text("OK",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white)),
                                      onPressed: () {
                                        setState(() {
                                          panierV.increment();
                                          if (selectedTypeCompo == 1) {
                                            double prixW = 6;
                                            if (panierV.selectedSauces.length >
                                                4) {
                                              prixW += (panierV.selectedSauces
                                                          .length -
                                                      4) *
                                                  0.50;
                                            }
                                            final selectedSaucesString = panierV
                                                .selectedSauces
                                                .join(', ');
                                            panierV.selectedPizz.add({
                                              "wraps": selectedSaucesString,
                                              "prixW": prixW.toString(),
                                            });
                                          } else if (selectedTypeCompo == 2 &&
                                              selectedSizeOf == 1) {
                                            double prixCompoMedium = 12;
                                            if (panierV.selectedSauces.length >
                                                4) {
                                              prixCompoMedium += (panierV
                                                          .selectedSauces
                                                          .length -
                                                      4) *
                                                  1;
                                            }
                                            final selectedSaucesString = panierV
                                                .selectedSauces
                                                .join(', ');
                                            panierV.selectedPizz.add({
                                              "pizzaCompoMedium":
                                                  selectedSaucesString,
                                              "prixCompoMedium":
                                                  prixCompoMedium.toString(),
                                            });
                                          } else if (selectedTypeCompo == 2 &&
                                              selectedSizeOf == 2) {
                                            double prixCompoLarge = 16;
                                            if (panierV.selectedSauces.length >
                                                4) {
                                              prixCompoLarge += (panierV
                                                          .selectedSauces
                                                          .length -
                                                      4) *
                                                  2;
                                            }
                                            final selectedSaucesString = panierV
                                                .selectedSauces
                                                .join(', ');
                                            panierV.selectedPizz.add({
                                              "pizzaCompoLarge":
                                                  selectedSaucesString,
                                              "prixCompoLarge":
                                                  prixCompoLarge.toString(),
                                            });
                                          }

                                          _selectedStep = 0;
                                          selectedSizeOf = 0;
                                          selectedTypeCompo = 0;
                                          Navigator.of(context).pop();
                                          panierV.selectedSauces.clear();
                                          print(panierV.selectedSauces);
                                          print(panierV.selectedPizz);
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
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.grey[900]),
                      child: Text(
                        "AJOUTER AU PANIER",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        );
      }),
    ]);

    /////////////////////////////////////////////////////////////////

    Widget listDessertAndDrink =
        Consumer<PanierVar>(builder: (context, panierV, child) {
      return ListView.builder(
          //padding du debut
          // nombre d'éléments à l'interieur de la liste
          itemCount: panierV.boissonsEtDesserts.length,
          //receptionner le contexte actuel ainsi que sa position
          itemBuilder: (context, index) {
            final eventBD = panierV.boissonsEtDesserts[index];
            final nomB = eventBD["boissons"];
            final logoB = eventBD["logoB"];
            final prixB = eventBD["prixB"];

            return DelayedAnimation(
              delay: 1000,
              child: Card(
                margin: EdgeInsets.all(5),
                color: Colors.grey[900],
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/$logoB",
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
                                "$nomB $prixB" + "€",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
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
                                        "Votre $nomB a bien été ajouté à votre panier",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white)),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text("OK",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                        onPressed: () {
                                          setState(() {
                                            //bbbb
                                            panierV.increment();
                                            panierV.selectedPizz.add({
                                              "boissons": nomB,
                                              "prixB": prixB,
                                            });
                                            //compteurPanier++ ;
                                            print(panierV.selectedPizz);
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
                          icon: Icon(Icons.add),
                          color: Colors.white,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            );
          });
    });

    ///////////////////////////////////////////////////////////////

    Widget panierFinal =
        Consumer<PanierVar>(builder: (context, panierV, child) {
      //somme de tous les prix
      double sumPrixM = 0;
      double sumPrixL = 0;
      double sumPrixW = 0;
      double sumPrixB = 0;
      double sumPrixSupMedium = 0;
      double sumPrixSupLarge = 0;

      for (var item in panierV.selectedPizz) {
        if (item.containsKey("prixM")) {
          sumPrixM += double.parse(item["prixM"]);
        }
        if (item.containsKey("prixL")) {
          sumPrixL += double.parse(item["prixL"]);
        }
        if (item.containsKey("prixW")) {
          sumPrixW += double.parse(item["prixW"]);
        }
        if (item.containsKey("prixB")) {
          sumPrixB += double.parse(item["prixB"]);
        }
        if (item.containsKey("prixSupMedium")) {
          sumPrixSupMedium += double.parse(item["prixSupMedium"]);
        }
        if (item.containsKey("prixSupLarge")) {
          sumPrixSupLarge += double.parse(item["prixSupLarge"]);
        }
        if (item.containsKey("prixCompoLarge")) {
          sumPrixSupLarge += double.parse(item["prixCompoLarge"]);
        }
        if (item.containsKey("prixCompoMedium")) {
          sumPrixSupMedium += double.parse(item["prixCompoMedium"]);
        }
      }

      double sumAll = sumPrixM +
          sumPrixL +
          sumPrixW +
          sumPrixB +
          sumPrixSupMedium +
          sumPrixSupLarge;

      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 15,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DelayedAnimation(
                delay: 500,
                child: Consumer<Mysql>(builder: (context, mysql, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text("Votre Panier",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            width: 8,
                          ),
                          /*TextButton(
                              child: Text("Utiliser mes points",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      backgroundColor: colorButton == true ? Colors.grey[850] :Colors.black,
                                      fontWeight: FontWeight.w600)),
                              onPressed: () async {
                                await mysql.getFidelite();
                                setState(()  {
                                  if(mysql.points >= 110){
                                    colorButton = !colorButton ;
                                  }
                                });
                              },
                            ),*/
                        ],
                      ),
                      if (mysql.points >= 110 && colorButton == true)
                        Text(
                          "Vous bénéficiez d'une remise de 10€ sur cette commande grâce à vos points",
                          style: GoogleFonts.poppins(
                              color: Colors.lightGreenAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                    ],
                  );
                }),
              ),
              SizedBox(height: 10),
              Center(
                child: DelayedAnimation(
                  delay: 500,
                  child: Text(
                    "Toute commande non récupérée vous fera perdre l'éligibilité d'utiliser l'application pour commander",
                    style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              panierV.selectedPizz.isNotEmpty
                  ? Expanded(
                      child: DelayedAnimation(
                        delay: 800,
                        child: ListView.builder(
                          itemCount: panierV.selectedPizz.length,
                          itemBuilder: (context, index) {
                            var item = panierV.selectedPizz[index];
                            return Dismissible(
                              background: Container(
                                color: Colors.red,
                              ),
                              key: Key(item.toString()),
                              onDismissed: (direction) {
                                setState(() {
                                  panierV.selectedPizz.removeAt(index);
                                  panierV.decrement();
                                  print(panierV.selectedPizz);
                                });
                              },
                              child: Column(
                                children: [
                                  Card(
                                    color: Colors.grey[850],
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        if (item.containsKey('pizzaM'))
                                          Row(
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Pizza Medium :",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    item["pizzaM"],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    item["tailleM"],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    item["prixM"],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white70),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        else if (item.containsKey('pizzaL'))
                                          Row(
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Pizza Large :",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    item["pizzaL"],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    item["tailleL"],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    item["prixL"],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white70),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        else if (item.containsKey('wraps'))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Wrap :",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                item["wraps"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                              Text(
                                                item["prixW"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                            ],
                                          )
                                        else if (item.containsKey('boissons'))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Boisson :",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                item["boissons"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                              Text(
                                                item["prixB"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                            ],
                                          )
                                        else if (item
                                            .containsKey('pizzaSupMedium'))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Pizza Medium Composée :",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                item["pizzaSupMedium"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                              Text(
                                                item["prixSupMedium"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                            ],
                                          )
                                        else if (item
                                            .containsKey('pizzaSupLarge'))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Pizza Large :",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                item["pizzaSupLarge"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                              Text(
                                                item["prixSupLarge"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                            ],
                                          )
                                        else if (item
                                            .containsKey('pizzaCompoMedium'))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Pizza Medium : ",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                item["pizzaCompoMedium"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                              Text(
                                                item["prixCompoMedium"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                            ],
                                          )
                                        else if (item
                                            .containsKey('pizzaCompoLarge'))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Pizza Large Composée :",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                item["pizzaCompoLarge"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                              Text(
                                                item["prixCompoLarge"],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: DelayedAnimation(
                        delay: 500,
                        child: Center(
                          child: Text(
                            "Votre panier est vide...",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              if (setHorraire == true)
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
                          if (horraireNoDispo.contains(newValue) ||
                              indisponibleCreneau.contains(newValue)) {
                            return; // sortir de la méthode onChanged sans mettre à jour l'état si la valeur sélectionnée n'est pas disponible
                          }
                          setState(() {
                            horaireSelectionneSoir = newValue ?? '';
                            horaireSelectionneMidi = newValue ?? '';
                          });
                          print(horaireSelectionneSoir);
                        },
                        value: periodValue == "soir"
                            ? horaireSelectionneSoir
                            : horaireSelectionneMidi,
                        items: periodValue == "soir"
                            ? horairesSoir
                                .map<DropdownMenuItem<String>>((String value) {
                                bool isRed =
                                    horraireNoDispo.contains(value) ||
                                        indisponibleCreneau.contains(value);
                                return DropdownMenuItem<String>(
                                  key: Key(value),
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: isRed ? Colors.red : Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList()
                            : horairesMidi
                                .map<DropdownMenuItem<String>>((String value1) {
                                bool isRed =
                                    horraireNoDispo.contains(value1) ||
                                        indisponibleCreneau.contains(value1);
                                return DropdownMenuItem<String>(
                                  key: Key(value1),
                                  value: value1,
                                  child: Text(
                                    value1,
                                    style: TextStyle(
                                        color: isRed ? Colors.red : Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList()),
                  );
                }),
              SizedBox(
                height: 50,
              ),
              Center(
                child: DelayedAnimation(
                  delay: 1000,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async {
                                setState(() {
                                  panierV.compteurPanier = 0;
                                  panierV.selectedPizz.clear();
                                  setHorraire = false;

                                });
                              },
                              child: Text(
                                "Vider le panier",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                              )),
                          Consumer<Mysql>(builder: (context, mysql, child) {
                            return TextButton(
                              onPressed: () async {
                                setState(() {
                                  isLoadingHoraire = true;
                                });

                                await getPizzaCountTest();
                                await fetchIndisponibleCreneau();
                                await getPeriodValueWhereEstIsTrue();

                                await Future.delayed(Duration(seconds: 2));

                                setState(() {
                                  isLoadingHoraire = false;
                                  // mysql.getHorraireNotDispo();
                                  print(mysql.horraireNoDispo);
                                  setHorraire = !setHorraire;
                                });
                              },
                              child: isLoadingHoraire
                                  ? CircularProgressIndicator()
                                  : Text("Choisir un horaire ?",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      )),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Consumer<Mysql>(builder: (context, mysql, child) {
                  return DelayedAnimation(
                    delay: 1000,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.white24,
                        padding: EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 13,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading2 = true;
                        });

                        // Afficher le CircularProgressIndicator pendant un certain temps
                        await Future.delayed(Duration(
                            seconds:
                                2)); // Remplacez 2 par la durée souhaitée en secondes

                        // Charger les données de manière asynchrone
                        bool isBanned = await isUserBanned();

                        setState(() {
                          isLoading2 = false;
                        });
                        if (isBanned) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[850],
                                title: Text("Un problème.. !",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                content: Text(
                                    "Vous ne pouvez pas commander avec votre compte car à plusieurs reprises vous avez commandé sans venir récupérer votre commande, merci de prendre contact avec nos services pour débloquer votre compte",
                                    style:
                                        GoogleFonts.poppins(color: Colors.white)),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("OK",
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
                        } else {
                          setState(() {
                            isLoading2 = true;
                          });

                          // Afficher le CircularProgressIndicator pendant un certain temps
                          await Future.delayed(Duration(
                              seconds:
                                  2)); // Remplacez 2 par la durée souhaitée en secondes

                          // Charger les données de manière asynchrone
                          bool isLoc = await getLocation();
                          // await mysql.getCommandeClientEnCours();

                          setState(() {
                            isLoading2 = false;
                          });
                          setState(() {
                            if (isLoc==false) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[850],
                                    title: Text("Oups... Pas encore l'heure",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    content: Text(
                                        "Nous ne sommes pas encore ouverts.",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white)),
                                    actions: <Widget>[
                                      Consumer<Mysql>(
                                          builder: (context, mysql, child) {
                                        return ElevatedButton(
                                          child: Text("OK",
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
                                        );
                                      }),
                                    ],
                                  );
                                },
                              );
                            } else if (mysql.commandeEnAttente == 1.toInt()) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[850],
                                    title: Text("Oups... ",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    content: Text(
                                        "Vous avez déjà une commande en attente ou en cours.",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white)),
                                    actions: <Widget>[
                                      Consumer<Mysql>(
                                          builder: (context, mysql, child) {
                                        return ElevatedButton(
                                          child: Text("OK",
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
                                        );
                                      }),
                                    ],
                                  );
                                },
                              );
                            } else if (mysql.horraireNoDispo.toString().contains(
                                    horaireSelectionneSoir.toString()) ||
                                mysql.horraireNoDispo.toString().contains(
                                    horaireSelectionneMidi.toString())) {
                            } else if (panierV.selectedPizz.isEmpty) {
                            } else if (panierV.selectedPizz.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[850],
                                    title: Text("A table !",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            "Votre Commande va être prise en compte,"
                                            " une fois validé par nos services, "
                                            "elle apparaîtrera dans votre page d'accueil. "
                                            "Si vous ne choisissez pas d'horraire, votre commande sera traité immédiatement dans l'ordre d'arrivée.",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white)),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Consumer<Mysql>(
                                          builder: (context, mysql, child) {
                                        return ElevatedButton(
                                          child: Text("Commander",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white)),
                                          onPressed: () async {
                                            // le if pour traitement BDD
                                            print(panierV.selectedPizz);
                                            try {
                                              final insertedValues =
                                                  await mysql.insertDataFirebase(
                                                      panierV.selectedPizz,
                                                      sumAll.toString(),
                                                    periodValue == "soir"
                                                        ? horaireSelectionneSoir
                                                        : horaireSelectionneMidi);
                                              print('Bien Bon');
                                            } catch (e) {
                                              print(
                                                  'Erreur lors de l\'insertion des données : $e');
                                            }
                                            await getFcmTokenFromDatabase();
                                            handleNewOrder(userDocFin);
                                            print(userDocFin);

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyApp()));
                                            panierV.compteurPanier = 0;
                                            panierV.selectedPizz.clear();
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: StadiumBorder(),
                                              backgroundColor: Colors.grey[700],
                                              elevation: 20),
                                        );
                                      }),
                                    ],
                                  );
                                },
                              );
                            }
                          });
                        }
                        ;
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: isLoading2
                                  ? '' // Laissez la chaîne vide lorsque isLoading2 est vrai
                                  : 'COMMANDER ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              children: isLoading2
                                  ? <InlineSpan>[
                                      WidgetSpan(
                                        child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                Colors
                                                    .white70)), // Affichez le CircularProgressIndicator lorsque isLoading2 est vrai
                                      ),
                                    ]
                                  : null, // Sinon, n'ajoutez pas de child
                            ),
                            TextSpan(
                              text: isLoading2 ? "" : "$sumAll €",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  decoration: colorButton == true
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            if (colorButton == true)
                              TextSpan(
                                text: "  ${sumAll -= 10}€",
                                style: GoogleFonts.poppins(
                                    color: Colors.lightGreenAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: DelayedAnimation(
                  delay: 2500,
                  child: Text(
                    "07.83.80.77.40",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
      );
    });
//////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(""),
        actions: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedPage = 0;
                            });
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white70,
                            shape: StadiumBorder(),
                            backgroundColor: _selectedPage == 0
                                ? Colors.grey[850]
                                : Colors.black,
                          ),
                          child: Text(
                            "Pizzas",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _selectedPage == 0
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
                              _selectedPage = 1;
                            });
                          },
                          style: TextButton.styleFrom(
                              primary: Colors.white70,
                              backgroundColor: _selectedPage == 1
                                  ? Colors.grey[850]
                                  : Colors.black,
                              shape: StadiumBorder()),
                          child: Text(
                            "Composer",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _selectedPage == 1
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
                              _selectedPage = 2;
                            });
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white70,
                            shape: StadiumBorder(),
                            backgroundColor: _selectedPage == 2
                                ? Colors.grey[850]
                                : Colors.black,
                          ),
                          child: Text(
                            "Dessert & Boissons",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _selectedPage == 2
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          )),
                      Consumer<PanierVar>(builder: (context, panierV, child) {
                        return Stack(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedPage = 3;
                                });
                              },
                              icon: Icon(
                                Icons.add_shopping_cart,
                              ),
                            ),
                            if (panierV.compteurPanier != 0)
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
                                      //modelPanier.compteurPanier.toString(),
                                      panierV.compteurPanier.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ]),
              ),
            ),
          ),
        ],
      ),
      body: Container(
          child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                  child: _selectedPage == 0
                      ? listPizza
                      : _selectedPage == 1
                          ? _selectedStep == 0
                              ? listSauce
                              : _selectedStep == 1
                                  ? listGarniture
                                  : _selectedStep == 2
                                      ? listAccomp
                                      : _selectedStep == 3
                                          ? listCheese
                                          : null
                          : _selectedPage == 2
                              ? listDessertAndDrink
                              : _selectedPage == 3
                                  ? panierFinal
                                  : null))),
    );
  }
}
