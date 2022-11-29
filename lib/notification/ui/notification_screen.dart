import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zlp_poc/notification/ui/widgets/noti_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotiObject> notiList = [];


  String getUserNotifications = '''
query GetUserNotifications {
  GetUserNotifications(userID: 100, currentPage: 1){
    notifications{
      id
      userID
      isRead
      title
      description
      paymentID
      orderID
      createdAt
      updatedAt
      imageURL
      type
      returnRequestID
    }
    paging{
      perPage
      currentPage
      totalItems
      totalPages
      totalItems
    }
  }
}
  ''';

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getUserNotifications),
      ),
      builder: (QueryResult result, {refetch, fetchMore}) {
        debugPrint('===========RESULT========${result.data}');
        if (result.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final repositories = (result.data!["GetUserNotifications"]
            ["notifications"] as List<dynamic>);
        notiList = repositories
            .map(
              (e) => NotiObject(
                notiID: e['id'],
                time: DateTime.fromMillisecondsSinceEpoch(e['createdAt']),
                isRead: e['isRead'] == 'true',
                highlight: e['userID'].toString(),
                itemAmount: 2,
                orderId: e['orderID'],
                title: e['title'],
                notiTypes: getType(e['type']),
                description: e['description'],
              ),
            )
            .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Notification(${notiList.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xff131313),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        const Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff234455),
                          ),
                        ),
                        Container(
                          color: const Color(0xff234455),
                          height: 1,
                          width: 45,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return NotiItem(notiObject: notiList[index]);
                },
                itemCount: notiList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  NotiTypes getType(String type) {
    switch (type) {
      case '':
        return NotiTypes.cancelled;
      default:
        return NotiTypes.create;
    }
  }
}

class NotiObject {
  const NotiObject({
    this.orderId,
    this.highlight,
    this.title,
    this.itemAmount,
    this.time,
    this.isRead,
    this.notiTypes,
    this.description,
    this.notiID,
  });

  final String? title, orderId, highlight, description, notiID;
  final int? itemAmount;
  final DateTime? time;
  final bool? isRead;
  final NotiTypes? notiTypes;
}

enum NotiTypes {
  create,
  cancelled,
}
