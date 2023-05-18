import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walter/models/saul.dart';
import 'package:walter/utilities/databaseUtility.dart';
import 'package:date_time_picker/date_time_picker.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

const List<String> statusOptions = <String>['Debited', 'Credited'];

class SaulWidget extends StatefulWidget {
  const SaulWidget({super.key, required this.kevinId});

  final int? kevinId;

  @override
  State<SaulWidget> createState() => _SaulWidgetState();
}

class _SaulWidgetState extends State<SaulWidget> {
  final database = DatabaseUtility.instance;
  late Future<List<Saul>> saulList;
  int balance = 0;
  String selectedDateTime =
      DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
  final dateTimeController = TextEditingController();
  @override
  void initState() {
    super.initState();

    saulList = database.saulRead(widget.kevinId);
  }

  @override
  void didUpdateWidget(SaulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    saulList = database.saulRead(widget.kevinId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Saul>>(
      future: saulList,
      builder: ((context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var me = snapshot.data!;
          me.sort(
            ((a, b) => DateTime.parse(b.dateOfTransaction).compareTo(
                  DateTime.parse(a.dateOfTransaction),
                )),
          );
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_rounded),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'Balance: ${me.toList().fold<int>(
                          0,
                          (previousValue, minion) {
                            return previousValue +
                                (minion.isDebited == 1
                                    ? -minion.amount
                                    : minion.amount);
                          },
                        )} ₹',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: me.length,
                itemBuilder: (context, index) {
                  TextEditingController amountController =
                      TextEditingController(text: me[index].amount.toString());
                  String selectedStatus = me[index].isDebited == 1
                      ? statusOptions[0]
                      : statusOptions[1];
                  return GestureDetector(
                    onPanUpdate: (details) {
                      if (details.delta.dx < -20) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Delete a Transaction',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                    "Are you sure you want to delete the transaction?"),
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
                                      database
                                          .deleteSaul(
                                              me[index].saulId?.toInt() ?? 0)
                                          .then(
                                            (value) => {
                                              setState(
                                                () {
                                                  saulList = database
                                                      .saulRead(widget.kevinId);
                                                },
                                              )
                                            },
                                          );
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                      } else if (details.delta.dx > 20) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Update a Transaction',
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
                                      labelText: 'Amount',
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                    DatabaseUtility.instance
                                        .updateSaul(
                                          Saul(
                                            saulId: me[index].saulId,
                                            kevinId:
                                                widget.kevinId?.toInt() ?? 0,
                                            amount: amountController.text != ''
                                                ? int.parse(
                                                    amountController.text)
                                                : 0,
                                            isDebited:
                                                selectedStatus == 'Debited'
                                                    ? 1
                                                    : 0,
                                            dateOfTransaction: selectedDateTime,
                                          ),
                                        )
                                        .then(
                                          (value) => {
                                            setState(
                                              () {
                                                saulList = database
                                                    .saulRead(widget.kevinId);
                                              },
                                            )
                                          },
                                        );
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          child: Column(
                            children: [
                              Text(
                                '₹ ${me[index].amount}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  me[index].isDebited == 1
                                      ? 'Debited'
                                      : 'Credited',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: me[index].isDebited == 1
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(
                                          me[index].dateOfTransaction),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          );
        }
        return const Center(
          child: Text(
            'No Transations for this account yet!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}
