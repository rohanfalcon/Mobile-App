import 'dart:io';

import 'package:brbapp/assets/brbGlobals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyImagePicker(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyImagePicker> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyImagePicker> {
  File? image;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool pick = false;
  bool ok = false;

  //String uid = auth.currentUser!.uid.toString();

  Future pickImage({required ImageSource source}) async {
    try {
      ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        return AlertDialog(
          title: const Text('Image Not Selected'),
          content: const Text('Try the upload again'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MyImagePicker(title: 'Chose Image'),
                ),
              ),
            ),
          ],
        );
      }

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      print('This is image $imageTemp');
      ploadImage(imageTemp);
    } on PlatformException {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Plat form issues'),
          content: const Text('Try the upload again'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MyImagePicker(title: 'Chose Image'),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future pickImageC() async {
    try {
      ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
      ); //pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
      // Rohan Upload the file
      ploadImage(imageTemp);
    } on PlatformException {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Plat form issues'),
          content: const Text('Try the upload again'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MyImagePicker(title: 'Chose Image'),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chose Image")),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              color: Colors.blue,
              child: const Text(
                "Pick Image from Gallery",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  pick = true;
                  // Navigator.pushNamed(context, '/imagePicker');
                });
                pickImage(source: ImageSource.gallery);
              },
            ),
            MaterialButton(
              color: Colors.blue,
              child: const Text(
                "Pick Image from Camera",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                pickImageC();
              },
            ),
            const SizedBox(height: 20),
            Visibility(
              maintainSize: pick,
              maintainAnimation: pick,
              maintainState: pick,
              visible: pick,
              child: image != null
                  ? Image.file(image!, width: 300, height: 300)
                  : Image.asset(
                      'lib/assets/rainbow.gif',
                      fit: BoxFit.contain,
                      height: 300,
                      width: 300,
                    ),
            ),
            Visibility(
              maintainSize: !pick,
              maintainAnimation: !pick,
              maintainState: !pick,
              visible: !pick,
              child: image != null
                  ? Image.file(image!)
                  : const Text("No image selected"),
            ),
            // con// const Text("No image selected"),
            // put a back navigation button here for the form submittal
            Visibility(
              maintainSize: ok,
              maintainAnimation: ok,
              maintainState: ok,
              visible: ok,
              child: ElevatedButton(
                onPressed: () {
                  // final form = _formKey.currentState!;
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ),
            //Wheel
            Visibility(
              maintainSize: !ok,
              maintainAnimation: !ok,
              maintainState: !ok,
              visible: !ok,
              child: Image.asset(
                'lib/assets/rainbow.gif',
                fit: BoxFit.contain,
                height: 90,
                width: 90,
              ),
            ),

            // Wheel Ends
          ],
        ),
      ),
    );
  }

  // post the image
  ploadImage(img) async {
    final user = brbuser;
    // Initialize Firebase once again
    await Firebase.initializeApp();

    String name = img.hashCode.toString();
    print('this is name $name');

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('$name.png')
          .putFile(img);
      const LinearProgressIndicator();
      // snapshot

      await firebase_storage.FirebaseStorage.instance
          .ref('$name.png')
          .getDownloadURL()
          .then((result) {
            if (context.mounted) {
              setState(() {
                globalFileName = result
                    .toString(); //use toString to convert as String
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Image Loaded')));
              if (globalFileName.length < 10) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('File Issue'),
                    content: const Text('Try the upload again'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
                setState(() {
                  ok = false;
                });
              } else {
                setState(() {
                  ok = true;
                });
              }
            }
          });
      //print ('this is url file $globalFileName');
      user.fileName = globalFileName;
      user.save(user, "append");
    } on firebase_storage.FirebaseException {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Storage Exception'),
            content: const Text('Try the upload again'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      } //on
    }
  }
}
