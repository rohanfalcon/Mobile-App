
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../assets/brbGlobals.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
                  child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                  DrawerHeader(
                  decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                      ),
                      child: Text('Be Right Back',
                          style: TextStyle(
                          fontSize: 15,
                          color: Colors.white),),
                      ),
                      ListTile(
                      title: const Text('Privacy Policy',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent)),
                      onTap: () async {
                        final Uri url = Uri.parse('https://firebasestorage.googleapis.com/v0/b/brb-project-234ba/o/BrB%20Parking%20Privacy%20Policy.html?alt=media&token=25e5f560-8d51-48ae-a740-a4ef50467f9b');
                        if (await launchUrl(url)) {
                        await launchUrl(url);
                        } else {
                        throw 'Could not launch $url';
                        }
                      },
                      ),
                      // Hot to
                    ListTile(
                      title: const Text('How To',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent)),
                      onTap: () async {
                        final Uri url = Uri.parse('https://firebasestorage.googleapis.com/v0/b/brb-project-234ba/o/brb%20how%20to%20page2.html?alt=media&token=2d40a666-c1a1-4485-8ccc-ac21d3f424f9');
                        if (await launchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                      ListTile(

                            title: const Text('Back',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blueAccent)),
                            onTap: () {
                            Navigator.pop(context);
                            },
                            ),
                            ],
                            ),
                            ),

        appBar: AppBar(
          backgroundColor: const Color(0xffff9900),
          title: const Text('Welcome to BRB',style:TextStyle(color: Colors.white)),
          // ]
        ),
        body:  Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/shea.jpg"),
              fit: BoxFit.cover,
            ),
          ),


          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                //padding: const EdgeInsets.fromLTRB(100,50, 95,10),
                padding: const EdgeInsets.fromLTRB(100,20, 95,10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                  [
                    Image.asset(
                      'lib/assets/brblogo.png',
                      fit: BoxFit.contain,
                      height: 90,
                      width:  100,
                    ),

                    Container( // button Container
                      padding: const EdgeInsets.fromLTRB(0,50,0,10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50), backgroundColor: Colors.orange),
                        child: const Text('Continue'),
                        onPressed: () async {


                          final settings = await messaging.requestPermission(
                            alert: true,
                            announcement: false,
                            badge: true,
                            carPlay: false,
                            criticalAlert: false,
                            provisional: false,
                            sound: true,
                          );

                          String? token = await messaging.getToken();

                          if (kDebugMode) {
                            print('Permission granted: ${settings.authorizationStatus}');
                          }
                          print('this is token $token');


                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/transaction', (route) => true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Flexible (
                flex: 1,
                child: MyFooter(),
              ),
            ],

    ),
    ),
    );
  }
}


class MyFooter extends StatelessWidget{
  const MyFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return //Scaffold(
      //body:
      FooterView(
        footer: Footer(
          alignment: Alignment.bottomCenter ,
          //padding: const EdgeInsets.all(10.0),
          padding: EdgeInsets.fromLTRB(20,5, 61, 0),
          child: Text('Copyright ©2022, All Rights Reserved. \n\r Powered by Rohan Bryan LLC'),
        ),
        flex: 1,
        children:const <Widget>[
          /* Padding(
            padding: EdgeInsets.only(top:0.0),
            child: Center(
              child: Text('Scrollable View'),
            ),
          ), */
        ], //default flex is 2
        //)
      );
  }


}



class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key? key,
        required this.text,
        required this.icon,
        required this.color,
        required this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          //padding: const EdgeInsets.all(24),
          padding: const EdgeInsets.fromLTRB(2,10, 15,0),
          backgroundColor: color,
        ),
        onPressed: () => loginMethod(),
        label: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}





