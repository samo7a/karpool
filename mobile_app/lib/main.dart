import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/screens/EditProfileScreen.dart';
// import 'package:mobile_app/models/User.dart' as user; //I will need it later
import 'package:mobile_app/screens/MainScreen.dart';
import 'package:mobile_app/screens/driver/BankInfoScreen.dart';
import 'package:mobile_app/screens/driver/ScheduleScreen.dart';
import 'package:mobile_app/screens/driver/VehicleInfoScreen.dart';
import 'package:mobile_app/screens/rider/DriverApplication.dart';
import 'package:mobile_app/screens/rider/PaymentScreen.dart';
import 'package:mobile_app/screens/screens.dart';
import 'package:mobile_app/util/Auth.dart';
import 'package:mobile_app/util/Stripe.dart';
import './screens/SplashScreen.dart';
import 'package:provider/provider.dart';
import './screens/RegisterScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/driver/DriverDashboardScreen.dart';
import 'screens/rider/RiderDashboardScreen.dart';
import 'screens/driver/ScheduleScreen.dart';
import 'screens/ForgotPassword.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'screens/rider/SearchRidesScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  // StripeService.init();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<Auth>(
            create: (_) => Auth(FirebaseAuth.instance),
          ),
          StreamProvider(
            initialData: null,
            create: (context) => context.read<Auth>().user,
          ),
          // ChangeNotifierProvider<>(
          //   create: (context) => user(),
          // ), // need it later, do not delete it.
        ],
        builder: (context, child) {
          return MaterialApp(
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.id,
            routes: {
              SplashScreen.id: (context) => SplashScreen(),
              MainScreen.id: (context) => MainScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              RegisterScreen.id: (context) => RegisterScreen(),
              ForgotPassword.id: (context) => ForgotPassword(),
              DriverDashboardScreen.id: (context) => DriverDashboardScreen(),
              RiderDashboardScreen.id: (context) => RiderDashboardScreen(),
              EditProfilScreen.id: (context) => EditProfilScreen(),
              ScheduleScreen.id: (context) => ScheduleScreen(),
              SearchRidesScreen.id: (context) => SearchRidesScreen(),
              BankInfoScreen.id: (context) => BankInfoScreen(),
              VehicleInfoScreen.id: (context) => VehicleInfoScreen(),
              PaymentScreen.id: (context) => PaymentScreen(),
              DriverApplication.id: (context) => DriverApplication(),
            },
          );
        });
  }
}
