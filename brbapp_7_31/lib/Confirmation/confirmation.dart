import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Services/Auth.dart';
import '../assets/brbGlobals.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({ Key? key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();

}
//@override
//_ConfirmationScreenState createState() => _ConfirmationScreenState();



class _ConfirmationScreenState extends State<ConfirmationScreen> {

  @override
  void dispose() {
    //_ConfirmationScreenState.dispose();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffff9900),
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/transaction');
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
        title: const Text('Transaction successful'),
      ),
      body:  ListView(
        padding: const EdgeInsets.fromLTRB(30,25,20,0),
        children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:  [
                      Lottie.asset('lib/assets/check.json',
                          width: 300,
                          height: 300,
                         ),

                        ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(Colors.deepPurple),
                            ),
                            child: const Text('sign out'),
                            onPressed: () async {
                              await AuthService().signOut();
                              login = false;
                              guestAccess=false;
                              if(context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (route) => false);
                              }
                            }),
                  ]
                  ),


                      ],
      )



    );

  }

}    // class ends









