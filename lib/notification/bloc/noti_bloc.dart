import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../ui/notification_screen.dart';

part 'noti_event.dart';

part 'noti_state.dart';

class NotiBloc extends Bloc<NotiEvent, NotiState> {
  final HttpLink httpLink = HttpLink(
    'http://172.105.125.149:8090/query',
    defaultHeaders: {
      'accept': '*/*',
      'Content-Type': 'application/json;charset=UTF-8',
    },
  );

  NotiBloc() : super(NotiInitial()) {
    on<UpdateNotiStatusEvent>(
      (event, emit) async {
        String changeNotificationStatus = '''
          mutation changeNotificationStatus {
            changeNotificationStatus(notificationID: ${event.notiID})
          }
           ''';

        GraphQLClient client = GraphQLClient(
          link: httpLink,
          // The default store is the InMemoryStore, which does NOT persist to disk
          cache: GraphQLCache(),
        );

        QueryResult queryResult = await client.query(
          QueryOptions(
            document: gql(changeNotificationStatus),
          ),
        );

        if (queryResult.data?['changeNotificationStatus'] == true) {
          emit(UpdateNotiStatusState(isRead: true));
        } else {
          emit(UpdateNotiStatusState(isRead: false));
        }
      },
    );

    on<ClearAllNotiEvent>((event, emit) async {
      String clearAllNoti = '''
          mutation clearAllUserNotification {
            clearAllUserNotification(userID: ${event.userID})
          }
           ''';

      GraphQLClient client = GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(),
      );

      try {
        QueryResult queryResult = await client.query(
          QueryOptions(
            document: gql(clearAllNoti),
          ),
        );
        if (queryResult.data?['clearAllUserNotification'] == true) {
          emit(DeletedAllNotiState());
        }
      } catch (e) {
        print('Error: $e');
      }
    });

    on<GetNotiEvent>(
      (event, emit) async {
        emit(LoadingState());
        String getUserNotifications = '''
        query GetUserNotifications {
          GetUserNotifications(userID: ${event.userID}, currentPage: 1){
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

        GraphQLClient client = GraphQLClient(
          link: httpLink,
          // The default store is the InMemoryStore, which does NOT persist to disk
          cache: GraphQLCache(),
        );

        QueryResult queryResult = await client.query(
          QueryOptions(
            document: gql(getUserNotifications),
          ),
        );

        NotiTypes getType(String type) {
          switch (type) {
            case '':
              return NotiTypes.cancelled;
            default:
              return NotiTypes.create;
          }
        }

        final repositories = (queryResult.data!["GetUserNotifications"]
            ["notifications"] as List<dynamic>);
        List<NotiObject> notiList = repositories
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

        emit(GotNotiState(notiList: notiList));
      },
    );
  }
}
