// @dart=2.12
import 'dart:async';
import 'dart:io';
import 'package:flutter_app2/Pages/test_page.dart';
import 'package:flutter_app2/bdd.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'Pages/delayed_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/profil_page.dart';
import 'package:flutter_app2/Pages/event_page.dart';
import 'Pages/home_page.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Pages/welcome_page.dart';
import 'Pages/verif_info.dart';
import 'panier_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() async{

  HttpOverrides.global = new PostHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // Appel de la fonction ici


  final InitializationSettings initializationSettings =
  InitializationSettings(
    android: AndroidInitializationSettings('test'), // Remplacez 'app_icon' par le nom de l'icône de votre application
    iOS: IOSInitializationSettings(),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

  // le runAPP definit la fonction principale que l'on lance
  runApp(SplashScreen());
}

Future<void> onSelectNotification(String? payload) async {
  // Code à exécuter lorsque l'utilisateur appuie sur la notification
  // Vous pouvez ouvrir une page ou effectuer une action spécifique ici
}


//la classe SlashScreen est la classe lié à l'écran de démarrage au lancement de l'application
class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // utilisez un Timer pour charger votre widget principal au bout de 3 secondes
    //Timer(Duration(seconds: 4), () => runApp(MyApp()));

    //le provider pour les states management. (acceder aux methode et variable d'autre page). Dans le main pour que toutes les pages y ai accès
    return MultiProvider(
    providers:[
    ChangeNotifierProvider(
    //provider de la class Mysql.
    create: (context)=>Mysql(),
    ),
    ChangeNotifierProvider(
    //provider de la class Mysql.
    create: (context)=>PanierVar(),
    ),
    ChangeNotifierProvider(
    create: (context) => IngredientState(),
    ),
    ],
    child: MyApp(),

    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key}) : super();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;
  // méthode qui effectue un changement de page
  setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  final storage = FlutterSecureStorage();
  String? storedUsernameMail = "";




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<Mysql>(
        builder: (context, mysql, child) {
          return FutureBuilder<String?>(
            future: storage.read(key: 'usernameMail'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  String? storedUsernameMail = snapshot.data;
                  if (storedUsernameMail == 'ilovepizzatruck@gmail.com') {
                    return TestPage();
                  } else {
                    // Utiliser storedUsernameMail dans la construction de votre widget
                    return Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                          backgroundColor: Colors.black12,
                          //Actualiser le nom de la page dans le scafold
                          title: [
                            Text("Acceuil"),
                            Text("Nos Produits"),
                            Text("Profil")
                          ][_currentIndex],
                        ),
                        // lister les pages dans le body qu'elle puisse etre navigable
                        body: [
                          HomePage(),
                          EventPage(),
                          ProfilPage()
                        ][_currentIndex],
                        //creation de barre de navigation du bas avec plusieurs éléments
                        bottomNavigationBar: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                color: Colors.black.withOpacity(.1),
                              )
                            ],
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 7),
                              child: GNav(
                                rippleColor: Colors.black,
                                hoverColor: Colors.black,
                                tabBorderRadius: 10,
                                gap: 8,
                                activeColor: Colors.white,
                                iconSize: 24,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 15),
                                duration: Duration(milliseconds: 400),
                                tabBackgroundColor: Colors.grey[850]!,
                                color: Colors.white,
                                tabs: const [
                                  GButton(
                                    icon: LineIcons.home,
                                    text: 'Accueil',
                                  ),
                                  GButton(
                                    icon: LineIcons.pizzaSlice,
                                    text: 'Food',
                                  ),
                                  GButton(
                                    icon: LineIcons.user,
                                    text: 'Profil',
                                  ),
                                ],
                                selectedIndex: _currentIndex,
                                onTabChange: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  }
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                    );
                  }
                } else {
                  return WelcomePage();
                }
              } else {
                // Vous pouvez afficher un indicateur de chargement ici si nécessaire
                return CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}


