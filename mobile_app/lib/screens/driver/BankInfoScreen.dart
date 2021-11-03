import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class BankInfoScreen extends StatefulWidget {
  const BankInfoScreen({Key? key}) : super(key: key);
  static const String id = "bankInfo";
  @override
  _BankInfoScreen createState() => _BankInfoScreen();
}

class _BankInfoScreen extends State<BankInfoScreen> {
  GlobalKey<FormState> routingKey = GlobalKey<FormState>();
  GlobalKey<FormState> accountKey = GlobalKey<FormState>();
  late final user = Provider.of<User>(context, listen: false);

  String initAccountNum = '';
  String initRoutingNum = '';
  String newAccountNum = '';
  String newRoutingNum = '';

  bool validateInput() {
    bool res1 = false;
    bool res2 = false;
    if (routingKey.currentState!.validate()) res1 = true;
    if (accountKey.currentState!.validate()) res2 = true;

    if (res1 && res2)
      return true;
    else
      return false;
  }

  void updateBankInfo() async {
    if ((newAccountNum == '' && newRoutingNum == '') ||
        (newAccountNum == initAccountNum && newRoutingNum == initRoutingNum)) {
      EasyLoading.showError("Bank information already exists.");
      return;
    }

    if (!validateInput()) {
      EasyLoading.showError("Please fix your input and try again.");
      return;
    }

    if (newAccountNum == '') newAccountNum = initAccountNum;
    if (newRoutingNum == '') newRoutingNum = initRoutingNum;

    HttpsCallable getInfo =
        FirebaseFunctions.instance.httpsCallable("account-setBankAccount");
    Map<String, dynamic> obj = {
      "accountNum": newAccountNum,
      "routingNum": newRoutingNum,
    };
    EasyLoading.show(status: "Updating bank information");
    try {
      print("inside the try");
      final result = await getInfo(obj);
      final data = result.data;
      print(result);
      print(data);
      EasyLoading.showSuccess("Bank information successfully updated.");
      EasyLoading.dismiss();
      user.setAccountNum = newAccountNum;
      user.setRoutingNum = newRoutingNum;
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error updating bank information.");
      print(e);
    }
  }

  Future _onRefresh() async {
    setState(() {
      initAccountNum = user.getAccountNum;
      initRoutingNum = user.getRoutingNum;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    initAccountNum = user.getAccountNum;
    initRoutingNum = user.getRoutingNum;
    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text("Bank Information"),
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.BLOCK_HEIGHT * 5,
                ),
                Text(
                  'Routing Number',
                  style: TextStyle(
                    fontSize: size.FONT_SIZE * 18,
                    color: kWhite,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT,
                ),
                Form(
                  key: routingKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Container(
                    child: TextFormField(
                      onChanged: (value) => setState(() {
                        newRoutingNum = value;
                      }),
                      initialValue: initRoutingNum,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Routing Number",
                        hintStyle: TextStyle(fontSize: size.FONT_SIZE * 15),
                        contentPadding: EdgeInsets.all(size.BLOCK_WIDTH * 2),
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: kRed,
                            width: size.BLOCK_WIDTH,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      validator: MultiValidator(
                        [
                          MinLengthValidator(9,
                              errorText:
                                  "Please enter a valid Routing Number!"),
                          MaxLengthValidator(9,
                              errorText:
                                  "Please enter a valid Routing Number!"),
                        ],
                      ),
                    ),
                    height: size.BLOCK_HEIGHT * 6,
                    width: size.BLOCK_WIDTH * 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: kWhite,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT * 3,
                ),
                Text(
                  'Account Number',
                  style: TextStyle(
                    fontSize: size.FONT_SIZE * 18,
                    color: kWhite,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT,
                ),
                Form(
                  key: accountKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Container(
                    child: TextFormField(
                      onChanged: (value) => setState(() {
                        newAccountNum = value;
                      }),
                      initialValue: initAccountNum,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Account Number",
                        hintStyle: TextStyle(fontSize: size.FONT_SIZE * 15),
                        contentPadding: EdgeInsets.all(size.BLOCK_WIDTH * 2),
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: kRed,
                            width: size.BLOCK_WIDTH,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      validator: MultiValidator(
                        [
                          MinLengthValidator(9,
                              errorText:
                                  "Please enter a valid Account Number!"),
                          MaxLengthValidator(12,
                              errorText: "Please enter a valid Account Number!")
                        ],
                      ),
                    ),
                    height: size.BLOCK_HEIGHT * 6,
                    width: size.BLOCK_WIDTH * 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: kWhite,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT * 4,
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  minWidth: size.BLOCK_WIDTH * 30,
                  height: size.BLOCK_HEIGHT * 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.green,
                  child: Text(
                    'Confirm Change',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.FONT_SIZE * 18,
                    ),
                  ),
                  onPressed: () async {
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(size.BLOCK_WIDTH * 7),
                          ),
                          title: Text(
                            "Update Bank Information",
                            style: TextStyle(
                              color: Color(0xffffffff),
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to update your bank information?",
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontFamily: 'Glory',
                              fontWeight: FontWeight.bold,
                              fontSize: size.FONT_SIZE * 22,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Container(
                                height: size.BLOCK_HEIGHT * 7,
                                width: size.BLOCK_WIDTH * 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      size.BLOCK_WIDTH * 5),
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
                              padding: EdgeInsets.only(
                                  right: size.BLOCK_WIDTH * 2.5),
                              child: TextButton(
                                onPressed: () {
                                  updateBankInfo();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: size.BLOCK_HEIGHT * 7,
                                  width: size.BLOCK_WIDTH * 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        size.BLOCK_WIDTH * 5),
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
                      barrierDismissible: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
