import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/builders/event_name.dart';
import 'package:sampleflutter/custom_controls/event_name_card.dart';
import 'package:sampleflutter/utils/network_request.dart';

Widget makeEventNamesAmountCard(List eventNamesAmount, bool isForNeivethiyam) {
  return ListView.builder(
    itemCount: eventNamesAmount.length,
    itemBuilder: (context, index) {
      return EventNameAmountCard(
        eventNameId: eventNamesAmount[index]['id'],
        eventName: eventNamesAmount[index]['name'],
        eventAmount: eventNamesAmount[index]['amount'].toString(),
        isForNeivethiyam: isForNeivethiyam,
      );
    },
  );
}

class AddEventName extends StatelessWidget {
  const AddEventName({super.key});

  Future getEventNames({required BuildContext context}) async {
    final res = await NetworkService.sendRequest(path: '/event/name', context: context);
    if (res != null) {
      final eventNamesAmountList = List.from(res['event_names']);
      final normalEventsAmnt = eventNamesAmountList.where((e) => e['is_special'] == false).toList();
      final specialEventsAmnt = eventNamesAmountList.where((e) => e['is_special'] == true).toList();
      return {
        'normalEventsAmnt': normalEventsAmnt,
        'specialEventsAmnt': specialEventsAmnt,
      };
    }
  }

  Future getNeivethiyamNames({required BuildContext context}) async {
    final res = await NetworkService.sendRequest(path: '/neivethiyam/name', context: context);
    if (res != null) {
      return List.from(res['neivethiyam_names']);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(withIcon: true),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.orange,
              
              tabs: [
                Tab(text: 'New'),
                Tab(text: 'Event Names'),
                Tab(text: 'Neivethiyam'),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: Future.wait([
                  getEventNames(context: context),
                  getNeivethiyamNames(context: context)
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.orange));
                  }
                  final normalEventsAmnt = snapshot.data?[0]['normalEventsAmnt'] ?? [];
                  final specialEventsAmnt = snapshot.data?[0]['specialEventsAmnt'] ?? [];
                  final neivethiyamNamesAmount = snapshot.data?[1] ?? [];

                  return TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: AddEventNewName(),
                      ),
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: Colors.black,
                              indicatorColor: Colors.orange,
                              tabs: [
                                Tab(text: 'Normal'),
                                Tab(text: 'Special'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  normalEventsAmnt.isNotEmpty
                                      ? makeEventNamesAmountCard(normalEventsAmnt, false)
                                      : Center(child: Text('No data found')),
                                  specialEventsAmnt.isNotEmpty
                                      ? makeEventNamesAmountCard(specialEventsAmnt, false)
                                      : Center(child: Text('No data found')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      neivethiyamNamesAmount.isNotEmpty
                          ? makeEventNamesAmountCard(neivethiyamNamesAmount, true)
                          : Center(child: Text('No data found')),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
