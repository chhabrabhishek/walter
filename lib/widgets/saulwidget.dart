import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walter/models/saul.dart';
import 'package:walter/utilities/databaseUtility.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

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
                        )} ???',
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
                  return GestureDetector(
                    onLongPress: () {
                      database.deleteSaul(me[index].saulId?.toInt() ?? 0).then(
                            (value) => {
                              setState(
                                () {
                                  saulList = database.saulRead(widget.kevinId);
                                },
                              )
                            },
                          );
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
                                '??? ${me[index].amount}',
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
