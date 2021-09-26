import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:mobile_app/models/CreditCard.dart' as card;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  static const String id = "paymentSetup";
  @override
  _PaymentScreen createState() => _PaymentScreen();
}

class _PaymentScreen extends State<PaymentScreen> {
  String test = dotenv.get('test', fallback: "error");
  bool showBack = false;
  card.CreditCard creditCard = card.CreditCard.creditCardFromFireBase();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    // final card = ModalRoute.of(context)!.settings.arguments as card;

    // String email = user.email;  later;

    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text("Payment"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
        ),
      ),
      body: Center(
        child: Column(
          // just for testing
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Card Info for riders',
            ),
            Text(
              "Pass the card info here",
            ),
            Text(
              'Add Init state $test',
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showBack = !showBack;
                });
              },
              child: CreditCard(
                cardNumber: creditCard.cardNumber,
                cardExpiry: creditCard.expDate,
                cardHolderName: creditCard.nameOnCard,
                cvv: creditCard.cvv,
                // bankName: "Axis Bank",
                cardType: CardType.masterCard, // Optional if you want to override Card Type
                showBackSide: showBack,
                frontBackground: CardBackgrounds.black,
                backBackground: CardBackgrounds.white,
                showShadow: true,
                textExpDate: 'Exp. Date',
                textName: 'Name',
                textExpiry: 'MM/YY',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
