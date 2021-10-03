import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:mobile_app/models/CreditCard.dart' as CreditCardObject;

class StripeResponse {
  late String message;
  late bool success;

  StripeResponse({required this.message, required this.success});
}

class StripeService {
  static String publicApiKey = dotenv.get("PUBLIC_STRIPE_API_KEY");
  static String secretApiKey = dotenv.get("PRIVATE_STRIPE_API_KEY");
  static String apiURL = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '$apiURL/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer $secretApiKey',
    'Content-Type': 'application/json'
  };
  static void init() {
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: dotenv.get("PUBLIC_STRIPE_API_KEY"),
          merchantId: "Test",
          androidPayMode: 'test'),
    );
  }

  static Future<CreditCardObject.CreditCard?> createPaymentMethod({
    required String number,
    required int month,
    required int year,
    required String cvc,
    required String name,
  }) async {
    CreditCard card = CreditCard(
      number: number,
      expMonth: month,
      expYear: year,
      country: "US",
      name: name,
      cvc: cvc,
    );
    try {
      var request = PaymentMethodRequest(card: card);
      final token = await StripePayment.createPaymentMethod(request);
      print("token: " + jsonEncode(token));
      if (token.id == null) {
        return null;
      }
      return CreditCardObject.CreditCard(
        last4: token.card!.last4 ?? " ",
        expMonth: token.card!.expMonth ?? 0,
        expYear: token.card!.expYear ?? 0,
        nameOnCard: token.card!.name ?? " ",
        cvc: cvc,
        paymentMethodId: token.id ?? " ",
        brand: token.card!.brand ?? null,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}
  
