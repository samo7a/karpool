import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/rider/AddCreditCardScreen.dart';
import 'package:mobile_app/util/StripeService.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/models/CreditCard.dart' as card;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  static const String id = "paymentSetup";
  @override
  _PaymentScreen createState() => _PaymentScreen();
}

class _PaymentScreen extends State<PaymentScreen> {
  bool showBack = false;
  card.CreditCard creditCard = card.CreditCard.creditCardFromFireBase();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  @override
  void initState() {
    super.initState();
    cardNumber = creditCard.cardNumber;
    expiryDate = creditCard.expDate;
    cardHolderName = creditCard.nameOnCard;
    cvvCode = creditCard.cvv;
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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AddCreditCardScreen.id),
                child: Text(
                  "Add Credit Card",
                ),
              ),
              // Expanded(
              //   child: CreditCardWidget(
              //     glassmorphismConfig: useGlassMorphism ? Glassmorphism.defaultConfig() : null,
              //     cardNumber: cardNumber,
              //     expiryDate: expiryDate,
              //     cardHolderName: cardHolderName,
              //     cvvCode: cvvCode,
              //     showBackView: isCvvFocused,
              //     obscureCardNumber: true,
              //     obscureCardCvv: true,
              //     isHolderNameVisible: true,
              //     cardBgColor: Colors.red,
              //     //backgroundImage: useBackgroundImage ? 'assets/card_bg.png' : null,
              //     isSwipeGestureEnabled: true,
              //     onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
