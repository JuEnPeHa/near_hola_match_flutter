import 'package:flutter/material.dart';
import 'package:near_hola_match_flutter/models/name_and_language.dart';
import 'package:near_hola_match_flutter/utils/rpc_fun.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'NEAR Flutter demo';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _nameController;
  static const List<String> acceptedLanguages = [
    'en',
    'es',
    'fr',
    'de',
    'it',
    'pt',
    'ru',
    'zh',
    'tr',
    'ua'
  ];
  bool clicked = false;

  final NameAndLanguage nameAndLanguage = NameAndLanguage(
    name: '',
    language: '',
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurpleAccent.shade700,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(5, 5),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.indigo.shade700.withOpacity(0.7),
                    Colors.red.shade400.withOpacity(0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Hello ${nameAndLanguage.name}',
                  ),
                  Text(
                    nameAndLanguage.language == ''
                        ? 'Please select a language'
                        : 'You speak ${nameAndLanguage.language}',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        nameAndLanguage.name = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Language',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: acceptedLanguages.map((String language) {
                      return DropdownMenuItem(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: nameAndLanguage.name != ''
                        ? (value) {
                            setState(() {
                              nameAndLanguage.language = value as String;
                            });
                          }
                        : null,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: nameAndLanguage.language != ''
                        ? () {
                            setState(() {
                              clicked = true;
                            });
                          }
                        : null,
                    child: const Text('Say hello'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: clicked
                          ? FutureBuilder(
                              future:
                                  callFetch(nameAndLanguage: nameAndLanguage),
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    '${snapshot.error}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                                return const CircularProgressIndicator();
                              }),
                            )
                          : null,
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
