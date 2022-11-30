import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zlp_poc/gen/assets.gen.dart';
import 'package:zlp_poc/notification/ui/notification_screen.dart';
import 'package:intl/intl.dart';

import '../../bloc/noti_bloc.dart';

class NotiItem extends StatefulWidget {
  final NotiObject notiObject;
  final GestureTapCallback onTap;

  const NotiItem({Key? key, required this.notiObject, required this.onTap})
      : super(key: key);

  @override
  State<NotiItem> createState() => _NotiItemState();
}

class _NotiItemState extends State<NotiItem> {
  bool isShow = true;

  @override
  void initState() {
    widget.notiObject.isRead ?? true ? (isShow = false) : (isShow = true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotiBloc, NotiState>(
      listener: (context, state) {
        if (state is UpdateNotiStatusState) {
          // isShow = true;
          setState(() {});
        }
      },
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: getNotiImage(widget.notiObject.notiTypes),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.notiObject.title ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.notiObject.description ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff656565),
                            ),
                          ),
                          // getContent(widget.notiObject),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                '${DateFormat('dd MMM yyyy').format(widget.notiObject.time ?? DateTime.now())} at ${widget.notiObject.time?.hour}:${widget.notiObject.time?.minute} | ',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xffA1A1A1),
                                ),
                              ),
                              calculateTime(
                                  widget.notiObject.time ?? DateTime.now()),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xffE8E8E8),
                  thickness: 1.5,
                  height: 0,
                ),
              ],
            ),
            Positioned(
              right: 16,
              top: 8,
              child: Visibility(
                visible: isShow,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: Color(0xffE7A546), shape: BoxShape.circle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget calculateTime(DateTime time) {
    TextStyle style = const TextStyle(
      fontSize: 10,
      color: Color(0xffA1A1A1),
    );

    int differenceDays = DateTime.now().difference(time).inDays;
    int differenceHours = DateTime.now().difference(time).inHours;
    int differenceMinutes = DateTime.now().difference(time).inMinutes;

    if (differenceDays < 1) {
      if (differenceHours > 0) {
        return Text(
          '${differenceHours}h ago',
          style: style,
        );
      } else {
        return Text(
          '${differenceMinutes}m ago',
          style: style,
        );
      }
    } else if (differenceDays == 1) {
      return Text(
        'Yesterday',
        style: style,
      );
    } else {
      return Text(
        '$differenceDays days ago',
        style: style,
      );
    }
  }

  Widget getContent(NotiObject notiObject) {
    switch (notiObject.notiTypes) {
      case NotiTypes.create:
        return RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, color: Color(0xff656565)),
            children: [
              const TextSpan(
                text: 'Order ',
              ),
              TextSpan(
                text: notiObject.orderId,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text:
                    ' with ${notiObject.itemAmount} ${(notiObject.itemAmount ?? 1) > 1 ? 'items' : 'item'} created by ',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: notiObject.highlight,
                style: const TextStyle(
                  color: Color(0xff4483DB),
                ),
              ),
            ],
          ),
        );
      case NotiTypes.cancelled:
        return RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, color: Color(0xff656565)),
            children: [
              const TextSpan(
                text: 'Order ',
              ),
              TextSpan(
                text: notiObject.orderId,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text:
                    ' - ${notiObject.itemAmount} ${(notiObject.itemAmount ?? 1) > 1 ? 'items' : 'item'} ',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: notiObject.highlight,
                style: const TextStyle(
                  color: Color(0xff4483DB),
                ),
              ),
            ],
          ),
        );
      default:
        return const Text('');
    }
  }

  Widget getNotiImage(NotiTypes? notiTypes) {
    switch (notiTypes) {
      case NotiTypes.create:
        return Assets.images.boxImage.svg();
      case NotiTypes.cancelled:
        return Assets.images.cancelledImage.svg();
      default:
        return Assets.images.boxImage.svg();
    }
  }
}
