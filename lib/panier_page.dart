import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class PanierVar extends ChangeNotifier{

  int _compteurPanier = 0;
  int get compteurPanier => _compteurPanier;
  set compteurPanier(int value) {
    _compteurPanier = value;
    notifyListeners();
  }
  void increment()async{
    _compteurPanier++;
    notifyListeners();
  }

  void decrement()async{
    _compteurPanier--;
    notifyListeners();
  }


  List<Map<String, dynamic>> _selectedPizz = [];
  List<Map<String, dynamic>> get selectedPizz => _selectedPizz;


  void add(Map<String, dynamic> pizza)async {
    _selectedPizz.add(pizza);
  }
  void clearPizz()async {
    _selectedPizz.clear();
  }


  final events = [
    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.47",
      "pizza" : "TOUTE SIMPLE",
      "desc" : "Emmental ou Mozzarella.",
      "prixM": "9",
      "prixL": "13",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "TOAD",
      "desc" : "Champignons de Paris.",
      "prixM": "10",
      "prixL": "14",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "pinky",
      "pizza" : "PINKY",
      "desc" : "Jambon ou Jambon De Dinde*.",
      "prixM": "11",
      "prixL": "15",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.46",
      "pizza" : "KEUCHE",
      "desc" : "Lardons ou Lardons de Volaille*, Oignons Rouges.",
      "prixM": "11",
      "prixL": "15",
      "sauce" : "Crème Fraiche"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "LYAM",
      "desc" : "Merguez*.",
      "prixM": "11",
      "prixL": "15",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "OH LE THON !",
      "desc" : "Thon.",
      "prixM": "11",
      "prixL": "15",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "NOHAM",
      "desc" : "Viande De Boeuf Hachée*, Oignons Rouges.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.46",
      "pizza" : "VIVALDI",
      "desc" : "Jambon ou Jambon De Dinde*, Artichauts.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "GUEZ MERE",
      "desc" : "Merguez*, Poivrons, Oeuf.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.46",
      "pizza" : "CÉSAR",
      "desc" : "Poulet*, Champignons De Paris.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Crème Fraiche"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.46",
      "pizza" : "4 CHEESE",
      "desc" : "Emmental, Chèvre, Roquefort, Mozzarella.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Crème Fraiche"
    },


    {
      "logo": "queenmom",
      "pizza" : "QUEEN MOM",
      "desc" : "Jambon ou Jambon De Dinde*, Chorizo ou Chorizo De Boeuf*.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.47",
      "pizza" : "BEEF",
      "desc" : "Viande de boeuf hachée*, Poivrons, Oignons Rouges.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "farmer",
      "pizza" : "FARMER",
      "desc" : "Chèvre, Jambon ou Jambon De Dinde*.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "CHEESE ROYALE",
      "desc" : "Jambon ou Jambon De Dinde*, Champignons.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "veggie",
      "pizza" : "VEGGIE",
      "desc" : "Champignons De Paris, Poivrons, Oignons Rouges, Oeuf.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },

    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "ALHOA",
      "desc" : "Poulet*, Ananas.",
      "prixM": "12",
      "prixL": "16",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "CHEESE SUPER ROYALE",
      "desc" : "Emmental, Mozzarella, Jambon ou Jambon de Dinde*, Poulet*, Champignons de Paris.",
      "prixM": "13",
      "prixL": "17",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.45",
      "pizza" : "PERNO",
      "desc" : "Thon, Merguez*, Persillade.",
      "prixM": "13",
      "prixL": "17",
      "sauce" : "Sauce Tomate Maison"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.46",
      "pizza" : "RACLETTE PARTY",
      "desc" : "Raclette, Poulet*, Pomme De Terre.",
      "prixM": "13",
      "prixL": "17",
      "sauce" : "Crème Fraiche"
    },


    {
      "logo": "WhatsApp Image 2023-01-05 at 11.31.46",
      "pizza" : "SCANDY",
      "desc" : "Saumon, Persillade.",
      "prixM": "13",
      "prixL": "17",
      "sauce" : "Crème Fraiche"
    },
  ];

  List<Map<String, dynamic>> get getEvents {
    return events;
  }


  final sauces = ['Sauce Tomate Maison','Crème fraiche',
    'Mayonnaise','Samouraï','Ketchup','Algérienne','Biggy','Barbecue'];

  List<String> get getSauces {
    return sauces;
  }

  final garnitures = ['Jambon','Jambon De Dinde','Poulet','Merguez',
    'Chorizo','Chorizo De Boeuf','Lardons','Lardons De Volailles',''
        'Thon','Saumon','Anchois'];

  List<String> get getGarnitures {
    return garnitures;
  }

  final accompagnements = ['Pomme De Terre', 'Champignons', 'Artichauts',
    'Oignons Rouges','Poivrons','Ananas','Olives Noires','Persillade'];

  List<String> get getAccompagnements {
    return accompagnements;
  }

  final fromages = ['Emmental', 'Mozzarella','Chèvre','Roquefort','Raclette'];

  List<String> get getFromages {
    return fromages;
  }

  String dessertDuJour = "";
  String dessertDuJour2 = "";
  String dessertDuJour3 = "";

  final boissonsEtDesserts = [
    {"boissons":"Coca-Cola","logoB":"coca-cola-33cl.png","prixB":"2"},
    {"boissons":"Coca-Cola Zero","logoB":"coca-cola-zero.png","prixB":"2"},
    {"boissons":"Oasis Tropical","logoB":"oasis-tropical.png","prixB":"2"},
    {"boissons":"Ice Tea Pêche","logoB":"Fineandza-Ice-Tea.png","prixB":"2"},
    {"boissons":"Perrier","logoB":"perrier.png","prixB":"2"},
    {"boissons":"Eau","logoB":"bouteille-d-eau-cristalline.jpg","prixB":"2"}
  ];

  List<Map<String, dynamic>> get getBoissonsEtDesserts {
    return boissonsEtDesserts;
  }



  List<String> selectedSauces = [];

  List<String> get getSelectedSauces {
    return selectedSauces;
  }

  final ingredy = ['Sauce Tomate Maison','Crème fraiche',
    'Mayonnaise','Samouraï','Ketchup','Algérienne','Biggy','Barbecue','Jambon','Jambon De Dinde','Poulet','Merguez',
    'Chorizo','Chorizo De Boeuf','Lardons','Lardons De Volailles',''
        'Thon','Saumon','Anchois','Pomme De Terre', 'Champignons', 'Artichauts',
    'Oignons Rouges','Poivrons','Ananas','Olives Noires','Persillade','Emmental', 'Mozzarella','Chèvre','Roquefort','Raclette'];

  List<String> get getIngredy {
    return ingredy;
  }

}