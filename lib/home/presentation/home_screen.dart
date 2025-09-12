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
  bool _showTrailingIcon = false;
  String? superheroName;
  String? resultCount;
  Uri? uri;

  Future<List<Map<String, dynamic>>> getData(String heroName) async {
    // debugPrint('hero Name ist: $heroName');

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

    // debugPrint('Anzahl Ergebnisse: ${heroes.length.toString()}');

    setState(() {
      resultCount = heroes.length.toString();
    });
    return heroes;
  }

  @override
  void dispose() {
    inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                  SizedBox(height: 16),
                  SearchBar(
                    controller: inputCtrl,
                    onSubmitted: (value) {
                      _futureDBResults = getData(inputCtrl.text);
                      _showTrailingIcon = true;
                      setState(() {});
                    },
                    trailing: [
                      Visibility(
                        visible: _showTrailingIcon,
                        child: IconButton(
                          onPressed: () {
                            inputCtrl.clear();
                            _showTrailingIcon = false;
                            setState(() {});
                          },
                          icon: Icon(Icons.close),
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],

                    elevation: WidgetStatePropertyAll(1),
                  ),
                  SizedBox(height: 16),
                  ?resultCount != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text('Ergebnisse: $resultCount'),
                        )
                      : null,
                  Expanded(
                    child: SizedBox(
                      width: 320,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        // Reminder: Datentyp auch im im FutureBuilder angeben
                        future: _futureDBResults,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              children: [
                                SizedBox(height: 8),
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8),
                                  const Icon(Icons.error),
                                  Text('Fehler aufgetreten: ${snapshot.error}'),
                                ],
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return snapshot.data!.isEmpty
                                ? Text(
                                    'Kein Ergebnis gefunden.\nProbiere es auch mal mit nur einem Namensteil (z.B. Spider, statt Spiderman).',
                                    textAlign: TextAlign.center,
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final hero = snapshot.data![index];
                                      final imgThumb = hero['images']['sm'];
                                      final imgLarge = hero['images']['lg'];
                                      final name = '${hero['name']}';
                                      final bio = hero['biography'];
                                      final Map<String, dynamic> appearance =
                                          hero['appearance'];
                                      final Map<String, dynamic> powers =
                                          hero['powerstats'];

                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color.fromARGB(
                                                    255,
                                                    80,
                                                    90,
                                                    120,
                                                  ),
                                                  const Color.fromARGB(
                                                    255,
                                                    40,
                                                    45,
                                                    60,
                                                  ),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Card(
                                              color: Colors.transparent,
                                              // color: Color.fromRGBO(90, 89, 104, 1),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  16.0,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await showDialog(
                                                              context: context,
                                                              builder: (_) => Dialog(
                                                                child: Container(
                                                                  clipBehavior:
                                                                      Clip.hardEdge,
                                                                  decoration: BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: const Color.fromARGB(
                                                                          200,
                                                                          205,
                                                                          205,
                                                                          255,
                                                                        ),
                                                                        blurRadius:
                                                                            40.0,
                                                                      ),
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          15,
                                                                        ),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image.network(
                                                                        imgLarge,
                                                                      ),
                                                                      Positioned(
                                                                        bottom:
                                                                            0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        child: Container(
                                                                          padding:
                                                                              EdgeInsets.all(
                                                                                8,
                                                                              ),
                                                                          color: Color.fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0.7,
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              name,
                                                                              style: Theme.of(
                                                                                context,
                                                                              ).textTheme.headlineLarge,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },

                                                          child: CircleAvatar(
                                                            radius: 64,
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                  200,
                                                                  255,
                                                                  245,
                                                                  255,
                                                                ),
                                                            child: CircleAvatar(
                                                              radius: 60,
                                                              backgroundImage:
                                                                  hero['images'] !=
                                                                      null
                                                                  ? NetworkImage(
                                                                      imgThumb,
                                                                    )
                                                                  : null,
                                                              backgroundColor:
                                                                  Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    211,
                                                                    140,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          name,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headlineLarge,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 32),
                                                    Text(
                                                      'Bio',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                          0,
                                                          0,
                                                          0,
                                                          0.25,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      padding: EdgeInsets.all(
                                                        8,
                                                      ),

                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Name: ',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  bio['fullName'],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Geburtsort: ',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
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
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Text(
                                                                appearance['height'][1],
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Gewicht: ',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Text(
                                                                appearance['weight'][1],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 32),
                                                    Text(
                                                      'Eigenschaften',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                          0,
                                                          0,
                                                          0,
                                                          0.25,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      padding: EdgeInsets.all(
                                                        8,
                                                      ),

                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Intelligenz: ',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Text(
                                                                powers['intelligence']
                                                                    .toString(),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Stärke: ',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Text(
                                                                powers['strength']
                                                                    .toString(),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Schnelligkeit: ',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Text(
                                                                powers['speed']
                                                                    .toString(),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Ausdauer: ',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Text(
                                                                powers['durability']
                                                                    .toString(),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 32),
                                        ],
                                      );
                                    },
                                  );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 8),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          image: DecorationImage(
                                            alignment:
                                                AlignmentGeometry.directional(
                                                  -0.17,
                                                  0,
                                                ),
                                            fit: BoxFit.fitHeight,
                                            colorFilter: ColorFilter.mode(
                                              Color.fromARGB(
                                                255,
                                                63,
                                                88,
                                                135,
                                              ).withValues(alpha: 1),
                                              BlendMode.color,
                                            ),
                                            image: AssetImage(
                                              'assets/img/12009.jpg',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Designed by Freepik',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                  255,
                                                  63,
                                                  67,
                                                  88,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
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
