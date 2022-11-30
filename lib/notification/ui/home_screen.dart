import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String createNotification() {
    return '''
      mutation CreateNotification {
        createNotification(input: {
          title
          type
          description
          userID
          imageURL
          paymentID
          orderID
          returnRequestID
        }) {
          id
        }
      }
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final httpLink = HttpLink('http://172.105.125.149:8090/query');
    final client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      ),
    );
    return GraphQLProvider(
        client: client,
        child: CacheProvider(
            child: Column(
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Order'),
                    ),
                  ),
                ),
              ],
            )));
  }
}
