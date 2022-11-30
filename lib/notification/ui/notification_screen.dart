import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zlp_poc/notification/ui/widgets/noti_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/noti_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // List<NotiObject> notiList = [];

  @override
  void initState() {
    context.read<NotiBloc>().add(GetNotiEvent(userID: '100'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotiBloc, NotiState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GotNotiState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Text(
                      'Notification(${state.notiList.length})',
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
                    return NotiItem(
                      notiObject: state.notiList[index],
                      onTap: () {
                        print('index: $index');
                        // context.read<NotiBloc>().add(
                        //       UpdateNotiStatusEvent(
                        //         notiID:
                        //             state.notiList[index].notiID.toString(),
                        //       ),
                        //     );
                      },
                    );
                  },
                  itemCount: state.notiList.length,
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
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

  final String? title, orderId, highlight, description;
  final int? itemAmount, notiID;
  final DateTime? time;
  final bool? isRead;
  final NotiTypes? notiTypes;
}

enum NotiTypes {
  create,
  cancelled,
}
