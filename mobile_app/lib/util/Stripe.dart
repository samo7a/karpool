import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeResponse {
  late String message;
  late bool success;

  StripeResponse({required this.message, required this.success});
}

class StripeService {
  static String baseUrl = "https://api.stripe.com//v1";
  static String apikey = dotenv.get("PUBLIC_STRIPE_API_KEY");
  static init() {}

  static StripeResponse pay({required String amount, required String currency, card}) {
    return StripeResponse(
      message: "Transaction Successfull",
      success: true,
    );
  }
}
