import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendNotification(String employeeToken) async {
  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAA0jdbgQ4:APA91bE6t9WZltAcwMlYUTAOPn9KczsDBm0SbOk3kpeSaUtg44zlXL40QdC7MjuRbXWsZP-MJIScnqsEmUB2KXDilfDLisrKFqFNCb4hIUu2inEqQh3MJ4XOo8pqHibhvwn6GoGJlZAo',
    },
    body: jsonEncode({
      'to': employeeToken,
      'notification': {
        'body': 'Nouvelle commande!',
        'title': 'Nouvelle commande reçue',
        'sound': 'default', // ou vous pouvez spécifier le nom du fichier son, par exemple, 'your_custom_sound.mp3'
      },
      'data': {
        // Données supplémentaires que vous pouvez envoyer avec la notification
      },
    }),
  );

  if (response.statusCode == 200) {
    print('Notification envoyée avec succès');
  } else {
    print('Échec de l\'envoi de la notification: ${response.statusCode}');
  }
}

Future<void> sendNotificationCommandeAccepter(String employeeToken) async {
  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAA0jdbgQ4:APA91bE6t9WZltAcwMlYUTAOPn9KczsDBm0SbOk3kpeSaUtg44zlXL40QdC7MjuRbXWsZP-MJIScnqsEmUB2KXDilfDLisrKFqFNCb4hIUu2inEqQh3MJ4XOo8pqHibhvwn6GoGJlZAo',
    },
    body: jsonEncode({
      'to': employeeToken,
      'notification': {
        'body': "Votre Commande à été accepté et est actuellement en train d'être préparé",
        'title': "Votre Commande à été accepté!",
        'sound': 'default', // ou vous pouvez spécifier le nom du fichier son, par exemple, 'your_custom_sound.mp3'
      },
      'data': {
        // Données supplémentaires que vous pouvez envoyer avec la notification
      },
    }),
  );

  if (response.statusCode == 200) {
    print('Notification envoyée avec succès');
  } else {
    print('Échec de l\'envoi de la notification: ${response.statusCode}');
  }
}

Future<void> sendNotificationCommandeFinie(String employeeToken) async {
  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAA0jdbgQ4:APA91bE6t9WZltAcwMlYUTAOPn9KczsDBm0SbOk3kpeSaUtg44zlXL40QdC7MjuRbXWsZP-MJIScnqsEmUB2KXDilfDLisrKFqFNCb4hIUu2inEqQh3MJ4XOo8pqHibhvwn6GoGJlZAo',
    },
    body: jsonEncode({
      'to': employeeToken,
      'notification': {
        'body': "Votre Commande est prête et vous attend au chaud :)",
        'title': "Votre Commande est prête!",
        'sound': 'default', // ou vous pouvez spécifier le nom du fichier son, par exemple, 'your_custom_sound.mp3'
      },
      'data': {
        // Données supplémentaires que vous pouvez envoyer avec la notification
      },
    }),
  );

  if (response.statusCode == 200) {
    print('Notification envoyée avec succès');
  } else {
    print('Échec de l\'envoi de la notification: ${response.statusCode}');
  }
}