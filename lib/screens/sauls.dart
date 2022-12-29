import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walter/models/saul.dart';
import 'package:walter/widgets/saulwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walter/utilities/databaseUtility.dart';
import 'package:date_time_picker/date_time_picker.dart';

const List<String> statusOptions = <String>['Debited', 'Credited'];

class Sauls extends StatefulWidget {
  const Sauls({super.key, required this.kevinId});

  final int? kevinId;

  @override
  State<Sauls> createState() => _SaulsState();
}

class _SaulsState extends State<Sauls> {
  String selectedStatus = statusOptions.first;
  String selectedDateTime =
      DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
  final amountController = TextEditingController();
  final dateTimeController = TextEditingController();

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
                Icons.account_balance_wallet_rounded,
              ),
            ),
          ],
        ),
        body: SaulWidget(kevinId: widget.kevinId),
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
                        controller: amountController,
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
                          labelText: 'amount',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintText: 'enter your amount ...',
                          prefixIcon: Icon(
                            Icons.currency_rupee_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: DropdownButtonFormField<String>(
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
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            prefixIcon: Icon(
                              Icons.currency_exchange_rounded,
                              color: Colors.white,
                            ),
                          ),
                          value: selectedStatus,
                          items: statusOptions.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (String? _) {
                            setState(() {
                              selectedStatus = _!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: DateTimePicker(
                          // controller: dateTimeController,
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
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'd MMM, yyyy',
                          initialValue: selectedDateTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: const Icon(Icons.event),
                          dateLabelText: 'Date',
                          timeLabelText: "Hour",
                          onChanged: (_) => {
                            selectedDateTime = _,
                          },
                        ),
                      )
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
                        DatabaseUtility.instance.createSaul(
                          Saul(
                            kevinId: widget.kevinId?.toInt() ?? 0,
                            amount: amountController.text != ''
                                ? int.parse(amountController.text)
                                : 0,
                            isDebited: selectedStatus == 'Debited' ? 1 : 0,
                            dateOfTransaction: selectedDateTime,
                          ),
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
