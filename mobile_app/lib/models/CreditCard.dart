//working
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreditCard {
  String nameOnCard = '';
  String cvc = '';
  String paymentMethodId = '';
  String last4 = '';
  int expMonth = 0;
  int expYear = 0;
  bool isDefault = false;
  String? brand = "";

  CreditCard({
    required String nameOnCard,
    required int expMonth,
    required int expYear,
    required String paymentMethodId,
    required String last4,
    required bool isDefault,
    String? brand,
  }) {
    this.nameOnCard = nameOnCard;
    this.paymentMethodId = paymentMethodId;
    this.last4 = last4;
    this.expYear = expYear;
    this.expMonth = expMonth;
    this.brand = brand;
    this.isDefault = isDefault;
  }

  static Future<List<CreditCard>> creditCardFromFireBase() async {
    print("getting cards from firebase");
    EasyLoading.show(status: "Getting cards...");
    List<CreditCard> creditcards = [];
    HttpsCallable getCreditCards =
        FirebaseFunctions.instance.httpsCallable("account-getCreditCards");
    try {
      print("cards from credit card object file");
      var result = await getCreditCards();
      print(result.data);
      var cards = result.data;
      int length = cards.length;

      for (int i = 0; i < length; i++) {
        var card = cards[i];
        String nameOnCard = card["cardHolder"];
        int expYear = int.parse(card["expYear"]);
        int expMonth = int.parse(card["expMonth"]);
        String last4 = card["last4"];
        String paymentMethonId = card["id"];
        String brand = card["brand"];
        bool isDefault = card["isDefault"];
        creditcards.add(
          CreditCard(
            nameOnCard: nameOnCard,
            expMonth: expMonth,
            expYear: expYear,
            paymentMethodId: paymentMethonId,
            last4: last4,
            brand: brand,
            isDefault: isDefault,
          ),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error fetching cards");
      print(e.toString());
    }
    /*
    [{expMonth: 11,
     last4: 4242,
      isDefault: false, 
      expYear: 2024, 
      cardHolder: Unknown, 
      id: pm_1JhNeDJIU8d9wquzOW371PWQ, 
      brand: visa, 
      userID: SgxafpVWoPOhmHfdrggJKYafxcc2}]
    */
    EasyLoading.dismiss();
    return creditcards;
  }
}
