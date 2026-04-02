import 'dart:convert';

import 'package:cake_it_app/src/features/cake.dart';
import 'package:cake_it_app/src/features/cake_details_view.dart';
import 'package:cake_it_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Displays a list of cakes.
/// Hmmm Stateful Widget is used here, but it could be a StatelessWidget?
class CakeListView extends StatefulWidget {
  const CakeListView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<CakeListView> createState() => _CakeListViewState();
}

class _CakeListViewState extends State<CakeListView> {
  List<Cake> cakes = [];

  @override
  void initState() {
    super.initState();
    fetchCakes();
  }

  Future<void> fetchCakes() async {
    final url = Uri.parse(
        "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList");
    final response = await http.get(url);
    await Future.delayed(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = json.decode(response.body);
      setState(() {
        cakes = decodedResponse.map((cake) => Cake.fromJson(cake)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎂CakeItApp🍰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'cakeListView',
        itemCount: cakes.length,
        itemBuilder: (BuildContext context, int index) {
          final cake = cakes[index];

          return ListTile(
              title: Text('${cake.title}'),
              subtitle: Text('${cake.description}'),
              leading: CircleAvatar(
                child: Image.network(
                  cakes[index].image!,
                ),
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  CakeDetailsView.routeName,
                  arguments: const Cake(
                    title: 'failed cake',
                    description: 'soggy bottom',
                    image: 'https://www.example.com',
                  ).toJson(),
                );
              });
        },
      ),
    );
  }
}
