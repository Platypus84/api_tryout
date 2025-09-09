import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, List<dynamic>>>? _futureDBResults;

  Future<Map<String, List<dynamic>>>? getResults() {
    return null;
  }

  @override
  void initState() {
    // _futureDBResults = getResults()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('SuperHero API')),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Gib einen Superheldennamen ein'),
                  SizedBox(height: 24),
                  SearchBar(elevation: WidgetStatePropertyAll(1)),
                  SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder(
                        future: _futureDBResults,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error),
                                  Text('Fehler aufgetreten: ${snapshot.error}'),
                                ],
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return Text('Snapshot Daten: ${snapshot.data!}‚');
                          } else {
                            return Text('Keine Daten');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
