import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Pages/event_page.dart';
import 'package:flutter_app2/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../Recipe.dart';
import '../bdd.dart';
import 'delayed_animation.dart';
import 'package:flutter_app2/panier_page.dart';



class DescPizzaPage extends StatefulWidget {
   DescPizzaPage({required this.recipe,required this.ingredientState,required this.indisponibleIngredientsTrouves,}): super();
  final Recipe recipe;
  final IngredientState ingredientState;
  final List<String> indisponibleIngredientsTrouves;



   @override
  State<DescPizzaPage> createState() => _DescPizzaPageState();
}

class _DescPizzaPageState extends State<DescPizzaPage> {

  List<String> indisponibleIngredients = [];
  // Créez une liste pour stocker les types d'ingrédients trouvés.
  String ingredientTypes = "";

  void initState() {
    super.initState();
    fetchIndisponibleData(); // Appel de votre méthode lors de l'initialisation de la page
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

    print(indisponibleIngredients);
  }

  Future<String> getTypesOfIngredients(List<String> ingredients) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference ingredientsCollection = firestore.collection('Ingredients');

    ingredientTypes = "";
    // Parcourez la liste des ingrédients donnée en argument.
    for (String ingredientType in ingredients) {
      // Recherchez l'ingrédient dans la collection Firestore.
      QuerySnapshot querySnapshot = await ingredientsCollection
          .where('nameIngredy', isEqualTo: ingredientType)
          .limit(1) // Vous pouvez ajuster cette limite en fonction de vos besoins.
          .get();

      // Si l'ingrédient est trouvé, ajoutez le type associé à la liste.
      if (querySnapshot.docs.isNotEmpty) {
        ingredientTypes = querySnapshot.docs.first['type'] as String ;
      }
    }
    print(ingredientTypes);
    return ingredientTypes;
  }

   List<String> selectedPizza = [];
   bool _showButtonsPizza = false;
   int selectedPerso = 0;
   bool _hasData = false;
   int selectedTypeIngredient = 0;

   String eventGarnitureIndisponible = "";
   List<String> eventGarnitureIndisponibleList = [];
   String eventAccompIndisponible = "";
   List<String> eventAccompIndisponibleList = [];
   String eventCheeseIndisponible = "";
   List<String> eventCheeseIndisponibleList = [];
   List<String> eventIngredientIndisponible = [];
   List<String> eventPizzaIndisponibleList = [];
   List<String> ingredientCible = [];
   String eventPizzaIndisponible = "";



   bool isLoading = false;

   @override
  Widget build(BuildContext context) {

     var ingredientState = Provider.of<IngredientState>(context);


    Widget titleSection = Container(
      padding: EdgeInsets.all(8),
      child: Row(
          children: [
            Expanded(
              child: Column(
                //aligner le text ou élément
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(widget.recipe.pizza, style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white
                      ),),
                    ),
                  ),
                  Text("", style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      color: Colors.white70
                  ),),
                ],
              ),
            ),
            Icon(Icons.favorite, color: Colors.white,),
            Text("55", style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.white70
            ),)
          ]
      ),
    );

   Widget buttonSection = Consumer<PanierVar>(
     builder: (context, panierV, child) {
       return Container(
         padding: EdgeInsets.all(8),
         child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               InkWell(
                 onTap: () {
                   setState(() {
                     if(ingredientState.selectedIngredientState==true){
                       getTypesOfIngredients(widget.indisponibleIngredientsTrouves);}
                     _showButtonsPizza = !_showButtonsPizza;
                     print(ingredientState.selectedIngredientState);
                   });
                 },
                 child: !_showButtonsPizza
                     ? _buildButtonColumn(
                   Colors.blue, Icons.add, "Ajouter au panier",)
                     : Container(
                     child: Row(
                       children: [
                         InkWell(
                           onTap: (){
                             setState(() {
                               _showButtonsPizza =
                               !_showButtonsPizza!;
                               selectedPerso = 0;
                             });
                           },
                        child: _buildButtonColumn(Colors.blue, Icons.cancel, "",),
                         ),
                         TextButton(
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
                                             fontWeight: FontWeight.w600
                                         )),
                                     content: Text(
                                         "Ajoutez votre pizza au panier ou personnalisez la !",
                                         style: GoogleFonts.poppins(
                                             color: Colors.white
                                         )),
                                     actions: [
                                       ElevatedButton(
                                         child: Text(
                                             "PERSONNALISER", style: GoogleFonts.poppins(
                                             color: Colors.white
                                         )),
                                         onPressed: () {
                                           setState(() {
                                             //ici que se passe la bail de tri
                                             print(ingredientTypes);
                                             selectedPerso = 1;
                                                                                          Navigator.pop(context);
                                           });
                                         },
                                         style: ElevatedButton.styleFrom(
                                             shape: StadiumBorder(),
                                             backgroundColor: Colors.grey[700],
                                             elevation: 20
                                         ),
                                       ),
                                       ElevatedButton(
                                         child: Text(
                                             "AJOUTER", style: GoogleFonts.poppins(
                                             color: ingredientState.selectedIngredientState==true ? Colors.red :Colors.white
                                         )),
                                         onPressed: () {
                                           setState(() {
                                            if(ingredientState.selectedIngredientState==true){
                                              return null;
                                            }else {
                                              panierV.increment();
                                              panierV.selectedPizz.add({
                                                "pizzaM": widget.recipe.pizza,
                                                "prixM": widget.recipe.prixM,
                                                "tailleM": 'MEDIUM'
                                              });
                                              print(panierV.selectedPizz);
                                              _showButtonsPizza =
                                              !_showButtonsPizza!;
                                              Navigator.pop(context);
                                            }
                                           });
                                         },
                                         style: ElevatedButton.styleFrom(
                                             shape: StadiumBorder(),
                                             backgroundColor: Colors.grey[700],
                                             elevation: 20
                                         ),
                                       ),
                                     ],
                                   );
                                 },
                               );
                             });
                           },
                           child: Text("MEDIUM", style: GoogleFonts.poppins(
                               fontSize: 12,
                               fontWeight: FontWeight.bold
                           ),),
                         ),
                         TextButton(
                           onPressed: () {
                             setState(() {
                               print(panierV.selectedPizz);
                               showDialog(
                                 context: context,
                                 builder: (BuildContext context) {
                                   return AlertDialog(
                                     backgroundColor: Colors.grey[850],
                                     title: Text("A table !",
                                         style: GoogleFonts.poppins(
                                             color: Colors.white,
                                             fontWeight: FontWeight.w600
                                         )),
                                     content: Text(
                                         "Ajoutez votre pizza au panier ou personnalisez la !",
                                         style: GoogleFonts.poppins(
                                             color: Colors.white
                                         )),
                                     actions: <Widget>[
                                       ElevatedButton(
                                         child: Text(
                                             "PERSONNALISER", style: GoogleFonts.poppins(
                                             color: Colors.white
                                         )),
                                         onPressed: () {
                                           setState(() {
                                             if(ingredientState.selectedIngredientState==true){
                                             getTypesOfIngredients(widget.indisponibleIngredientsTrouves);}
                                             selectedPerso = 2;
                                             Navigator.pop(context);
                                           });
                                         },
                                         style: ElevatedButton.styleFrom(
                                             shape: StadiumBorder(),
                                             backgroundColor: Colors.grey[700],
                                             elevation: 20
                                         ),
                                       ),
                                       ElevatedButton(
                                         child: Text(
                                             "AJOUTER", style: GoogleFonts.poppins(
                                             color: ingredientState.selectedIngredientState==true ? Colors.red :Colors.white
                                         )),
                                         onPressed: () {
                                           setState(() {
                                             if(ingredientState.selectedIngredientState==true) {
                                               return null;
                                             }
                                             else {
                                               panierV.increment();
                                               panierV.selectedPizz.add({
                                                 "pizzaL": widget.recipe.pizza,
                                                 "prixL": widget.recipe.prixL,
                                                 "tailleL": 'LARGE'
                                               });
                                               print(panierV.selectedPizz);
                                               _showButtonsPizza =
                                               !_showButtonsPizza!;
                                               Navigator.pop(context);
                                             }
                                           });

                                         },
                                         style: ElevatedButton.styleFrom(
                                             shape: StadiumBorder(),
                                             backgroundColor: Colors.grey[700],
                                             elevation: 20
                                         ),
                                       ),
                                     ],
                                   );
                                 },
                               );
                             });
                           },
                           child: Text("LARGE", style: GoogleFonts.poppins(
                               fontSize: 12,
                               fontWeight: FontWeight.bold
                           ),),
                         ),
                       ],
                     )),
               ),
               IconButton(onPressed: (){
                 print(eventPizzaIndisponibleList);
               }, icon: Icon(Icons.account_balance),
               color: Colors.blue,),

             ]
         ),
       );
     }
   );

   Widget descSection =
       Container(
         padding: const EdgeInsets.all(32),
         child: Text(widget.recipe.desc+".", style: GoogleFonts.poppins(
           fontSize: 14,
           fontWeight: FontWeight.w300,
           color: Colors.white
         ),
         //permet de ne pas couper les mots
         softWrap: true,
         ),
       );

   Widget logoPizza =
   Image.asset(
     widget.recipe.logo,
     height: 400,
     width: 600,
     fit: BoxFit.cover,
   );

    Widget ingredientListGarniture = ingredientState.selectedIngredientState==true /*&& selectedTypeIngredient == 1 */? Consumer<PanierVar>(builder: (context, panierV, child) {
      List<bool> _selectedButtons1 =
      List.generate(ingredientTypes == "garnitures" ? panierV.garnitures.length :
      ingredientTypes == "sauces" ?  panierV.sauces.length :
      ingredientTypes == "accompagnements" ? panierV.accompagnements.length :
      ingredientTypes == "fromages" ? panierV.fromages.length :  panierV.garnitures.length, (_) => false);
      double prixSupMedium = double.parse(widget.recipe.prixM);
      double prixSupLarge = double.parse(widget.recipe.prixL);
      return DelayedAnimation(
        delay: 500,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "------------------------------------------",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Remplacer l'ingrédient indisponible :  ",
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
              children: List.generate(ingredientTypes == "garnitures" ? panierV.garnitures.length :
              ingredientTypes == "sauces" ?  panierV.sauces.length :
              ingredientTypes == "accompagnements" ? panierV.accompagnements.length :
              ingredientTypes == "fromages" ? panierV.fromages.length :  panierV.garnitures.length, (index) {
                return TextButton(
                  child: Text(
                    ingredientTypes == "garnitures" ? panierV.garnitures[index] :
                    ingredientTypes == "sauces" ? panierV.sauces[index] :
                    ingredientTypes == "accompagnements" ? panierV.accompagnements[index] :
                    ingredientTypes == "fromages" ? panierV.fromages[index] : panierV.garnitures[index],
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: panierV.selectedSauces
                            .contains(ingredientTypes == "garnitures" ? panierV.garnitures[index] :
                        ingredientTypes == "sauces" ? panierV.sauces[index] :
                        ingredientTypes == "accompagnements" ? panierV.accompagnements[index] :
                        ingredientTypes.toString() == "fromages" ? panierV.fromages[index] : panierV.garnitures[index])
                            ? Colors.white
                            : (indisponibleIngredients != null &&
                            indisponibleIngredients
                                .contains(ingredientTypes == "garnitures" ? panierV.garnitures[index] :
                            ingredientTypes == "sauces" ? panierV.sauces[index] :
                            ingredientTypes == "accompagnements" ? panierV.accompagnements[index] :
                            ingredientTypes.toString() == "fromages" ? panierV.fromages[index] : panierV.garnitures[index]))
                            ? Colors.red
                            : Colors.blue),
                  ),
                  onPressed: () {
                    setState(() {
                      (indisponibleIngredients != null &&
                          indisponibleIngredients
                              .contains(ingredientTypes == "garnitures" ? panierV.garnitures[index] :
                          ingredientTypes == "sauces" ? panierV.sauces[index] :
                          ingredientTypes == "accompagnements" ? panierV.accompagnements[index] :
                          ingredientTypes.toString() == "fromages" ? panierV.fromages[index] : panierV.garnitures[index]))
                          ? null
                          : _selectedButtons1[index] =
                      !_selectedButtons1[index];
                      print(_selectedButtons1);
                    });
                    if (_selectedButtons1[index]) {
                      if (!panierV.selectedSauces
                          .contains(ingredientTypes == "garnitures" ? panierV.garnitures[index] :
                      ingredientTypes == "sauces" ? panierV.sauces[index] :
                      ingredientTypes == "accompagnements" ? panierV.accompagnements[index] :
                      ingredientTypes.toString() == "fromages" ? panierV.fromages[index] : panierV.garnitures[index])) {
                        panierV.selectedSauces.add(ingredientTypes == "garnitures" ? panierV.garnitures[index] :
                        ingredientTypes == "sauces" ? panierV.sauces[index] :
                        ingredientTypes == "accompagnements" ? panierV.accompagnements[index] :
                        ingredientTypes.toString() == "fromages" ? panierV.fromages[index] : panierV.garnitures[index]);
                      } else {
                        panierV.selectedSauces
                            .remove(ingredientTypes == "garnitures" ? panierV.garnitures[index] :
                        ingredientTypes == "sauces" ? panierV.sauces[index] :
                        ingredientTypes == "accompagnements" ? panierV.accompagnements[index] :
                        ingredientTypes.toString() == "fromages" ? panierV.fromages[index] : panierV.garnitures[index]);
                      }
                    }
                    print(panierV.selectedSauces);
                    // Code pour ajouter la sauce au panier
                  },
                  style: TextButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: panierV.selectedSauces
                        .contains(ingredientTypes == "garnitures" ? panierV.garnitures[index] :
                    ingredientTypes == "sauces" ? panierV.sauces[index] :
                    ingredientTypes == "accompagnements" ? panierV.accompagnements[index] :
                    ingredientTypes.toString() == "fromages" ? panierV.fromages[index] : panierV.garnitures[index])
                        ? Colors.grey[600]
                        : Colors.grey[900],
                  ),
                );
              }),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    // Afficher le CircularProgressIndicator pendant un certain temps
                    await Future.delayed(Duration(
                        seconds:
                        2)); // Remplacez 2 par la durée souhaitée en secondes

                    setState(() {
                      if(selectedPerso==1){
                        panierV.increment();
                        if(panierV.selectedSauces.length > 0 && !ingredientState.selectedIngredientState) {
                          prixSupMedium += (panierV.selectedSauces.length - 0) * 1;
                        }else if(panierV.selectedSauces.length > 0 && ingredientState.selectedIngredientState){
                          prixSupMedium += (panierV.selectedSauces.length - 1) * 1;
                        }
                        final selectedSaucesString = panierV.selectedSauces.join(', ');
                        panierV.selectedPizz.add({
                          "pizzaSupMedium": widget.recipe.pizza +" + "+ selectedSaucesString,
                          "prixSupMedium": prixSupMedium.toString(),
                        });
                      }
                      else if(selectedPerso==2){
                        panierV.increment();
                        if(panierV.selectedSauces.length > 0 && !ingredientState.selectedIngredientState) {
                          prixSupLarge += (panierV.selectedSauces.length - 0) * 2;
                        }else if(panierV.selectedSauces.length > 0 && ingredientState.selectedIngredientState){
                          prixSupLarge += (panierV.selectedSauces.length - 1) * 2;
                        }
                        final selectedSaucesString = panierV.selectedSauces.join(', ');
                        panierV.selectedPizz.add({
                          "pizzaSupLarge": widget.recipe.pizza +" + "+ selectedSaucesString,
                          "prixSupLarge": prixSupLarge.toString(),
                        });}
                      print(panierV.selectedSauces);
                      setState(() {
                        isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[850],
                            title: Text(
                                "A table !", style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            )),
                            content: Text(
                                "Votre pizza a bien été ajouté à votre panier",
                                style: GoogleFonts.poppins(
                                    color: Colors.white
                                )),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text(
                                    "OK", style: GoogleFonts.poppins(
                                    color: Colors.white
                                )),
                                onPressed: () {
                                  setState(() {
                                    selectedPerso = 0;
                                    _showButtonsPizza =
                                    !_showButtonsPizza!;
                                    panierV.selectedSauces.clear();
                                    ingredientState.setSelectedIngredientState(false);
                                    Navigator.of(context).pop();
                                    print(panierV.selectedSauces);
                                    print(panierV.selectedPizz);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.grey[700],
                                    elevation: 20
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.grey[900]
                  ),
                  child: isLoading?
                  Container(
                      width: 20,
                      height: 20,
                      child:CircularProgressIndicator()):
                  Text(
                    "AJOUTER AU PANIER " , style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white
                  ),
                  )),
            )
          ],
        ),
      );
    }) : Consumer<PanierVar>(
        builder: (context,panierV,child) {
          List<bool> _selectedButtons = List.generate(panierV.ingredy.length, (_) => false);
          double prixSupMedium = double.parse(widget.recipe.prixM);
          double prixSupLarge = double.parse(widget.recipe.prixL);
          return
            DelayedAnimation(delay: 1000,
              child: Column(
                children: <Widget>[
                  Text(
                    "------------------------------------------",
                    style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Ajouter un ou plusieurs ingrédients à votre pizza : ",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                  ),
                  SizedBox(height: 10,),
                  if(selectedPerso == 1)
                  Text(ingredientState.selectedIngredientState==true? '' : "Les extras 1€/Produit",
                    style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  if(selectedPerso == 2)
                    Text(ingredientState.selectedIngredientState==true? '' :"Les extras 2€/Produit",
                      style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Wrap(
                      spacing: 15,
                      children: List.generate(panierV.ingredy.length, (index) {
                        return TextButton(
                          child: Text(panierV.ingredy[index], style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: panierV.selectedSauces.contains(panierV.ingredy[index])
                                  ? Colors.white
                                  : (indisponibleIngredients != null &&
                                  indisponibleIngredients
                                      .contains(panierV.ingredy[index]))
                                  ? Colors.red
                                  : Colors.blue

                          ),),
                          onPressed: () {
                            setState(() {
                              (indisponibleIngredients != null &&
                                  indisponibleIngredients
                                      .contains(panierV.ingredy[index]))
                                  ? null :
                              _selectedButtons[index] = !_selectedButtons[index];
                              print(_selectedButtons);
                            });
                            if (_selectedButtons[index]) {
                              if (!panierV.selectedSauces.contains(panierV.ingredy[index])) {
                                panierV.selectedSauces.add(panierV.ingredy[index]);
                              } else {
                                panierV.selectedSauces.remove(panierV.ingredy[index]);
                              }
                            }
                            print(panierV.selectedSauces);
                            // Code pour ajouter la sauce au panier
                          },

                          style: TextButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: panierV.selectedSauces.contains(
                                panierV.ingredy[index])
                                ? Colors.grey[600]
                                : Colors.grey[900],
                          ),
                        );
                      }),

                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          // Afficher le CircularProgressIndicator pendant un certain temps
                          await Future.delayed(Duration(
                              seconds:
                              2)); // Remplacez 2 par la durée souhaitée en secondes

                          setState(() {
                        if(selectedPerso==1){
                          panierV.increment();
                          if(panierV.selectedSauces.length > 0 && !ingredientState.selectedIngredientState) {
                            prixSupMedium += (panierV.selectedSauces.length - 0) * 1;
                          }else if(panierV.selectedSauces.length > 0 && ingredientState.selectedIngredientState){
                            prixSupMedium += (panierV.selectedSauces.length - 1) * 1;
                          }
                          final selectedSaucesString = panierV.selectedSauces.join(', ');
                          panierV.selectedPizz.add({
                            "pizzaSupMedium": widget.recipe.pizza +" + "+ selectedSaucesString,
                            "prixSupMedium": prixSupMedium.toString(),
                          });
                        }
                        else if(selectedPerso==2){
                        panierV.increment();
                        if(panierV.selectedSauces.length > 0 && !ingredientState.selectedIngredientState) {
                          prixSupLarge += (panierV.selectedSauces.length - 0) * 2;
                        }else if(panierV.selectedSauces.length > 0 && ingredientState.selectedIngredientState){
                          prixSupLarge += (panierV.selectedSauces.length - 1) * 2;
                        }
                        final selectedSaucesString = panierV.selectedSauces.join(', ');
                        panierV.selectedPizz.add({
                          "pizzaSupLarge": widget.recipe.pizza +" + "+ selectedSaucesString,
                          "prixSupLarge": prixSupLarge.toString(),
                        });}
                        print(panierV.selectedSauces);
                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey[850],
                              title: Text(
                                  "A table !", style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                              )),
                              content: Text(
                                  "Votre pizza a bien été ajouté à votre panier",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white
                                  )),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text(
                                      "OK", style: GoogleFonts.poppins(
                                      color: Colors.white
                                  )),
                                  onPressed: () {
                                    setState(() {
                                      selectedPerso = 0;
                                      _showButtonsPizza =
                                      !_showButtonsPizza!;
                                      panierV.selectedSauces.clear();
                                      ingredientState.setSelectedIngredientState(false);
                                      Navigator.of(context).pop();
                                      print(panierV.selectedSauces);
                                      print(panierV.selectedPizz);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      backgroundColor: Colors.grey[700],
                                      elevation: 20
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      });
                    },
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.grey[900]
                        ),
                        child: isLoading?
                        Container(
                          width: 20,
                            height: 20,
                            child:CircularProgressIndicator()):
                        Text(
                          "AJOUTER AU PANIER " , style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white
                        ),
                        )),
                  )
                ],
              ),
            );
        });

   ////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////
    ////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Descritpion Pizza"),
        //rendre la appBar transparent
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
        //l'icone fleche de retour
        leading: Consumer<PanierVar>(
          builder: (context, panierV, child) { return
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                ingredientTypes = "";
                // rendre le bouton cliquable vers une page
                ingredientState.setSelectedIngredientState(false);
                selectedPerso = 0;
                _showButtonsPizza = false;
                panierV.selectedSauces.clear();
                Navigator.pop(context);
              },
            );
          }
        ),
      ),
      //La ListView permet de ne pas sortir de l'ecran et de renvoyer l'erreur 'RenderFlex'
      body: ListView(
        children: [
          DelayedAnimation(delay: 500, child: logoPizza),
          DelayedAnimation(delay: 1000, child: titleSection),
          DelayedAnimation(delay: 1300, child: buttonSection),
          DelayedAnimation(delay: 1600, child: descSection),
          if(selectedPerso==1 || selectedPerso == 2)
          DelayedAnimation(delay: 1000, child: ingredientListGarniture),
    ]
      ),
    );
  }

  //Méthode pour créer un bouton
  Column _buildButtonColumn(Color color, IconData icon, String label){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Icon(icon, color: color,)),
        Text(label, style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: color
        ),)
      ],
    );
  }
}



