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
  Future<List<Map<String, dynamic>>>? _futureDBResults;
  SearchController inputCtrl = SearchController();
  String? superheroName;
  String? resultCount;
  Uri? uri;

  Future<List<Map<String, dynamic>>> getData(String heroName) async {
    debugPrint('hero Name ist: $heroName');
    final uri = Uri.parse(
      'https://akabab.github.io/superhero-api/api/all.json',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint("Fehler bei der Datenabfrage: ${response.statusCode}");
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    /* 
      Reminder: 
      Verwende List<dynamic> data = jsonDecode(response.body) oder "as List<dynamic>" 
      - wenn JSON ein Array ist (Abfrage erzeugt Liste mit mehreren Ergebnissen)
      Verwende Map<String, dynamic> data = jsonDecode(response.body) oder "as Map<String, dynamic>" 
      - wenn JSON ein Objekt ist (Abfrage erzeugt nur 1 Ergebnis)
    */

    final heroes = data
        .where(
          (element) =>
              element['name'].toLowerCase().contains(heroName.toLowerCase()),
        )
        .cast<Map<String, dynamic>>()
        /* 
          Reminder: .cast() besser als "....toList() as List<Map<String, dynamic>>", da
          - typsicher: .cast() prüft zur Laufzeit jeden Eintrag
          - klarere Syntax: Deutlicher lesbar in Method-Chain
          - bessere Fehlerbehandlung: Wirft spezifische Cast-Exceptions
        */
        .toList();

    debugPrint(heroes.length.toString());
    resultCount = heroes.length.toString();
    return heroes;
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
                  Expanded(
                    child: SizedBox(
                      width: 320,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        // Reminder: Datentyp auch im im FutureBuilder angeben
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
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final hero = snapshot.data![index];
                                final img = hero['images']['sm'];
                                final name = '${hero['name']}';
                                final bio = hero['biography'];
                                final Map<String, dynamic> appearance =
                                    hero['appearance'];
                                final Map<String, dynamic> powers =
                                    hero['powerstats'];

                                return Card(
                                  color: Color.fromRGBO(90, 89, 104, 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 64,
                                              backgroundImage:
                                                  hero['images'] != null
                                                  ? NetworkImage(img)
                                                  : null,
                                              backgroundColor: Color.fromARGB(
                                                255,
                                                255,
                                                187,
                                                0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  child: Text(
                                                    bio['placeOfBirth'],
                                                  ),
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
                                            Text(
                                              powers['intelligence'].toString(),
                                            ),
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
                                            Text(
                                              powers['durability'].toString(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 24),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Column(children: [Text('Keine Daten')]);
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
