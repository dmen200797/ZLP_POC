import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zlp_poc/notification/fcm.dart';
import 'package:zlp_poc/notification/local_notification_service.dart';
import 'package:zlp_poc/notification/push_notification.dart';
import 'package:zlp_poc/notification/ui/notification_screen.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.data}");
  LocalNotificationService.instance.display(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Fcm.instance.setUpNotificationBeforeRunApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink('http://172.105.125.149:8090/query', defaultHeaders: {
      'accept': '*/*',
      'Content-Type': 'application/json;charset=UTF-8',
    });

    // final AuthLink authLink = AuthLink(
    //   getToken: () async => 'Bearer',
    //   // OR
    //   // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    // );

    // final Link link = authLink.concat(httpLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ZPL POC',
        home: CacheProvider(child: MyHomePage(title: 'ZPL POC')),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  @override
  void initState() {
    getToken();
    LocalNotificationService.instance.initializeSettings(context);
    afterBuild(() async {
      await PushNotification.instance.requestNotificationPermission();
    });
    super.initState();
  }

  static void afterBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  final List<Widget> widgetOptions = const [
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Product',
    ),
    Text(
      'Index 2: Orders',
    ),
    NotificationScreen(),
    Text(
      'Index 4: Account',
    ),
  ];

  void getToken() async {
    Fcm.instance.showingComingNotification();
    Fcm.instance.listenRemoteMessageOnOpenApp(context);
    Fcm.instance.getInitialMessage(context);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('Token: $fcmToken');
  }

  List<BottomNavigationBarItem> get listBottomItem => [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Product',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: const [
              Icon(Icons.notifications_none),
              Positioned(
                right: 2,
                top: 2,
                child: Visibility(
                  visible: false,
                  child: Icon(
                    Icons.brightness_1,
                    color: Color(0xffE7A546),
                    size: 8,
                  ),
                ),
              )
            ],
          ),
          label: 'Notifications',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Account',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: const Color(0xff234455),
          title: Text(widget.title),
        ),
      ),
      body:
          SafeArea(child: Center(child: widgetOptions.elementAt(currentIndex))),
      bottomNavigationBar: BottomNavigationBar(
        items: listBottomItem,
        currentIndex: currentIndex,
        selectedItemColor: HexColor('#8DAFAA'),
        unselectedItemColor: HexColor('#234455'),
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
