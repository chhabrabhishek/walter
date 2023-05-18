import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walter/models/minion.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walter/widgets/minionswidget.dart';
import 'package:walter/utilities/databaseUtility.dart';

class Minions extends StatefulWidget {
  const Minions({Key? key}) : super(key: key);

  @override
  State<Minions> createState() => _MinionsState();
}

class _MinionsState extends State<Minions> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'walter',
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'walter',
            style: GoogleFonts.dosis(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Icon(
                Icons.person_rounded,
              ),
            ),
          ],
        ),
        body: MinionsWidget(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Add a Minion',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintText: 'enter your name ...',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            hintText: 'enter your phone number ...',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        DatabaseUtility.instance.createMinion(
                          Minion(
                              name: nameController.text,
                              phonenumber: phoneController.text),
                        );
                        Navigator.pop(context);
                        setState(() {});
                      },
                    )
                  ],
                );
              },
            );
          }),
          backgroundColor: Colors.black,
          label: const Text(
            'Add',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          icon: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }
}
