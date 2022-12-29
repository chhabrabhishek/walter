import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walter/screens/minions.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 10,
            ),
            child: TextField(
              controller: passwordController,
              obscureText: true,
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
                labelText: 'password',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintText: 'enter your password ...',
                prefixIcon: Icon(
                  Icons.password,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => {
                if (passwordController.text == "1968")
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Minions(),
                      ),
                    )
                  }
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'please enter the correct password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    )
                  }
              },
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
