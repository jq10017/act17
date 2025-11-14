import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MessagingTutorial());
}

class MessagingTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Messaging',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Firebase Messaging'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? notificationText;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  print("message received");

  String? body = event.notification?.body;
  String type = event.data['type'] ?? "regular";


  Color bgColor;
  IconData icon;
  String title;

  switch (type) {
    case "important":
      bgColor = Colors.red;
      icon = Icons.warning;
      title = "Important Quote";
      break;

    case "motivational":
      bgColor = Colors.blue;
      icon = Icons.emoji_events;
      title = "Motivational Quote";
      break;

    case "wisdom":
      bgColor = Colors.purple;
      icon = Icons.lightbulb;
      title = "Wisdom Quote";
      break;

    case "success":
      bgColor = Colors.green;
      icon = Icons.check_circle;
      title = "Success Quote";
      break;  

    case "funny":
      bgColor = Colors.orange;
      icon = Icons.sentiment_very_satisfied;
      title = "Funny Quote";
      break;  

    case "love":
      bgColor = Colors.pink;
      icon = Icons.favorite;
      title = "Love Quote";
      break;  

    default:
      bgColor = Colors.grey;
      icon = Icons.message;
      title = "Quote";
      break;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Icon(icon, color: bgColor),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: bgColor,
              ),
            ),
          ],
        ),
        content: Text(
          body ?? "",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: Text("Ok", style: TextStyle(color: bgColor)),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    },
  );
});

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(child: Text("Messaging Tutorial")),
    );
  }
}
