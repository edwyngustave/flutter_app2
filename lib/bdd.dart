
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';


class Mysql with ChangeNotifier {
  //initialisation des variables des méthodes
  String prenom2 = "";
  String nom2 = "";
  var code = '';
  bool result = false;
  List<String> mail = [];
  String? email = null;
  var codeProv = '';
  var pass = "";
  bool resultat = false;
  bool resultatBoss = false;
  int idDevResult = 0;
  String? checkLog = null;
  final storage = FlutterSecureStorage();
  String id = "";
  String mailResult = "";
  List<dynamic> adresseOnDay = [];
  List<dynamic> adresseOndayList = [
    "13 boulevard l’hautil Cergy 95800 Ipsl",
    "IUT de Sceau 8 avenue Cauchy 92330",
    "20 bis jardin boieldieu, 92800 IDRAC business school",
    "11 rue de l’école 95710 Bray et Lû",
    "12 avenue Paul delouvrier (RD10) 78180 Montigny les Bretonneux",
    "Vauréal 95490 Lycée Camille Claudel",
    "IUT de sceaux - Université Paris-Saclay"
  ];
  var loc = "";
  var locId ="";

  List<dynamic> ingredy = [
    'Sauce Tomate Maison',
    'Crème fraiche',
    'Mayonnaise',
    'Samouraï',
    'Ketchup',
    'Algérienne',
    'Biggy',
    'Barbecue',
    'Jambon',
    'Jambon De Dinde',
    'Poulet',
    'Merguez',
    'Chorizo',
    'Chorizo De Boeuf',
    'Lardons',
    'Lardons De Volailles',
    'Thon',
    'Saumon',
    'Anchois',
    'Pomme De Terre',
    'Champignons',
    'Artichauts',
    'Oignons Rouges',
    'Poivrons',
    'Ananas',
    'Olives Noires',
    'Persillade',
    'Emmental',
    'Mozzarella',
    'Chèvre',
    'Roquefort',
    'Raclette'
  ];

  List<dynamic> creneau = [
    '12h00','12h05','12h10','12h15','12h20','12h25','12h30','12h35','12h40','12h45','12h50','12h55',
    '13h00','13h05','13h10','13h15','13h20','13h25','13h30','13h35','13h40','13h45','18h30','18h35','18h40','18h45','18h50','18h55','19h00','19h05','19h10','19h15','19h20','19h25','19h30','19h35','19h40','19h45','19h50','19h55',
    '20h00','20h05','20h10','20h15','20h20','20h25','20h30','20h35','20h40','20h45','20h50','20h55','21h00','21h05','21h10','21h15','21h20','21h25',
    '21h30'
  ];

  List<dynamic> user = [];
  List<dynamic> userRouge = [];
  List<dynamic> userSelected = [];
  int mailVerifBlock = 0;

  List<dynamic> ingredySelected = [];
  List<dynamic> creneauSelected = [];

  List<String> ingreList = [];
  List<String> creneauList = [];

  List<String> nomCli = [];
  List<String> pizza = [];
  List<String> wrap = [];
  List<String> boisson = [];
  List<String> dessert = [];
  List<String> commentaire = [];
  List<String> prixCommande = [];
  List<String> hCommande = [];
  List<String> dateCommande = [];


  List<String> nomCli2 = [];
  List<String> pizza2 = [];
  List<String> wrap2 = [];
  List<String> boisson2 = [];
  List<String> dessert2 = [];
  List<String> commentaire2 = [];
  List<String> prixCommande2 = [];
  List<String> hCommande2 = [];
  List<String> dateCommande2 = [];
  List<String> id2= [];

  List<String> nomCli3 = [];
  List<String> pizza3 = [];
  List<String> wrap3 = [];
  List<String> boisson3 = [];
  List<String> dessert3 = [];
  List<String> commentaire3 = [];
  List<String> prixCommande3 = [];
  List<String> hCommande3 = [];
  List<String> dateCommande3 = [];
  List<String> id3 = [];

  List<String> pizza4 = [];
  List<String> wrap4 = [];
  List<String> boisson4 = [];
  List<String> dessert4 = [];
  List<String> commentaire4 = [];
  List<String> prixCommande4 = [];
  List<String> hCommande4 = [];
  List<String> id4 = [];
  List<String> delayCom = [];
  String commentaireAdmin4 = "";

  List<String> nomCli5 = [];
  List<String> pizza5 = [];
  List<String> wrap5 = [];
  List<String> boisson5 = [];
  List<String> dessert5 = [];
  List<String> commentaire5 = [];
  List<String> prixCommande5 = [];
  List<String> hCommande5 = [];
  List<String> dateCommande5 = [];
  List<String> id5 = [];

  List<String> id6 = [];
  List<String> pizza6 = [];
  List<String> wrap6 = [];
  List<String> boisson6 = [];
  List<String> dessert6 = [];
  List<String> commentaire6 = [];
  List<String> prixCommande6 = [];
  List<String> hCommande6 = [];
  List<String> dateCommande6 = [];

  List<String> id7 = [];
  List<String> pizza7 = [];
  List<String> wrap7 = [];
  List<String> boisson7 = [];
  List<String> dessert7 = [];
  List<String> commentaire7 = [];
  List<String> prixCommande7 = [];
  List<String> hCommande7 = [];
  List<String> dateCommande7 = [];





  int commandeEnCours = 0;
  int commandeEnAttente = 0;

  List<String> horraireNoDispo = [];
  List<String> horraireNoDispo2 = [];

  List<Map<String, dynamic>> pizzaData = [];
  List<Map<String, dynamic>> pizzaData2 = [];

  int points = 0;
  int pointsForAmdin = 0;

  String nomCli4 = "";
  String commandeCli4 = "";
  String prixCli4 = "";


  int _compteurMessage = 0;
  int get compteurMessage => _compteurMessage;
  set compteurMessage(int value) {
    _compteurMessage = value;
    notifyListeners();
  }
  void incrementMessage()async{
    _compteurMessage++;
    notifyListeners();
  }

  void decrementMessage()async{
    _compteurMessage--;
    notifyListeners();
  }

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
      //10.0.2.2 adresse pour le téléphone virtuel
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        password: "",
        db: 'ilovepizza');
    return await MySqlConnection.connect(settings);
  }

  void saveCredential(String usernameMail, String passwordM, userId) async {
    await storage.write(key: 'usernameMail', value: usernameMail);
    await storage.write(key: 'passwordM', value: passwordM);
    await storage.write(key: 'userId', value: userId);
  }

  Future<String?> checkCredentials() async {
    final checkLog = await storage.read(key: 'usernameMail');
    return checkLog;
  }

  Future<String?> getIdCred() async {
    id = (await checkId())!;
  }

  Future<String?> checkId() async {
    final getIdUser = await storage.read(key: 'userId');
    print(getIdUser);
    String? idUser = getIdUser;
    return idUser;
  }

  void deleteCredential() async {
    await storage.delete(key: 'usernameMail');
    await storage.delete(key: 'passwordM');
    await storage.delete(key: 'userId');
  }

  void deleteUserProv(emailProvisoire) async {
    try {
      var db = new Mysql();
      await db.getConnection().then((conn) {
        String sql =
            "delete from verif where emailProv = '${emailProvisoire.toString()}';";
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Erreur de connexion à la base de donnée: $e");
    }
  }

  void UpdateHoraire(idCom,horaireFInal ) async {
      try {
        var db = new Mysql();
        String sql =
        //METTRE UNE REQUETE QUI AGIT AVEC L'ID !!!!
            "UPDATE commandes SET horraireCommande = '$horaireFInal' WHERE id = '$idCom';";
        String sql2 =
            "UPDATE commandes SET delayCommande = '$horaireFInal' WHERE id = '$idCom';";
        await db.getConnection().then((conn) {
          conn.query(sql);
          conn.query(sql2);
          conn.close();
        });
      } catch (e) {
        print("Une erreur est survenue : $e");
      }
  }

  void getClient() async {
    try {
      var db = new Mysql();
      String prenom2 = "";
      String nom2 = "";
      await db.getConnection().then((conn) async {
        await getIdCred();
        if (id != null) {
          var results = await conn.query("SELECT prenom, nom FROM user WHERE id = $id");
          for (var row in results) {
            prenom2 = row[0].toString();
            nom2 = row[1].toString();

            print(prenom2);
            print(nom2);
          }
        }
        this.prenom2 = prenom2;
        this.nom2 = nom2;
        await Future.delayed(Duration(milliseconds: 500)); // Ajouter un délai d'attente de 500ms
        notifyListeners();
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e ");
    }
  }

  void getClient2(mailCommande) async {
    try {
      var db = new Mysql();
      String prenom2 = "";
      String nom2 = "";
      await db.getConnection().then((conn) async {
          var results = await conn.query("SELECT prenom, nom FROM user WHERE mail = '$mailCommande'");
          for (var row in results) {
            prenom2 = row[0].toString();
            nom2 = row[1].toString();

            print(prenom2);
            print(nom2);
          }
        this.prenom2 = prenom2;
        this.nom2 = nom2;
        await Future.delayed(Duration(milliseconds: 500)); // Ajouter un délai d'attente de 500ms
        notifyListeners();
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e ");
    }
  }

  void addUser(prenom, nom, tel, adresse, maily, mdpF) async {
    try {
      var db = new Mysql();
      await db.getConnection().then((conn) {
        String sql =
            "insert INTO user (prenom,nom,tel,adresse,mail,password) VALUES ('$prenom','$nom','$tel','$adresse','$maily','$mdpF');";
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Erreur de connexion à la base de donnée");
    }
  }

  void addID(id) async {
    try {
      var db = new Mysql();
      await db.getConnection().then((conn) {
        String sql = "insert INTO user (idDev) VALUES ('$id');";
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Erreur de connexion à la base de donnée");
    }
  }

  void addEmploye() async {}

  void addCommande(cartOrder, prixTot) async {
    try {
      var db = new Mysql();
      String prenom = "";
      String nom = "";
      await db.getConnection().then((conn) async {
        getIdCred();
        if (id != null) {
          String sql2 =
              "UPDATE user SET nbCommande = nbCommande+1 WHERE id = $id;";
          conn.query(sql2);
        }

        getIdCred();
        if (id != null) {
          var results =
              await conn.query("SELECT prenom, nom FROM user WHERE id = $id;");
          for (var row in results) {
            prenom = row[0].toString();
            nom = row[1].toString();

            print(prenom);
            print(nom);
          }
        }
        String sql =
            "insert into commande (nomClient, cart, prix, dateCommande) values ('$prenom $nom','$cartOrder', '$prixTot', NOW()) ;";
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e ");
    }
  }


  Future<void> insertDataFirebase(
      List<Map<String, dynamic>> selectedPizz, prixTot, String? horraireSouhaiter) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Utilisez l'adresse e-mail de l'utilisateur pour rechercher dans la collection Users
        String userId = "";
        userId = user.uid;
        String email = user.email ?? "";
        QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('mail', isEqualTo: email)
            .get();
        print(email);
        // Remarque : La méthode getIdCred() et la variable id ne sont plus utilisées,
        // car Firebase gère automatiquement l'authentification.

        // Obtenez le nom du client à partir de Firestore (remplacez "users" par le nom de votre collection)
        var userSnapshot = await firebaseFirestore.collection('Users').where('mail', isEqualTo: email).get();
        if (usersSnapshot.docs.isNotEmpty) {
          // Il devrait y avoir un seul document correspondant à l'adresse e-mail
          String nom = usersSnapshot.docs.first['nom'];
          String prenom = usersSnapshot.docs.first['prenom'];
          print(nom);
          print(prenom);

          String pizzasCombined = selectedPizz.isEmpty ? '' : selectedPizz.map((
              pizza) {
            if (pizza.containsKey('pizzaM')) {
              return '${pizza['pizzaM']} - ${pizza['tailleM']} - ${pizza['prixM']} ';
            } else if (pizza.containsKey('pizzaL')) {
              return '${pizza['pizzaL']} - ${pizza['tailleL']} - ${pizza['prixL']} ';
            } else if (pizza.containsKey('pizzaSupMedium')) {
              return '${pizza['pizzaSupMedium']} - ${pizza['prixSupMedium']} ';
            } else if (pizza.containsKey('pizzaSupLarge')) {
              return '${pizza['pizzaSupLarge']} - ${pizza['prixSupLarge']} ';
            } else if (pizza.containsKey('pizzaCompoMedium')) {
              return 'Pizza Composée Medium : ${pizza['pizzaCompoMedium']} - ${pizza['prixCompoMedium']} ';
            } else if (pizza.containsKey('pizzaCompoLarge')) {
              return 'Pizza Composée Large : ${pizza['pizzaCompoLarge']} - ${pizza['prixCompoLarge']} ';
            } else {
              return null;
            }
          }).where((element) => element != null).join('\n');

          String wrapsCombined = selectedPizz
              .map((pizza) =>
          pizza.containsKey('wraps')
              ? '${pizza['wraps']} - ${pizza['prixW']} '
              : null)
              .where((wrap) => wrap != null)
              .join('\n');
          String boissonsCombined = selectedPizz
              .map((pizza) =>
          pizza.containsKey('boissons')
              ? '${pizza['boissons']} - ${pizza['prixB']} '
              : null)
              .where((drink) => drink != null)
              .join('\n');

          var commandesData = {
            'nomClient': prenom +" "+nom,
            'pizza': pizzasCombined,
            'wrap': wrapsCombined,
            'boissons': boissonsCombined,
            'prixTotalCommande': prixTot.toString(),
            'horraireCommande': horraireSouhaiter,
            'enAttente': true,
            'enCours': false,
            'estFinie': false,
            'refusDef': false,
            'commentaireAdmin': null,
            'dateCommande' : DateTime.now().toString(),
            'iduserCom' : userId
          };

          // Remplacez "Commandes" par le nom de votre collection Firestore
          await firebaseFirestore.collection('Commandes').add(commandesData);
        }
      }
    } catch (e) {
      print("Une erreur est survenue : $e");
      rethrow;
    }
  }

  Future<void> insertData(
      List<Map<String, dynamic>> selectedPizz, prixTot, String? horraireSouhaiter) async {
    try {
      var db = new Mysql();
      String prenom = "";
      String nom = "";

      await db.getConnection().then((conn) async {
        getIdCred();
        if (id != null) {
          String sql2 =
              "UPDATE user SET nbCommande = nbCommande+1 WHERE id = $id;";
          conn.query(sql2);

          var results =
              await conn.query("SELECT prenom, nom FROM user WHERE id = $id;");
          for (var row in results) {
            prenom = row[0].toString();
            nom = row[1].toString();

            print(prenom);
            print(nom);
          }
        }
      });
      var conn = await db.getConnection();

      final nomClient = '$prenom $nom'; // Remplacer par le nom du client
      String pizzasCombined = selectedPizz.isEmpty ? '' : selectedPizz.map((pizza) {
        if (pizza.containsKey('pizzaM')) {
          return '${pizza['pizzaM']} - ${pizza['tailleM']} - ${pizza['prixM']}';
        } else if (pizza.containsKey('pizzaL')) {
          return '${pizza['pizzaL']} - ${pizza['tailleL']} - ${pizza['prixL']}';
        } else if (pizza.containsKey('pizzaSupMedium')) {
          return '${pizza['pizzaSupMedium']} - ${pizza['prixSupMedium']}';
        } else if (pizza.containsKey('pizzaSupLarge')) {
          return '${pizza['pizzaSupLarge']} - ${pizza['prixSupLarge']}';
        } else if (pizza.containsKey('pizzaCompoMedium')) {
          return 'Pizza Composée Medium : ${pizza['pizzaCompoMedium']} - ${pizza['prixCompoMedium']}';
        } else if (pizza.containsKey('pizzaCompoLarge')) {
          return 'Pizza Composée Large : ${pizza['pizzaCompoLarge']} - ${pizza['prixCompoLarge']}';
        }
      }).where((element) => element != null).join('\n');

      String wrapsCombined = selectedPizz
          .map((pizza) => pizza.containsKey('wraps') ? '${pizza['wraps']} - ${pizza['prixW']}' : null)
          .where((wrap) => wrap != null)
          .join('\n');
      String boissonsCombined = selectedPizz
          .map((pizza) => pizza.containsKey('boissons') ? '${pizza['boissons']} - ${pizza['prixB']}' : null)
          .where((drink) => drink != null)
          .join('\n');


      var query =
          "INSERT INTO commandes (nomClient, pizza, wrap, boissons, prixTotalCommande, horraireCommande) VALUES (?, ?, ?, ?, $prixTot,'$horraireSouhaiter')";
      var values = [nomClient, pizzasCombined, wrapsCombined, boissonsCombined];

      var result = await conn.query(query, values);

    } catch (e) {
      print("une erreur est survenue : $e");
      rethrow;
    }
  }

  void addNbCommande() async {}

  Future<void> VerifMail(String compareEmail) async {
    try {
      var db = new Mysql();
      List<String> mail = [];
      bool result = false;

      await db.getConnection().then((conn) {
        String sql = 'select mail from user;';
        conn.query(sql).then((results) {
          for (var row in results) {
            mail.add(row[0].toString());
            if (row[0].toString().toLowerCase() == compareEmail.toString().toLowerCase()) { // Comparaison ici
              result = true;
              break;
            }
          }
          print(result);
          print(mail);
          this.result = result;
          this.mail = mail;
          conn.close();
          notifyListeners();
        });
      });
    } catch (e) {
      print("Erreur de connexion à la base de données: $e");
    }
  }


  /*void getHorraireNotDispo()async{
    try{

      var db = new Mysql();
      List<String> horraireNoDispo = [];

      await db.getConnection().then((conn){
        String sql = 'SELECT horraireCommande FROM commandes WHERE enCours = 1; ';
        conn.query(sql).then((results){
          for(var row in results){
            horraireNoDispo.add(row[0].toString());
          }
          this.horraireNoDispo = horraireNoDispo;
          notifyListeners();
          conn.close();
        });
      });
    }catch(e){
      print("Une erreur est survenue : $e");
    }
  } */



  Future<void> getPizzaCount2(String hoursCrenn) async {
    try {
      var db = new Mysql();

      List<Map<String, dynamic>> pizzaData2 = [];
      List<String> horraireNoDispo2 = [];

      await db.getConnection().then((conn) {
        String sql = "SELECT horraireCommande, COUNT(*) AS pizzasEnCoursSurMemeCreneau FROM (SELECT horraireCommande, SUBSTRING_INDEX(SUBSTRING_INDEX(pizza, '\n', n.digit+1), '\n', -1) AS pizza_element, enCours FROM commandes JOIN (SELECT 0 AS digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) AS n ON CHAR_LENGTH(pizza)-CHAR_LENGTH(REPLACE(pizza, '\n', '')) >= n.digit) AS pizza_elements WHERE horraireCommande = '$hoursCrenn' AND enCours = 1 GROUP BY horraireCommande;";

        conn.query(sql).then((results) {
          for (var row in results) {
            pizzaData2.add({
              'horraireCommande': row[0],
              'pizzasEnCoursSurMemeCreneau': row[1],
            });
          }

          // Ajoutez les horaires dont pizzasEnCoursSurMemeCreneau est égal à 3 à horraireNoDispo
          for (var data in pizzaData2) {
            if (data['pizzasEnCoursSurMemeCreneau'] == 3) {
              horraireNoDispo2.add(data['horraireCommande'].toString());
            }
          }
          this.pizzaData2 = pizzaData2;
          this.horraireNoDispo2 = horraireNoDispo2;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }


  Future<String?> getIngredy() async {
    try {
      var db = new Mysql();
      List<String> ingreList = [];
      String sql = "SELECT nameIngredy FROM ingredy WHERE empty = 1 ;";
      await db.getConnection().then((conn) {
        conn.query(sql).then((resultat) {
          for (var row in resultat) {
            ingreList.add(row[0].toString());
            //print(row[0].toString());
          }
          this.ingreList = ingreList;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenu : $e");
    }
  }

  Future<String?> getCreneau() async {
    try {
      var db = new Mysql();
      List<String> creneauList = [];
      String sql = "SELECT hours FROM creneau WHERE vide = 1 ;";
      await db.getConnection().then((conn) {
        conn.query(sql).then((resultat) {
          for (var row in resultat) {
            creneauList.add(row[0].toString());
            //print(row[0].toString());
          }
          this.creneauList = creneauList;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenu : $e");
    }
  }

  void getCommande() async {
    try {
      var db = new Mysql();
      List<String> nomCli = [];
      List<String> pizza = [];
      List<String> wrap = [];
      List<String> boisson = [];
      List<String> dessert = [];
      List<String> commentaire = [];
      List<String> prixCommande = [];
      List<String> hCommande = [];
      List<String> dateCommande = [];

      await db.getConnection().then((conn) {
        String sql =
            "SELECT nomClient, pizza, wrap, boissons, desserts, commentaire, prixTotalCommande, horraireCommande, dateCommande FROM commandes WHERE estFinie = 1 ORDER BY dateCommande DESC;";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            nomCli.add(row[0].toString());
            pizza.add(row[1].toString());
            wrap.add(row[2].toString());
            boisson.add(row[3].toString());
            dessert.add(row[4].toString());
            commentaire.add(row[5].toString());
            prixCommande.add(row[6].toString());
            hCommande.add(row[7].toString());
            dateCommande.add(row[8].toString());
          }


          this.nomCli = nomCli;
          this.pizza = pizza;
          this.wrap = wrap;
          this.boisson = boisson;
          this.dessert = dessert;
          this.commentaire = commentaire;
          this.hCommande = hCommande;
          this.prixCommande = prixCommande;
          this.dateCommande = dateCommande;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void getCommande2() async {
    try {
      var db = new Mysql();
      List<String> nomCli2 = [];
      List<String> pizza2 = [];
      List<String> wrap2 = [];
      List<String> boisson2 = [];
      List<String> dessert2 = [];
      List<String> commentaire2 = [];
      List<String> prixCommande2 = [];
      List<String> hCommande2 = [];
      List<String> id2 = [];


      await db.getConnection().then((conn) {
        String sql =
            "SELECT id, nomClient, pizza, wrap, boissons, desserts, commentaire, prixTotalCommande, horraireCommande, dateCommande FROM commandes WHERE enAttente = 1 ORDER BY dateCommande DESC;";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            id2.add(row[0].toString());
            nomCli2.add(row[1].toString());
            pizza2.add(row[2].toString());
            wrap2.add(row[3].toString());
            boisson2.add(row[4].toString());
            dessert2.add(row[5].toString());
            commentaire2.add(row[6].toString());
            prixCommande2.add(row[7].toString());
            hCommande2.add(row[8].toString());

          }


          this.nomCli2 = nomCli2;
          this.pizza2 = pizza2;
          this.wrap2 = wrap2;
          this.boisson2 = boisson2;
          this.dessert2 = dessert2;
          this.commentaire2 = commentaire2;
          this.hCommande2 = hCommande2;
          this.prixCommande2 = prixCommande2;
          this.id2 = id2;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void getCommande3() async {
    try {
      var db = new Mysql();
      List<String> nomCli3 = [];
      List<String> pizza3 = [];
      List<String> wrap3 = [];
      List<String> boisson3 = [];
      List<String> dessert3 = [];
      List<String> commentaire3 = [];
      List<String> prixCommande3 = [];
      List<String> hCommande3 = [];
      List<String> id3 = [];


      await db.getConnection().then((conn) {
        String sql =
            "SELECT id, nomClient, pizza, wrap, boissons, desserts, commentaire, prixTotalCommande, horraireCommande, dateCommande FROM commandes WHERE enCours = 1 ORDER BY dateCommande DESC;";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            id3.add(row[0].toString());
            nomCli3.add(row[1].toString());
            pizza3.add(row[2].toString());
            wrap3.add(row[3].toString());
            boisson3.add(row[4].toString());
            dessert3.add(row[5].toString());
            commentaire3.add(row[6].toString());
            prixCommande3.add(row[7].toString());
            hCommande3.add(row[8].toString());

          }


          this.nomCli3 = nomCli3;
          this.pizza3 = pizza3;
          this.wrap3 = wrap3;
          this.boisson3 = boisson3;
          this.dessert3 = dessert3;
          this.commentaire3 = commentaire3;
          this.hCommande3 = hCommande3;
          this.prixCommande3 = prixCommande3;
          this.id3 = id3;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void getCommande5() async {
    try {
      var db = new Mysql();
      List<String> nomCli5 = [];
      List<String> pizza5 = [];
      List<String> wrap5 = [];
      List<String> boisson5 = [];
      List<String> dessert5 = [];
      List<String> commentaire5 = [];
      List<String> prixCommande5 = [];
      List<String> hCommande5 = [];
      List<String> id5 = [];


      await db.getConnection().then((conn) {
        String sql =
            "SELECT id, nomClient, pizza, wrap, boissons, desserts, commentaire, prixTotalCommande, horraireCommande, dateCommande FROM commandes WHERE refusDef = 1 ORDER BY dateCommande DESC;";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            id5.add(row[0].toString());
            nomCli5.add(row[1].toString());
            pizza5.add(row[2].toString());
            wrap5.add(row[3].toString());
            boisson5.add(row[4].toString());
            dessert5.add(row[5].toString());
            commentaire5.add(row[6].toString());
            prixCommande5.add(row[7].toString());
            hCommande5.add(row[8].toString());

          }


          this.nomCli5 = nomCli5;
          this.pizza5 = pizza5;
          this.wrap5 = wrap5;
          this.boisson5 = boisson5;
          this.dessert5 = dessert5;
          this.commentaire5 = commentaire5;
          this.hCommande5 = hCommande5;
          this.prixCommande5 = prixCommande5;
          this.id5 = id5;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  Future<List<List<String>>> getCommandeClient() async {
    try {
      var db = new Mysql();

      List<String> pizza4 = [];
      List<String> wrap4 = [];
      List<String> boisson4 = [];
      List<String> dessert4 = [];
      List<String> commentaire4 = [];
      List<String> prixCommande4 = [];
      List<String> hCommande4 = [];
      List<String> id4 = [];
      List<String> delayCom = [];


      await db.getConnection().then((conn) {
        getClient();
        print(prenom2);
        print(nom2);
        String sql =
            "SELECT id, pizza, wrap, boissons, desserts, commentaire, prixTotalCommande, horraireCommande, delayCommande FROM commandes WHERE enCours = 1 AND nomClient = '$prenom2 $nom2' ORDER BY dateCommande DESC;";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            id4.add(row[0].toString());
            pizza4.add(row[1].toString());
            wrap4.add(row[2].toString());
            boisson4.add(row[3].toString());
            dessert4.add(row[4].toString());
            commentaire4.add(row[5].toString());
            prixCommande4.add(row[6].toString());
            hCommande4.add(row[7].toString());
            delayCom.add(row[8].toString());

          }


          this.pizza4 = pizza4;
          this.wrap4 = wrap4;
          this.boisson4 = boisson4;
          this.dessert4 = dessert4;
          this.commentaire4 = commentaire4;
          this.hCommande4 = hCommande4;
          this.prixCommande4 = prixCommande4;
          this.id4 = id4;
          this.delayCom = delayCom;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
    return [id4, pizza4, wrap4, boisson4, dessert4, commentaire4, prixCommande4, hCommande4, delayCom];
  }

  void getCommentaireAdminAClient() async {
    try {
      var db = new Mysql();
      String commentaireAdmin4 = "";
      await db.getConnection().then((conn) {
        getClient();
        print(prenom2);
        print(nom2);
        String sql =
            "SELECT commentaireAdmin FROM commandes WHERE refusDef = 1 AND nomClient = '$prenom2 $nom2' AND DATE(dateCommande) = CURRENT_DATE ORDER BY dateCommande DESC;";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            commentaireAdmin4 = row[0].toString();
          }
          this.commentaireAdmin4 = commentaireAdmin4;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void getCommandeClient2() async {
    try {
      var db = new Mysql();

      List<String> id6 = [];
      List<String> pizza6 = [];
      List<String> wrap6 = [];
      List<String> boisson6 = [];
      List<String> dessert6 = [];
      List<String> commentaire6 = [];
      List<String> prixCommande6 = [];
      List<String> hCommande6 = [];
      List<String> dateCommande6 = [];


      await Future.delayed(Duration(
          seconds:
          2));


      await db.getConnection().then((conn) {
        getClient();
        print(prenom2);
        print(nom2);
        String sql =
            "SELECT id, pizza, wrap, boissons, desserts, commentaire, prixTotalCommande, horraireCommande, dateCommande FROM commandes WHERE estFinie = 1 AND nomClient = '$prenom2 $nom2' ORDER BY dateCommande DESC;";

        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            id6.add(row[0].toString());
            pizza6.add(row[1].toString());
            wrap6.add(row[2].toString());
            boisson6.add(row[3].toString());
            dessert6.add(row[4].toString());
            commentaire6.add(row[5].toString());
            prixCommande6.add(row[6].toString());
            hCommande6.add(row[7].toString());
            dateCommande6.add(row[8].toString());
          }

          this.id6 = id6;
          this.pizza6 = pizza6;
          this.wrap6 = wrap6;
          this.boisson6 = boisson6;
          this.dessert6 = dessert6;
          this.commentaire6 = commentaire6;
          this.hCommande6 = hCommande6;
          this.prixCommande6 = prixCommande6;
          this.dateCommande6 = dateCommande6;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  Future<List<List<String>>> getCommandeClient7(mailCommande2) async {
    try {
      var db = new Mysql();

      List<String> id7 = [];
      List<String> pizza7 = [];
      List<String> wrap7 = [];
      List<String> boisson7 = [];
      List<String> dessert7 = [];
      List<String> commentaire7 = [];
      List<String> prixCommande7 = [];
      List<String> hCommande7 = [];
      List<String> dateCommande7 = [];


      await db.getConnection().then((conn) {
        getClient2(mailCommande2);
        print(prenom2);
        print(nom2);
        String sql =
            "SELECT id, pizza, wrap, boissons, desserts, commentaire, prixTotalCommande, horraireCommande, dateCommande FROM commandes WHERE estFinie = 1 AND nomClient = '$prenom2 $nom2' ORDER BY dateCommande DESC;";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            id7.add(row[0].toString());
            pizza7.add(row[1].toString());
            wrap7.add(row[2].toString());
            boisson7.add(row[3].toString());
            dessert7.add(row[4].toString());
            commentaire7.add(row[5].toString());
            prixCommande7.add(row[6].toString());
            hCommande7.add(row[7].toString());
            dateCommande7.add(row[8].toString());
          }

          this.id7 = id7;
          this.pizza7 = pizza7;
          this.wrap7 = wrap7;
          this.boisson7 = boisson7;
          this.dessert7 = dessert7;
          this.commentaire7 = commentaire7;
          this.hCommande7 = hCommande7;
          this.prixCommande7 = prixCommande7;
          this.dateCommande7 = dateCommande7;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
    return [id7, pizza7, wrap7, boisson7, dessert7, commentaire7, hCommande7, prixCommande7,dateCommande7];
  }

  Future<String?> getCommandeClientEnCours() async {
    try {
      var db = new Mysql();

      int commandeEnCours = 0;
      int commandeEnAttente = 0;

      await db.getConnection().then((conn) {
        getClient();
        print(prenom2);
        print(nom2);
        String sql =
            "SELECT enAttente FROM commandes WHERE nomClient = '$prenom2 $nom2';";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            commandeEnAttente= row[0];
          }

          this.commandeEnAttente = commandeEnAttente;
          notifyListeners();
          conn.close();
          return commandeEnAttente;
        });

        String sql2 =
            "SELECT enCours FROM commandes WHERE nomClient = '$prenom2 $nom2';";
        conn.query(sql2).then((resultats) {
          for (var row in resultats) {
            commandeEnCours = row[0];
          }

          this.commandeEnCours = commandeEnCours;
          notifyListeners();
          conn.close();
          return commandeEnCours ;
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void getDelayCommandeClient() async {
    try {
      var db = new Mysql();

      List<String> delayCom = [];

      await db.getConnection().then((conn) {
        getClient();
        print(prenom2);
        print(nom2);
        String sql =
            "SELECT delayCommande FROM commandes WHERE enCours = 1 AND nomClient = '$prenom2 $nom2' ORDER BY dateCommande DESC;";
        conn.query(sql).then((resultats) {
          for (var row in resultats) {
            delayCom.add(row[0].toString());

          }


          this.delayCom = delayCom;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void estRefuser(idCom) async {
    try {
      var db = new Mysql();
      String sql =
      //METTRE UNE REQUETE QUI AGIT AVEC L'ID !!!!
          "UPDATE commandes SET refusDef = true WHERE id = '$idCom';";
      String sql2 =
          "UPDATE commandes SET enAttente = false WHERE id = '$idCom';";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.query(sql2);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void estRepondu() async {
    try {
      var db = new Mysql();
      getClient();
      print(prenom2);
      print(nom2);
      String sql =
      //METTRE UNE REQUETE QUI AGIT AVEC L'ID !!!!
          "UPDATE commandes SET reponseComAdmin = true WHERE refusDef = 1 AND nomClient = '$prenom2 $nom2' AND DATE(dateCommande) = CURRENT_DATE ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void estRefusDef() async {
    try {
      var db = new Mysql();
      getClient();
      print(prenom2);
      print(nom2);
      String sql =
      //METTRE UNE REQUETE QUI AGIT AVEC L'ID !!!!
          "UPDATE commandes SET reponseDefUser = true WHERE refusDef = 1 AND nomClient = '$prenom2 $nom2' AND DATE(dateCommande) = CURRENT_DATE ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void estValider(idCom) async {
    try {
      var db = new Mysql();
      String sql =
          "UPDATE commandes SET enCours = true WHERE id = '$idCom';";
      String sql2 =
          "UPDATE commandes SET enAttente = false WHERE id = '$idCom';";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.query(sql2);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  Future<void> updatePass(String mailVerifier, String newPass) async {
    try {
      var db = new Mysql();
      String sql =
      //METTRE UNE REQUETE QUI AGIT AVEC L'ID !!!!
          "UPDATE user SET password = '$newPass' WHERE mail = '$mailVerifier';";
      await db.getConnection().then((conn) async {
        await conn.query(sql);
        await conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void horraireValider(idCom,horraireValid) async {
    try {
      var db = new Mysql();
      String sql =
          "UPDATE commandes SET delayCommande = '$horraireValid' WHERE id = '$idCom';";

      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }
  void estFinie(idCom) async {
    try {
      var db = new Mysql();
      String sql =
          "UPDATE commandes SET enCours = false WHERE id = '$idCom';";
      String sql2 =
          "UPDATE commandes SET estFinie = true  WHERE id = '$idCom';";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.query(sql2);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void estBascule(idCom) async {
    try {
      var db = new Mysql();
      String sql =
          "UPDATE commandes SET refusDef = false WHERE id = '$idCom';";
      String sql2 =
          "UPDATE commandes SET enCours = true  WHERE id = '$idCom';";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.query(sql2);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void addComAdmin(com, idCom) async {
    try{
      var db = new Mysql();
      String sql = "UPDATE commandes SET commentaireAdmin = '$com' WHERE id = '$idCom'";
      await db.getConnection().then((conn){
        conn.query(sql);
        conn.close();
      });
    }catch(e){
      print("Une erreur est survenue : $e");
    }
  }

  void ingredyFalse() async {
    try {
      var db = new Mysql();
      String sql = "UPDATE ingredy SET empty = false ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void ingredyTrue(index) async {
    try {
      var db = new Mysql();
      String sql = "UPDATE ingredy SET empty = true WHERE id = $index+1 ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void creneauFalse() async {
    try {
      var db = new Mysql();
      String sql = "UPDATE creneau SET vide = false ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }
  void creneauFalseAt(index) async {
    try {
      var db = new Mysql();
      String sql = "UPDATE creneau SET vide = false WHERE id = $index+1 ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void creneauTrue(index) async {
    try {
      var db = new Mysql();
      String sql = "UPDATE creneau SET vide = true WHERE id = $index+1 ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void getEmploye() async {}

  void addFidelite(amountTot) async {
    try{
      var db = new Mysql();

      await db.getConnection().then((conn)async{
        getIdCred();
        if (id != null) {
          String sql =
              "UPDATE user SET fidelite = fidelite+$amountTot WHERE id = $id;";
          conn.query(sql);
        }
      });
    }catch(e){
      print("Une erreur est survenue : $e");
    }
  }

  void addFideliteForAdmin(mailForAdmin, pointAdd) async {
    try{
      var db = new Mysql();

      await db.getConnection().then((conn)async{
          String sql =
              "UPDATE user SET fidelite = fidelite+$pointAdd WHERE mail = '$mailForAdmin';";
          conn.query(sql);
      });
    }catch(e){
      print("Une erreur est survenue : $e");
    }
  }

  void delFidelite() async {
    try{
      var db = new Mysql();

      await db.getConnection().then((conn)async{
        getIdCred();
        if (id != null) {
          String sql =
              "UPDATE user SET fidelite = fidelite-110 WHERE id = $id;";
          conn.query(sql);
        }
      });
    }catch(e){
      print("Une erreur est survenue : $e");
    }
  }

  int calculatePoints(double amount) {
    return (amount ~/ 10) * 10;
  }

  void addVerif(mailProv, codeProv) async {
    try {
      var db = new Mysql();
      await db.getConnection().then((conn) {
        String sql =
            "INSERT INTO verif (emailProv, codeProv) VALUES ('$mailProv','$codeProv');";
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Erreur de connexion à la base de donnée: $e");
    }
  }

  Future<bool> getUser(String mailV, String mdpC) async {
    try {
      var db = new Mysql();
      var pass = "";
      bool resultat = false;
      await db.getConnection().then((conn) async {
        String sql = "SELECT password FROM user WHERE mail = '$mailV';";
        return await conn.query(sql).then((results) {
          for (var row in results) {
            pass = row[0];
            if (pass == mdpC) {
              resultat = true;
            } else {
              resultat = false;
            }
          }
          this.pass = pass;
          conn.close();
        });
      });
      this.resultat = resultat;
      notifyListeners();
      return resultat;
    } catch (e) {
      print("Erreur de connexion à la base de donnée: $e");
      return false;
    }
  }


  Future<bool> getUserBoss(String mailV, String mdpC) async {
    try {
      var db = new Mysql();
      var pass = "";
      bool resultatBoss = false;
      await db.getConnection().then((conn) {
        String sql = "SELECT passwordEmploye FROM employe WHERE mailEmploye = '$mailV';";
        return conn.query(sql).then((results) {
          for (var row in results) {
            pass = row[0];
            if (pass == mdpC) {
              resultatBoss = true;
            } else {
              resultatBoss = false;
            }
          }
          this.resultatBoss = resultatBoss;
          this.pass = pass;
          notifyListeners();
          conn.close();
        });
      });
      return resultatBoss;
    } catch (e) {
      print("Erreur de connexion à la base de donnée: $e");
      return false;
    }
  }

  void getUser2() async {
    try {
      var db = new Mysql();
      List<dynamic> user = [];
      List<dynamic> userRouge = [];
      await db.getConnection().then((conn) async {
        String sql = "SELECT mail FROM user;";
        await conn.query(sql).then((results) {
          for (var row in results) {
            user.add(row[0].toString());
            //print(user);
          }
          this.user = user;
          notifyListeners();
        });
        String sql2 = "SELECT mail FROM user WHERE estBanni = 1;";
        await conn.query(sql2).then((resultat){
          for(var row2 in resultat){
            userRouge.add(row2[0]);
           print(userRouge);
          }
          this.userRouge = userRouge;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Erreur de connexion à la base de donnée: $e");
    }
  }

  Future<String?> getId(String mailV) async {
    try {
      var db = new Mysql();
      int IdDevResult = 0;
      await db.getConnection().then((conn) async {
        String sql = "SELECT id FROM user WHERE mail = '$mailV';";
        await conn.query(sql).then((results) {
          for (var row in results) {
            IdDevResult = row[0];
          }
          print(IdDevResult);
          idDevResult = IdDevResult;
          notifyListeners();
          return IdDevResult;
        });
        conn.close();
      });
    } catch (e) {
      print("Erreur de connexion à la base de donnée: $e");
    }
  }

  Future<String?> getFidelite() async {
    try{
      var db = new Mysql();
      int points = 0 ;

     await db.getConnection().then((conn){
        String sql = "SELECT fidelite FROM user WHERE id = $id;";
        conn.query(sql).then((results){
          for(var row in results){
            points = row[0];
          }
          this.points = points;
          notifyListeners();
          conn.close();
          return points;
        });
      });
    }catch(e){
      print("Une erreur est survenue : $e");
    }
  }

  Future<String?> getFideliteForAdmin(mailForAdmin) async {
    try{
      var db = new Mysql();
      int pointsForAmdin = 0 ;

      await db.getConnection().then((conn){
        String sql = "SELECT fidelite FROM user WHERE mail = '$mailForAdmin';";
        conn.query(sql).then((results){
          for(var row in results){
            pointsForAmdin = row[0];
            print(pointsForAmdin);
          }
          this.pointsForAmdin = pointsForAmdin;
          notifyListeners();
          conn.close();
          return pointsForAmdin;
        });
      });
    }catch(e){
      print("Une erreur est survenue : $e");
    }
  }

  void getPizza() async {}

  void getDrink() async {}

  void getDessert() async {}

  void getLike() async {}

  Future<void> getCodeProvisoire(emailProv) async {
    try {
      var db = new Mysql();
      var codeProv = "";
      await db.getConnection().then((conn) {
        String sql =
            "select codeProv from verif where emailProv = '${emailProv.toString()}';";
        conn.query(sql).then((results) {
          for (var row in results) {
            codeProv = row[0];
          }
          this.codeProv = codeProv;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Erreur de connexion à la base de donnée: $e");
    }
  }

  void blockUser(mailBlock) async {
    try {
      var db = new Mysql();
      String sql = "UPDATE user SET estBanni = true WHERE mail = '$mailBlock' ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  //fonction pour que Les administrateur debloque une personne
  void unblockUser(mailBlock) async {
    try {
      var db = new Mysql();
      String sql = "UPDATE user SET estBanni = false WHERE mail = '$mailBlock' ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  Future<String?> verifBloc() async {
    try {
      var db = new Mysql();
      String mailVerifBloc = "";
      int mailVerifBlock = 0;

      await db.getConnection().then((conn) async {
        getIdCred();
        if (id != null) {
          var results =
          await conn.query("SELECT mail FROM user WHERE id = $id;");
          for (var row in results) {
            mailVerifBloc = row[0].toString();

            print(mailVerifBloc);
          }
        }
        String sql2 = "SELECT estBanni FROM user WHERE mail = '$mailVerifBloc';";
        conn.query(sql2).then((resultat){
          for(var row2 in resultat){
            mailVerifBlock = row2[0];
          }
          this.mailVerifBlock=mailVerifBlock;
          notifyListeners();
          return mailVerifBlock;
        });
        conn.close();
      });

    } catch (e) {
      print("une erreur est survenue : $e");
      rethrow;
    }
  }


  void getMail() async {
    try {
      var db = new Mysql();
      var email = "";
      await db.getConnection().then((conn) {
        String sql = 'select mail from user;';
        conn.query(sql).then((results) {
          for (var row in results) {
            email = row[0];
          }
          this.email = email;
          notifyListeners();
          conn.close();
        });
      });
    } catch (e) {
      print("Erreur de connexion à la base de donnée: $e");
    }
  }

  void locationFalse() async {
    try {
      var db = new Mysql();
      String sql = "UPDATE location SET est = false ;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  void locationTrue(index) async {
    try {
      var db = new Mysql();
      String sql =
          "UPDATE location SET est = true WHERE id = $index+1 LIMIT 1;";
      await db.getConnection().then((conn) {
        conn.query(sql);
        conn.close();
      });
    } catch (e) {
      print("Une erreur est survenue : $e");
    }
  }

  Future<String?> getLocation() async {
    try {
      var db = new Mysql();
      var loc = "";
      String sql = "SELECT nom FROM location WHERE est = 1 ;";
      await db.getConnection().then((conn) {
        conn.query(sql).then((resultat) {
          for (var row in resultat) {
            loc = row[0].toString();
          }
          this.loc = loc;
          notifyListeners();
          conn.close();
          return loc;
        });
      });
    } catch (e) {
      print("Une erreur est survenu : $e");
    }
  }

  Future<String?> getLocationId() async {
    try {
      var db = new Mysql();
      var locId = "";
      String sql = "SELECT id FROM location WHERE est = 1 ;";
      await db.getConnection().then((conn) {
        conn.query(sql).then((resultat) {
          for (var row in resultat) {
            locId = row[0].toString();
          }
          this.locId = locId;
          notifyListeners();
          conn.close();
          return locId;
        });
      });
    } catch (e) {
      print("Une erreur est survenu : $e");
    }
    print(locId);
  }

  Future<String> generatorCode() async {
    var code = '';
    var random = new Random();
    for (var i = 0; i < 4; i++) {
      code += random.nextInt(10).toString();
    }
    print(code);
    this.code = code;
    notifyListeners();
    return code;
  }
}
