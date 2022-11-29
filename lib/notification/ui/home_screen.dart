import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            child: Container(
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                child: Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Order'),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
