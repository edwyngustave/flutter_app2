import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/verif_info.dart';
import 'package:mailer/smtp_server/gmail.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:http/http.dart' as http;

class InscriptionPage extends StatelessWidget {
  const InscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      "Inscrivez-vous pour commencer",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    //  SvgPicture.asset("asstes/images/ilovepizza.svg")
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InscriptionForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InscriptionForm extends StatefulWidget {
  @override
  State<InscriptionForm> createState() => _InscriptionFormState();
}

class _InscriptionFormState extends State<InscriptionForm> {
  bool emailDejaPris = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //obscurText permet de rendre le text non visible
  var _obsucurTexte = true;

  //_formKey est initialisé en variable globale pour le formulaire
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();

  //les variable de ce type permettent de récupérer les valeurs saisi par l'utilisateur
  TextEditingController _prenom = TextEditingController();
  TextEditingController _nom = TextEditingController();
  TextEditingController _num = TextEditingController();
  TextEditingController _addr = TextEditingController();
  TextEditingController _mail = TextEditingController();
  TextEditingController _mdp = TextEditingController();
  TextEditingController _mdpConf = TextEditingController();

  bool isLoadingInscrip = false;
  String leCode = "";


  @override
  Widget build(BuildContext context) {

    Future<void> ajouterDocument(String emailProv, String codeProv, String collectionName) async {
      try {
        await FirebaseFirestore.instance.collection(collectionName).add({
          'emailProv': emailProv,
          'codeProv': codeProv,
        });

        print('Document ajouté avec succès!');
      } catch (e) {
        print('Erreur lors de l\'ajout du document : $e');
      }
    }

    Future<String> sendMail({
      required String name,
      required String email,
      required String subject,
    }) async {
      var code = await Provider.of<Mysql>(context, listen: false).generatorCode();
      leCode = code.toString();

      final serviceId = 'service_c0xd8ob';
      final templateId = 'template_da15w1m';
      final userId = '3IyY5UwNvmB9ls5Vq';

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_subject': subject,
            'user_message': code,
          }
        }),
      );

      print(response.body);

      return code; // Renvoie le code généré
    }


    //LE consumer permet la reconstruction de la classe mysql
    return Consumer<Mysql>(builder: (context, mysql, child) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              DelayedAnimation(
                  delay: 2500,
                  child: FormBuilderTextField(
                    //on assigne la variable type TextEditindController dans la propiété controller
                    controller: _prenom,
                    name: "prenom",
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Prénom",
                      labelStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    //la propriété validator permet de vérifier chaque champ
                    validator: FormBuilderValidators.required(
                        errorText: "Ce champ doit être rempli"),
                  )),
              SizedBox(
                height: 15,
              ),
              DelayedAnimation(
                  delay: 2500,
                  child: FormBuilderTextField(
                    controller: _nom,
                    name: "nom",
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Nom",
                      labelStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    validator: FormBuilderValidators.required(
                        errorText: "Ce champ doit être rempli"),
                  )),
              SizedBox(
                height: 15,
              ),
              DelayedAnimation(
                  delay: 2500,
                  child: FormBuilderTextField(
                    controller: _num,
                    name: "tel",
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Numéro Tél",
                      labelStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Ce champ doit être rempli"),
                      FormBuilderValidators.minLength(10,
                          errorText: "Numéro de téléphone invalide")
                    ]),
                  )),
              SizedBox(
                height: 15,
              ),
              DelayedAnimation(
                  delay: 2500,
                  child: FormBuilderTextField(
                    controller: _addr,
                    name: "adresse",
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Adresse",
                      labelStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    validator: FormBuilderValidators.required(
                        errorText: "Ce champ doit être rempli"),
                  )),
              SizedBox(
                height: 15,
              ),
              DelayedAnimation(
                  delay: 2500,
                  child: FormBuilderTextField(
                    controller: _mail,
                    name: "email",
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
                height: 15,
              ),
              DelayedAnimation(
                delay: 3000,
                child: FormBuilderTextField(
                    controller: _mdp,
                    name: "mdp",
                    style: TextStyle(color: Colors.white),
                    //obscurText permet de masquer le texte d'un champ. la valeur attribué est
                    // une variable qui a comme valeur un boolean
                    obscureText: _obsucurTexte,
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
                            _obsucurTexte = !_obsucurTexte;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ce champ doit être rempli";
                      }
                      return null;
                    }),
              ),
              SizedBox(
                height: 15,
              ),
              DelayedAnimation(
                delay: 3000,
                child: FormBuilderTextField(
                    controller: _mdpConf,
                    name: "mdpConf",
                    style: TextStyle(color: Colors.white),
                    //obscurText permet de masquer le texte d'un champ. la valeur attribué est
                    // une variable qui a comme valeur un boolean
                    obscureText: _obsucurTexte,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      labelText: "Confirmez votre Mot De Passe",
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility,
                          color: Colors.white24,
                        ),
                        onPressed: () {
                          // seState permet d'actualiser le champ au moment du clic sur l'icone concerné
                          setState(() {
                            _obsucurTexte = !_obsucurTexte;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ce champ doit être rempli";
                      } else if (value != _mdp.text.toString()) {
                        return "Les mots de passes ne sont pas identiques";
                        setState(() {
                          value;
                        });
                      }
                      return null;
                    }),
              ),
              SizedBox(
                height: 15,
              ),
              DelayedAnimation(
                  delay: 5000,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.white24,
                        padding: EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 13,
                        )),
                    onPressed: () async {
                      setState(() async {
                        // valider le formulaire
                        if (_formKey.currentState!.saveAndValidate()) {
                          setState(() {
                            isLoadingInscrip = true;
                          });

                          await Future.delayed(Duration(seconds: 2));

                          setState(() {
                            isLoadingInscrip = false;
                          });

                          try {
                            UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                              email: _mail.text.toString(),
                              password: _mdp.text.toString(),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                  height: 11,
                                  child: Text(
                                    "Cet email existe déjà.",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                              ),
                            );


                          } on FirebaseAuthException catch (e) {

                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');

                            } else {

                              // Si l'utilisateur est créé avec succès, le bloc 'else' doit être exécuté ici
                              // ...
                              String code = await sendMail(
                                name: _prenom.text.toString(),
                                email: _mail.text.toString(),
                                subject: "Vérification",
                              );

                              print(_mail.text.toString());

                              ajouterDocument(_mail.text.toString(), code, "Verif");
// ...


                              print(_mail.text.toString());

                              // afficher un message pour faire patienter l'utilisateur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                    height: 11,
                                    child: Text(
                                      "Passage à l'étape suivante...",
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                              );

                              Timer(
                                Duration(seconds: 1),
                                // navigation vers la page suivante et comme argument de la page suivante on ajoute la variable de type TextEditingController
                                // pour pouvoir récupérer cette variable. il faut que dans la page suivante elle soit déclarée dans le constructeur
                                    () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerifInfoPage(
                                      email: _mail.text,
                                      prenom: _prenom.text,
                                      nom: _nom.text,
                                      numero: _num.text,
                                      addr: _addr.text,
                                      mdpFinal: _mdp.text,
                                    ),
                                  ),
                                ),
                              );

                              // fermer le clavier à la fin de l'inscription
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          } catch (e) {
                            // Gérer d'autres types d'erreurs
                            print("Erreur inattendue : $e");
                          }
                        }
                      });
                    },

                    child: isLoadingInscrip == true
                        ? CircularProgressIndicator()
                        : Text(
                            "SUIVANT",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 9,
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
