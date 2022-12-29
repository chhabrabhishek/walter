import 'package:flutter/material.dart';
import 'package:walter/models/minion.dart';
import 'package:walter/screens/kevins.dart';
import 'package:walter/utilities/databaseUtility.dart';

class MinionsWidget extends StatefulWidget {
  const MinionsWidget({Key? key}) : super(key: key);

  @override
  State<MinionsWidget> createState() => _MinionsWidgetState();
}

class _MinionsWidgetState extends State<MinionsWidget> {
  final database = DatabaseUtility.instance;
  late Future<List<Minion>> minionList;
  @override
  void initState() {
    super.initState();

    minionList = database.readAll(tableMinions).then(
          (value) => value.map((json) => Minion.fromJson(json)).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Minion>>(
      future: minionList,
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
                      builder: (context) =>
                          Kevins(minionId: snapshot.data![index].minionId),
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
                                snapshot.data![index].name,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                snapshot.data![index].phonenumber,
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
            'No minions found yet!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        ;
      }),
    );
  }
}
