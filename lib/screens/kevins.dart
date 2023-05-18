import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walter/models/kevin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walter/utilities/databaseUtility.dart';
import 'package:walter/widgets/kevinwidget.dart';

class Kevins extends StatefulWidget {
  const Kevins({super.key, required this.minionId, required this.name});
  final int? minionId;
  final String? name;

  @override
  State<Kevins> createState() => _KevinsState();
}

class _KevinsState extends State<Kevins> {
  final accountController = TextEditingController();
  final bankNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'walter',
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name?.toString() ?? '',
            style: GoogleFonts.dosis(
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
                Icons.account_balance_rounded,
              ),
            ),
          ],
        ),
        body: KevinWidget(minionId: widget.minionId, name: widget.name),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Add a Transaction',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: accountController,
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
                          labelText: 'Account Number',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintText: 'enter your account number ...',
                          prefixIcon: Icon(
                            Icons.numbers,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: TextField(
                            controller: bankNameController,
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
                              labelText: 'Bank Name',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: 'enter your bank name ...',
                              prefixIcon: Icon(
                                Icons.account_balance,
                                color: Colors.white,
                              ),
                            ),
                          )),
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
                        DatabaseUtility.instance.createKevin(
                          Kevin(
                              minionId: widget.minionId?.toInt() ?? 0,
                              accountNumber: accountController.text,
                              bankName: bankNameController.text),
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
