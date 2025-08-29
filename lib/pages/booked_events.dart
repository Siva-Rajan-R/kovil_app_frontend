import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/booked_event_card.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';

Widget _buildEvents({
  required List events,
  required BuildContext context,
}) {
  return ListView.builder(
    physics: BouncingScrollPhysics(),
    itemCount: events.length,
    itemBuilder: (context, index) {
      return  RepaintBoundary(
        child: BookedEventCard(eventDetails: events[index])
      );
    },
  );
}

class BookedEventsPage extends StatefulWidget {
  const BookedEventsPage({super.key});

  @override
  State<BookedEventsPage> createState() => _BookedEventsPageState();
}

class _BookedEventsPageState extends State<BookedEventsPage> {
  late Future<Map<String, List>> _eventsFuture;
  int noOfBookedEvents = 0;

  @override
  void initState() {
    super.initState();
    _eventsFuture = getEvents();
  }

  Future<Map<String, List>> getEvents() async {
    final res = await NetworkService.sendRequest(
      path: "/event/specific?date=2025-05-12&isfor_booked=true",
      context: context,
    );

    if (res!=null) {
      final bookedEventsList = List<Map>.from(res['events']);

      setState(() {
        noOfBookedEvents=bookedEventsList.length;
      });

      return {
        'bookedEvents':bookedEventsList
      };
    } else {
      return {
        'bookedEvents': []
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width>phoneSize? null : KovilAppBar(
        withIcon: true,
        titleSize: 20,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ImageShowerDialog(
                    imageUrl: "$BASEURL/panchagam/calendar?date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
                  ),
                ),
              ),
              child: SvgPicture.asset(
                "assets/svg/calendar-svgrepo-com.svg",
                width: 30,
              ),
            ),
          )
        ],
      ),
      body:Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Booked Events ($noOfBookedEvents)",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder<Map<String, List>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                    
                      children: [
                        LottieBuilder.asset(getRandomLoadings(),width:200),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Please wait while fetching booked events...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                            VerticalDivider(),
                            SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
                          ],
                        )
                      ],
                    )
                  );
                }
                
                final bookedEvents = snapshot.data?['bookedEvents'] ?? [];
            
                return bookedEvents.isNotEmpty? Expanded(child: _buildEvents(events: bookedEvents, context: context)) : Center(child:Text("There is no booked events",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black54),));
              },
            ),
          ],
        ),
    );
  }
}
