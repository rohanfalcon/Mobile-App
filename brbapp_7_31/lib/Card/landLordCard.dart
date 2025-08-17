// We also need the ability to delete Card as well so another one can be added

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../assets/brbGlobals.dart';

//void main() => runApp(const Card());

class landLordCard extends StatefulWidget {
  const landLordCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return landLordCardState();
  }
}

class landLordCardState extends State<landLordCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool save = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late num charge;

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.7), width: 2.0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card for payment transactions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('lib/assets/plate.jpg'),
              fit: BoxFit.fill,
            ),
            color: Colors.black,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                CreditCardWidget(
                  glassmorphismConfig: useGlassMorphism
                      ? Glassmorphism.defaultConfig()
                      : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: ' ',
                  frontCardBorder: !useGlassMorphism
                      ? Border.all(color: Colors.grey)
                      : null,
                  backCardBorder: !useGlassMorphism
                      ? Border.all(color: Colors.grey)
                      : null,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  // cardBgColor: AppColors.cardBgColor,
                  backgroundImage: useBackgroundImage
                      ? 'assets/card_bg.png'
                      : null,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  /*customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ], */
                ),
                Expanded(
                  child: ListView(
                    //SingleChildScrollView(
                    //  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Colors.orange,
                        textColor: Colors.white,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          errorStyle: const TextStyle(
                            color: Colors.lightBlueAccent,
                            backgroundColor: Colors.red,
                            fontSize: 18,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          errorStyle: const TextStyle(
                            color: Colors.lightBlueAccent,
                            backgroundColor: Colors.red,
                            fontSize: 13,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          errorStyle: const TextStyle(
                            color: Colors.lightBlueAccent,
                            backgroundColor: Colors.red,
                            fontSize: 13,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          errorStyle: const TextStyle(
                            color: Colors.lightBlueAccent,
                            backgroundColor: Colors.red,
                            fontSize: 9,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      const SizedBox(
                        height: 20, // was 20
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Save Card',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                            /*Switch(
                              value: save,
                              inactiveTrackColor: Colors.grey,
                              activeColor: Colors.white,
                              // activeTrackColor: AppColors.colorE5D1B2,
                              onChanged: (bool value) =>
                                  setState(() {
                                    save = value;
                                  }),
                            ),*/
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20, //20
                      ),
                      GestureDetector(
                        onTap: _onValidate,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),

                          padding: const EdgeInsets.symmetric(vertical: 21),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(110, 50),
                              backgroundColor: Colors.indigo,
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              // userType = 'renter';
                              _onValidate();
                            },
                          ),
                        ),
                      ),
                    ],
                    //  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onValidate() async {
    if (formKey.currentState!.validate()) {
      saveCard(
        save,
      ); // We should check if the transaction went through before saving.
      print('valid!');
    } else {
      print('invalid!');
      Navigator.pushNamed(context, '/card');
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  bool saveCard(save) {
    if (save) {
      // make this re usable
    }
    final CollectionReference card = FirebaseFirestore.instance.collection(
      'Cards',
    );
    String uid = Fireuser.toString();
    card.add({
      'Number': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'cvvCode': cvvCode,
      'userUid': uid,
    });
    Navigator.pushNamed(context, '/confirmation');
    return true;
  }

  //  End get rate
}
