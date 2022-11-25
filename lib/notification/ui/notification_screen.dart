import 'package:flutter/material.dart';
import 'package:zlp_poc/notification/ui/widgets/noti_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  List<NotiObject> notiList = [
    NotiObject(
      time: DateTime(2022, 11, 4, 23, 45),
      isRead: false,
      highlight: 'salesrepname',
      itemAmount: 1,
      orderId: '#5468904',
      title: 'Order Created',
      notiTypes: NotiTypes.create,
    ),
    NotiObject(
      time: DateTime(2022, 11, 24, 15, 45),
      isRead: false,
      highlight: 'salesrepname',
      itemAmount: 6,
      orderId: '#5468904',
      title: 'Order Created',
      notiTypes: NotiTypes.create,
    ),
    NotiObject(
      time: DateTime(2022, 11, 20, 6, 24),
      isRead: true,
      highlight: 'Cancelled',
      itemAmount: 4,
      orderId: '#5463634',
      title: 'Order Item - Cancelled',
      notiTypes: NotiTypes.cancelled,
    ),
    NotiObject(
      time: DateTime(2022, 11, 24, 12, 45),
      isRead: false,
      highlight: 'salesrepname',
      itemAmount: 1,
      orderId: '#5468904',
      title: 'Order Created',
      notiTypes: NotiTypes.create,
    ),
    NotiObject(
      time: DateTime(2022, 11, 20, 6, 24),
      isRead: true,
      highlight: 'Cancelled',
      itemAmount: 2,
      orderId: '#5463634',
      title: 'Order Item - Cancelled',
      notiTypes: NotiTypes.cancelled,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
  });

  final String? title, orderId, highlight;
  final int? itemAmount;
  final DateTime? time;
  final bool? isRead;
  final NotiTypes? notiTypes;
}

enum NotiTypes {
  create,
  cancelled,
}
