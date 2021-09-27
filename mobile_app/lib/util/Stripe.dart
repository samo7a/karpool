import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeResponse {
  late String message;
  late bool success;

  StripeResponse({required this.message, required this.success});
}

class StripeService {
  static String apikey = dotenv.get("PUBLIC_STRIPE_API_KEY");
  static String apiURL = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '$apiURL/payment_intents';
  static String secret = dotenv.get("PRIVATE_STRIPE_API_KEY");
  static Map<String, String> headers = {
    'Authorization': 'Bearer $secret',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: apikey,
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
    print("calling the init function from stripe.dart");
  }

  static Future<StripeResponse> choseExistingCard(
      {required String amount, required CreditCard card}) async {
    try {
      var stripePaymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      var stripePaymentIntent = await StripeService.createPaymentIntent(amount);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: stripePaymentIntent!['client_secret'],
          paymentMethodId: stripePaymentMethod.id));

      if (response.status == 'succeeded') {
        //if the payment process success
        return StripeResponse(message: 'Transaction successful', success: true);
      } else {
        //payment process fail
        return StripeResponse(message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (e) {
      return StripeService.getPlatformExceptionErrorResult(e);
    } catch (error) {
      return StripeResponse(
          //convert the error to string and assign to message variable for json resposne
          message: 'Transaction failed: ${error.toString()}',
          success: false);
    }
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(String amount) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount, // amount charged will be specified when the method is called
        'currency': "USD", // the currency
        'payment_method_types[]': 'card' //card
      };
      var response = await http.post(Uri.parse(StripeService.paymentApiUrl), //api url
          body: body, //request body
          headers: StripeService.headers //headers of the request specified in the base class
          );
      return jsonDecode(response.body); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }

  static Future<StripeResponse> payWithNewCard(
      {required String amount, required String currency}) async {
    try {
      PaymentMethod stripePaymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      ).then((PaymentMethod paymentMethod) {
        print("payment method: ${jsonEncode(paymentMethod)}");
        return paymentMethod;
      }).catchError((e) {
        print('Errore Card: ${e.toString()}');
      });
      var stripePaymentIntent = await StripeService.createPaymentIntent(amount);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: stripePaymentIntent!['client_secret'],
          paymentMethodId: stripePaymentMethod.id));

      if (response.status == 'succeeded') {
        //if the payment process success
        return StripeResponse(message: 'Transaction successful', success: true);
      } else {
        //payment process fail
        return StripeResponse(message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (error) {
      return StripeService.getPlatformExceptionErrorResult(error);
    } catch (error) {
      return StripeResponse(
        message: 'Transaction failed: ${error.toString()}',
        success: false,
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String msg = "Something went wrong";
    if (err.code == "cancelled") {
      msg = "Transaction Cancelled";
    }
    return StripeResponse(message: msg, success: false);
  }

  static void createNewCard() {
    String number = "4242424242424242";
    String expMonth = "2";
    String expYear = "24";
    CreditCard card = CreditCard(
      number: number,
      expMonth: 2,
      expYear: 24,
    );
    print(jsonEncode(card));
  }
}
