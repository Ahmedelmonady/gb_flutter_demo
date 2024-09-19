import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gameball_sdk/gameball_sdk.dart';
import 'package:gameball_sdk/models/requests/event.dart';
import 'package:gameball_sdk/models/requests/player_attributes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gameball SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gameball SDK Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GameballApp gameballApp = GameballApp.getInstance();

  Future<void> _testGameball() async {
    // Uncomment this line after adding your own firebase configuration
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((response){});
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    gameballApp.init("<apikey>", "<lang>", null, null);
    String playerUniqueId = "<playerUniqueId>";
    setState(() {

      playerRegistrationCallback(response, error) {
        if(error == null && response != null){
          gameballApp.showProfile(context, playerUniqueId, "<openDetail>", false);
        }
        else{
          // TODO Handle failure Scenario
        }
      }

      PlayerAttributes playerAttributes = PlayerAttributes(
          displayName: "John Doe",
          firstName: "John",
          lastName: "Doe",
          mobileNumber: "0123456789",
          preferredLanguage: "en",
          email: 'player@example.com',
          customAttributes: {
            "{key1}": "{value1}"
          }
      );

      gameballApp.registerPlayer(
          playerUniqueId,
          "{playerEmail}",
          "{playerMobile}",
          playerAttributes,
          playerRegistrationCallback);

      sendEventCallback(response, error) {
        if(error == null && response != null){
          // TODO Handle success Scenario
        }
        else{
          // TODO Handle failure Scenario
        }
      }

      Event event = Event(
        events: {
          'purchase': {
            'itemId': '12345',
            'amount': 50.0,
            'currency': 'USD'
          },
          'login': {
            'device': 'iPhone',
            'location': 'USA'
          },
        },
        playerUniqueId: playerUniqueId,
        mobileNumber: '1234567890',
        email: 'player@example.com',
      );

      gameballApp.sendEvent(event, sendEventCallback);
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Gameball Demo',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'Click the FAB below',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _testGameball,
        tooltip: 'Try Gameball',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
