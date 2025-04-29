import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/builders/event_info.dart';
import 'package:sampleflutter/utils/builders/event_report.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';

class DetailedEventPage extends StatefulWidget {
  final Map eventDetails;
  final List<Widget> eventStatusUpdateButtons;
  
  const DetailedEventPage({
    required this.eventDetails,
    required this.eventStatusUpdateButtons,
    super.key,
  });

  @override
  State<DetailedEventPage> createState() => _DetailedEventPageState();
}

class _DetailedEventPageState extends State<DetailedEventPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? curUserRole;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // Fetch the role once at start
    secureStorage.read(key: 'role').then((role) {
      setState(() {
        curUserRole = role ?? "";
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      bottomNavigationBar: _tabController.index == 0
          ? CustomBottomAppbar(
              bottomAppbarChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [...widget.eventStatusUpdateButtons],
              ),
            )
          : null,
      appBar: KovilAppBar(withIcon: true),
      body: Column(
        children: [
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            indicatorColor: Colors.orange,
            tabs: const [
              Tab(text: 'Event Info'),
              Tab(text: 'Event Report'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildEventInfo(widget.eventDetails, curUserRole ?? ""),
                buildEventReport(widget.eventDetails, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

