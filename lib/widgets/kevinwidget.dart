import 'package:flutter/material.dart';
import 'package:walter/models/kevin.dart';
import 'package:walter/screens/sauls.dart';
import 'package:walter/utilities/databaseUtility.dart';

class KevinWidget extends StatefulWidget {
  const KevinWidget({super.key, required this.minionId, required this.name});

  final int? minionId;
  final String? name;

  @override
  State<KevinWidget> createState() => _KevinWidgetState();
}

class _KevinWidgetState extends State<KevinWidget> {
  final database = DatabaseUtility.instance;
  late Future<List<Kevin>> kevinList;
  @override
  void initState() {
    super.initState();

    kevinList = database.kevinRead(widget.minionId);
  }

  @override
  void didUpdateWidget(KevinWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    kevinList = database.kevinRead(widget.minionId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: FutureBuilder<List<Kevin>>(
        future: kevinList,
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Sauls(
                          kevinId: snapshot.data![index].kevinId,
                          name: widget.name,
                          bankName: snapshot.data![index].bankName,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  snapshot.data![index].accountNumber,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  snapshot.data![index].bankName,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text(
              'No kevins found yet!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
      ),
    );
  }
}
