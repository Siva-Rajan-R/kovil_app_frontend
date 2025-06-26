
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/recive_notification_card.dart';


class RecivedNotificationPage extends StatefulWidget {
  final List? newNotificationsList;
  final List? seenNotificationList;
  const RecivedNotificationPage(
    {
      super.key,
      this.newNotificationsList,
      this.seenNotificationList
    }
  );

  @override
  State<RecivedNotificationPage> createState() => _RecivedNotificationPageState();
}

class _RecivedNotificationPageState extends State<RecivedNotificationPage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: MediaQuery.of(context).size.width>400? null : KovilAppBar(withIcon: true,),
      body: ((widget.newNotificationsList==null || widget.newNotificationsList!.isEmpty)&&(widget.seenNotificationList==null || widget.seenNotificationList!.isEmpty))? Center(child: Text("No Notifications, Try to refresh on homepage",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w700),textAlign: TextAlign.center,))
      : ListView(
        physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  if (widget.newNotificationsList!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text("New", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,color: Colors.grey)),
                    const SizedBox(height: 8),
                    ...widget.newNotificationsList!.map((notif) => ReciveNotificationCard(
                          notificationTitle: notif['title'],
                          notificationBody: notif['body'],
                          notificationImageUrl: notif['image_url'],
                          notificationCreatedAtUtc: notif['created_at'],
                          notificationCreatedBy: notif['created_by'],
                        )),
                  ],
                  if (widget.seenNotificationList!.isNotEmpty) ...[
                    const Divider(height: 32),
                    const Text("Seen", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,color: Colors.grey)),
                    const SizedBox(height: 8),
                    ...widget.seenNotificationList!.map((notif) => ReciveNotificationCard(
                          notificationTitle: notif['title'],
                          notificationBody: notif['body'],
                          notificationImageUrl: notif['image_url'],
                          notificationCreatedAtUtc: notif['created_at'],
                          notificationCreatedBy: notif['created_by'],
                        )),
                  ],
                ],
              ),
    );
  }
}