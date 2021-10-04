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
    required String cvc,
    required int expMonth,
    required int expYear,
    required String paymentMethodId,
    required String last4,
    String? brand,
  }) {
    this.nameOnCard = nameOnCard;
    this.paymentMethodId = paymentMethodId;
    this.cvc = cvc;
    this.last4 = last4;
    this.expYear = expYear;
    this.expMonth = expMonth;
    this.brand = brand;
  }

  static List<CreditCard> creditCardFromFireBase() {
    List<CreditCard> creditcards = [];
    //TODO: api call to get list of Credit cards
    creditcards.add(
      CreditCard(
        nameOnCard: "Ahmed Elshetany",
        cvc: "123",
        expMonth: 9,
        expYear: 2025,
        paymentMethodId: "pm_unique_id",
        last4: "1234",
        brand: "visa",
      ),
    );
    return creditcards;
  }
}
