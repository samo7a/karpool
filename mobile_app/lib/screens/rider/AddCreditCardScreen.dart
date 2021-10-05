//working
import 'package:awesome_card/awesome_card.dart' as CreditCardWidget;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/StripeService.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/models/CreditCard.dart' as CreditCardObject;
import 'package:mobile_app/widgets/rounded-button.dart';

class AddCreditCardScreen extends StatefulWidget {
  const AddCreditCardScreen({Key? key}) : super(key: key);
  static const String id = "addCreditCard";
  @override
  _AddCreditCardScreen createState() => _AddCreditCardScreen();
}

class _AddCreditCardScreen extends State<AddCreditCardScreen> {
  bool showBack = false;
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;

  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    StripeService.init();
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    cardNumber = 'XXXX XXXX XXXX XXXX';
    expiryDate = 'XX/XX';
    cardHolderName = 'Card Holder';
    cvvCode = 'XXXX';
    super.initState();
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
    });
  }

  Future<CreditCardObject.CreditCard?> addCard() async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      print('invalid!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Add a Valid Credit Card!'),
        ),
      );
      return null;
    }
    String monthString = expiryDate.substring(0, 2);
    String yearString = "20" + expiryDate.substring(3, 5);
    int month = int.parse(monthString);
    int year = int.parse(yearString);
    HttpsCallable addCreditCard = FirebaseFunctions.instance.httpsCallable("account-addCreditCard");
    try {
      final result = await StripeService.createPaymentMethod(
        number: cardNumber,
        cvc: cvvCode,
        month: month,
        year: year,
        name: cardHolderName,
      );
      // print(result!.nameOnCard);
      // print(result.cvc);
      // print(result.expMonth);
      // print(result.expYear);
      // print(result.paymentMethodId);
      // print(result.last4);
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Process Cancelled!"),
          ),
        );
        Navigator.pop(context, null);
      } else {
        print("adding credit cards to firebase");
        Map<String, String> obj = {"cardToken": result.paymentMethodId};
        await addCreditCard(obj);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Card Added Successfully"),
          ),
        );
        Navigator.pop(
          context,
          CreditCardObject.CreditCard(
            nameOnCard: cardHolderName,
            expMonth: result.expMonth,
            expYear: result.expYear,
            paymentMethodId: result.paymentMethodId,
            last4: result.last4,
            brand: result.brand,
          ),
        );
      }
    } catch (e) {
      print("error adding a card: " + e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error Occured, please try again!"),
        ),
      );
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xff33415C),
        appBar: AppBar(
          backgroundColor: Color(0xff33415C),
          title: Text("Add Credit Card"),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: kWhite,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.BLOCK_HEIGHT * 2,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  showBack = !showBack;
                }),
                child: CreditCardWidget.CreditCard(
                  cardNumber: cardNumber,
                  cardExpiry: expiryDate,
                  cardHolderName: cardHolderName,
                  cvv: cvvCode,
                  showBackSide: showBack,
                  frontBackground: CreditCardWidget.CardBackgrounds.black,
                  backBackground: CreditCardWidget.CardBackgrounds.white,
                  showShadow: true,
                  textExpDate: 'Exp. Date',
                  textName: 'Name',
                  textExpiry: 'MM/YY',
                ),
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT * 2,
              ),
              CreditCardForm(
                formKey: formKey,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                themeColor: Colors.blue,
                textColor: Colors.white,
                cardNumberDecoration: InputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                expiryDateDecoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.white),
                  labelStyle: const TextStyle(color: Colors.white),
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'Card Holder',
                ),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT * 2,
              ),
              RoundedButton(
                buttonName: "Add Card",
                onClick: addCard,
                color: 0xff1b447b,
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
