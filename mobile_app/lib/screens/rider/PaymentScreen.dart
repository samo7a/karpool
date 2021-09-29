import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:awesome_card/awesome_card.dart' as CreditCardWidget;
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/rider/AddCreditCardScreen.dart';
import 'package:mobile_app/util/Size.dart';
// import 'package:mobile_app/util/StripeService.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/models/CreditCard.dart' as CreditCardObject;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  static const String id = "paymentSetup";
  @override
  _PaymentScreen createState() => _PaymentScreen();
}

class _PaymentScreen extends State<PaymentScreen> {
  // bool showBack = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<CreditCardObject.CreditCard> creditCards;
  List<bool> showBack = [];

  @override
  void initState() {
    super.initState();
    creditCards = CreditCardObject.CreditCard.creditCardFromFireBase();
    for (int i = 0; i < creditCards.length; i++) {
      showBack.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    final user = ModalRoute.of(context)!.settings.arguments as User; 

    // final card = ModalRoute.of(context)!.settings.arguments as card;

    // String email = user.email;  later;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          CreditCardObject.CreditCard? card = await Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => AddCreditCardScreen(),
            ),
          );
          if (card == null) return;
          setState(() {
            creditCards.add(card);
            showBack.add(false);
          });
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: kButtonColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: size.BLOCK_HEIGHT * 3,
        ),
        padding: EdgeInsets.only(bottom: size.BLOCK_HEIGHT * 10),
        itemCount: creditCards.length,
        itemBuilder: (BuildContext context, int index) {
          final creditCard = creditCards[index];
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(creditCard.paymentMethodId),
            onDismissed: (direction) async {
              // TODO: Api call to delete card
              creditCards.removeAt(index);
              showBack.removeAt(index);
            },
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 7),
                    ),
                    title: Text(
                      "Confirm Ride Cancellation",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to cancel your ride?",
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 22,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Container(
                          height: size.BLOCK_HEIGHT * 7,
                          width: size.BLOCK_WIDTH * 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 5),
                            color: Color(0xff001233),
                          ),
                          child: Center(
                            child: Text(
                              "No",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffffffff),
                                fontFamily: 'Glory',
                                fontWeight: FontWeight.bold,
                                fontSize: size.FONT_SIZE * 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: size.BLOCK_WIDTH * 2.5),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Container(
                            height: size.BLOCK_HEIGHT * 7,
                            width: size.BLOCK_WIDTH * 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 5),
                              color: Color(0xffC80404),
                            ),
                            child: Center(
                              child: Text(
                                "Yes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontFamily: 'Glory',
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.FONT_SIZE * 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    backgroundColor: Color(0xff0353A4),
                  );
                },
              );
            },
            background: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delete Card',
                    style: TextStyle(
                      color: kWhite,
                      fontFamily: 'Glory',
                      fontWeight: FontWeight.bold,
                      fontSize: size.FONT_SIZE * 26,
                    ),
                  ),
                  SizedBox(
                    width: size.BLOCK_WIDTH * 2,
                  ),
                  Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                    size: size.FONT_SIZE * 30,
                  ),
                ],
              ),
              color: kRed,
            ),
            child: GestureDetector(
              onTap: () => setState(() {
                showBack[index] = !showBack[index];
              }),
              child: CreditCardWidget.CreditCard(
                cardNumber: "**** **** **** " + creditCard.last4,
                cardExpiry:
                    creditCard.expMonth.toString() + "/" + (creditCard.expYear - 2000).toString(),
                cardHolderName: creditCard.nameOnCard,
                cvv: creditCard.cvc,
                showBackSide: showBack[index],
                cardType: (creditCard.brand == "visa")
                    ? CreditCardWidget.CardType.visa
                    : (creditCard.brand == "diners")
                        ? CreditCardWidget.CardType.dinersClub
                        : (creditCard.brand == "discover")
                            ? CreditCardWidget.CardType.discover
                            : (creditCard.brand == "amex")
                                ? CreditCardWidget.CardType.americanExpress
                                : (creditCard.brand == "jcb")
                                    ? CreditCardWidget.CardType.jcb
                                    : (creditCard.brand == "mastercard")
                                        ? CreditCardWidget.CardType.masterCard
                                        : CreditCardWidget.CardType.other,
                frontBackground: CreditCardWidget.CardBackgrounds.black,
                backBackground: CreditCardWidget.CardBackgrounds.white,
                showShadow: true,
                textExpDate: 'Exp. Date',
                textName: 'Name',
                textExpiry: 'MM/YY',
              ),
            ),
          );
        },
      ),
    );
  }
}
