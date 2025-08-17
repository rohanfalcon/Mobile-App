import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({ Key? key}) : super(key: key);

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
        body:  Container(child: ListView(
                    children: [Lottie.asset('lib/assets/check.json')],
                    )
                   /*Container(
                  decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("lib/assets/Check.png"),
                  fit: BoxFit.scaleDown,  //cover
                  )
                  )
            ),*/
      
    ),
    );
  }    // widget
  }


