import 'dart:convert';

import 'package:api_tryout/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>>? _futureDBResults;
  SearchController inputCtrl = SearchController();
  String? superheroName;
  String? resultCount;
  Uri? uri;

  Future<Map<String, dynamic>> getData(String heroName) async {
    debugPrint('hero Name ist: $heroName');
    final uri = Uri.parse(
      'https://akabab.github.io/superhero-api/api/all.json',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint("Fehler bei der Datenabfrage: ${response.statusCode}");
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    // Reminder: jsonDecode parses a JSON string and returns a Dart object,
    // which will be a Map<String, dynamic> if the JSON represents an object,
    // or a List<dynamic> if it represents an array.

    debugPrint(data.toString());
    // final Map<String, dynamic> heroes = data.asMap().cast<String, dynamic>();
    final heroes = data
        .where(
          (element) =>
              element['name'].toLowerCase().contains(heroName.toLowerCase()),
        )
        .toList();
    // final hero = data.entries.firstWhere(
    //   (entry) => entry.key == 'name' && entry.value == 'Batman',
    // );

    debugPrint(heroes.length.toString());
    resultCount = heroes.length.toString();
    return heroes[0];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text('Superhero Database')),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Gib einen Superheldennamen ein',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  SearchBar(
                    controller: inputCtrl,
                    onSubmitted: (value) {
                      _futureDBResults = getData(inputCtrl.text);
                      setState(() {});
                    },
                    elevation: WidgetStatePropertyAll(1),
                  ),
                  SizedBox(height: 64),
                  // ?resultCount != null
                  //     ? Text('Ergebnisse: $resultCount')
                  //     : null,
                  SizedBox(
                    width: 320,
                    child: Card(
                      color: Color.fromRGBO(90, 89, 104, 1),
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
                                    Text(
                                      'Fehler aufgetreten: ${snapshot.error}',
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              final img = snapshot.data!['images']['sm'];
                              final name = '${snapshot.data!['name']}';
                              final bio = snapshot.data!['biography'];
                              final Map<String, dynamic> appearance =
                                  snapshot.data!['appearance'];
                              final Map<String, dynamic> powers =
                                  snapshot.data!['powerstats'];

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 64,
                                        backgroundImage:
                                            snapshot.data!['images'] != null
                                            ? NetworkImage(img)
                                            : null,
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          255,
                                          187,
                                          0,
                                        ),
                                        //Text('Snapshot Daten: ${s,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            225,
                                            141,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 32),
                                  Text(
                                    'Bio',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  SizedBox(height: 8),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Name: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),

                                          Text(bio['fullName']),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Geburtsort: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),

                                          Expanded(
                                            child: Text(bio['placeOfBirth']),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Größe: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),

                                          Text(appearance['height'][1]),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Gewicht: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(appearance['weight'][1]),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 32),
                                  Text(
                                    'Eigenschaften',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Intelligenz: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(powers['intelligence'].toString()),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Stärke: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(powers['strength'].toString()),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Schnelligkeit: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(powers['speed'].toString()),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Ausdauer: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(powers['durability'].toString()),
                                    ],
                                  ),
                                  // powers.entries.map((entry) {
                                  //   String power = entry.key;

                                  //   return Text(power);
                                  // }),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       'Fähigkeiten: ',
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.w700,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       snapshot.hasData
                                  //           ? '${snapshot.data!['powerstats']}'
                                  //           : 'Inhalt',
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(height: 24),
                                ],
                              );
                            } else {
                              return Column(children: [Text('Keine Daten')]);
                            }
                          },
                        ),
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
