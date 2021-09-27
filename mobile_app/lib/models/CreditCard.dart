class CreditCard {
  String nameOnCard = '';
  String cvv = '';
  String expDate = '';
  String paymentMethodId = '';
  String cardNumber = '';

  CreditCard({
    required String nameOnCard,
    required String cvv,
    required String expDate,
    required String paymentMethodId,
    required String cardNumber,
  }) {
    this.nameOnCard = nameOnCard;
    this.paymentMethodId = paymentMethodId;
    this.cvv = cvv;
    this.expDate = expDate;
    this.cardNumber = cardNumber;
  }

  static CreditCard creditCardFromFireBase() {
    //TODO: api call to get payment methods
    return CreditCard(
      nameOnCard: "Ahmed Elshetany",
      cvv: "123",
      expDate: "02/25",
      paymentMethodId: "pm_unique_id",
      cardNumber: "********1234",
    );
  }
}
