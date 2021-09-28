import 'package:flutter/material.dart';

import 'package:mobile_app/models/User.dart';
// import 'package:mobile_app/util/Stripe.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:awesome_card/awesome_card.dart' as CreditCardWidget;
import 'package:mobile_app/models/CreditCard.dart' as card;
// import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  static const String id = "paymentSetup";
  @override
  _PaymentScreen createState() => _PaymentScreen();
}

class _PaymentScreen extends State<PaymentScreen> {
  bool showBack = false;
  card.CreditCard creditCard = card.CreditCard.creditCardFromFireBase();

  @override
  void initState() {
    // StripeService.init();
    super.initState();
  }

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
            GestureDetector(
              onTap: () async {
                // var response = await StripeService.payWithNewCard(amount: "21", currency: "USD");
                // print(response.message);
                // print(response.success);
                // if (response.success == true) {
                //   Scaffold.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(response.message),
                //       duration: Duration(seconds: 2),
                //     ),
                //   );
                // }
                // CreditCard card = CreditCard(
                //   number: "4242424242424242",
                //   expMonth: 2,
                //   expYear: 24,
                // );
                // var response = await StripeService.choseExistingCard(amount: "1111", card: card);
                // print(response.message);
              },
              child: Text(
                "Pass the card info here",
              ),
            ),
            Text(
              'Add Init state',
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showBack = !showBack;
                });
              },
              child: CreditCardWidget.CreditCard(
                cardNumber: creditCard.cardNumber,
                cardExpiry: creditCard.expDate,
                cardHolderName: creditCard.nameOnCard,
                cvv: creditCard.cvv,
                // bankName: "Axis Bank",
                cardType: CreditCardWidget
                    .CardType.masterCard, // Optional if you want to override Card Type
                showBackSide: showBack,
                frontBackground: CreditCardWidget.CardBackgrounds.black,
                backBackground: CreditCardWidget.CardBackgrounds.white,
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
