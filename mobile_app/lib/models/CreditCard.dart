//working
import 'package:cloud_functions/cloud_functions.dart';

class CreditCard {
  String nameOnCard = '';
  String cvc = '';
  String paymentMethodId = '';
  String last4 = '';
  int expMonth = 0;
  int expYear = 0;
  String? brand = "";

  CreditCard({
    required String nameOnCard,
    required int expMonth,
    required int expYear,
    required String paymentMethodId,
    required String last4,
    String? brand,
  }) {
    this.nameOnCard = nameOnCard;
    this.paymentMethodId = paymentMethodId;
    this.last4 = last4;
    this.expYear = expYear;
    this.expMonth = expMonth;
    this.brand = brand;
  }

  static Future<List<CreditCard>> creditCardFromFireBase() async {
    print("getting cards from firebase");
    List<CreditCard> creditcards = [];
    HttpsCallable getCreditCards =
        FirebaseFunctions.instance.httpsCallable("account-getCreditCards");
    try {
      var cards = await getCreditCards();
      print("cards from credit card object file");
      print(cards.data);
    } catch (e) {
      print(e.toString());
    }
    // creditcards.add(
    //   CreditCard(
    //     nameOnCard: "Ahmed Elshetany",
    //     cvc: "123",
    //     expMonth: 9,
    //     expYear: 2025,
    //     paymentMethodId: "pm_unique_id",
    //     last4: "1234",
    //     brand: "visa",
    //   ),
    // );
    return creditcards;
  }
}
