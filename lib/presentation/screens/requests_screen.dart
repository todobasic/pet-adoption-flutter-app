import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/presentation/screens/requests_tabs/history_requests.dart';
import 'package:pet_adoption/presentation/screens/requests_tabs/pending_requests.dart';
import 'package:pet_adoption/presentation/screens/requests_tabs/processed_requests.dart';
import 'package:pet_adoption/presentation/screens/requests_tabs/received_requests.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Received'),
              Tab(text: 'Processed'),
              Tab(text: 'Pending'),              
              Tab(text: 'History'),
            ],
          ),
        ),
        drawer: const CustomDrawer(),
        body:  const TabBarView(
          children: [
            ReceivedRequestsTab(),
            ProcessedRequestsTab(),
            PendingRequestsTab(),
            RequestHistoryTab(),
          ], 
        ),
      ),
    );    
  }
}
