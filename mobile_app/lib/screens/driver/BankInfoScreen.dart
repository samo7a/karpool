import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BankInfoScreen extends StatefulWidget {
  const BankInfoScreen({Key? key}) : super(key: key);
  static const String id = "bankInfo";
  @override
  _BankInfoScreen createState() => _BankInfoScreen();
}

class _BankInfoScreen extends State<BankInfoScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String initAccountNum = '123456789';
  String initRoutingNum = '987654321';
  String newAccountNum = '';
  String newRoutingNum = '';

  // TODO: get user from user object (either as argument or call user)
  // getting account number and routing number will be added to getUser on backend

  // @override
  // void initState() {
  //   super.initState();
  //   // getOriginalInfo();
  // }

  // use this if getUser does not include routing/account num, make
  // sure backend has a function deployed for getBankInfo in this case...
  /*void getOriginalInfo() async {
    HttpsCallable getInfo =
        FirebaseFunctions.instance.httpsCallable("account-getBankInfo");
    Map<String, dynamic> obj = {
      "uid": user.uid,
    };
    try {
      print("inside the try");
      final result = await getInfo(obj);
      final data = result.data;
      print(result);
      print(data);
      // TODO: store data from response in initAccountNum, initRoutingNum
    } catch (e) {
      EasyLoading.showError("Error retrieving bank information.");
    }
  }*/

  // void updateBankInfo() async {
  //   if (newAccountNum == '') newAccountNum = initAccountNum;
  //   if (newRoutingNum == '') newRoutingNum = initRoutingNum;

  //   HttpsCallable getInfo =
  //       FirebaseFunctions.instance.httpsCallable("account-updateBankInfo");
  //   Map<String, dynamic> obj = {
  //     "uid": user.uid,
  //     "accountNum": newAccountNum,
  //     "routingNum": newRoutingNum,
  //   };
  //   try {
  //     print("inside the try");
  //     final result = await getInfo(obj);
  //     final data = result.data;
  //     print(result);
  //     print(data);
  //   } catch (e) {
  //     EasyLoading.showError("Error updating bank information.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
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
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
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
                Container(
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
                        RequiredValidator(
                            errorText: "Routing Number is Required!"),
                        MinLengthValidator(9,
                            errorText: "Please enter a valid Routing Number!"),
                        MaxLengthValidator(9,
                            errorText: "Please enter a valid Routing Number!"),
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
                SizedBox(
                  height: size.BLOCK_HEIGHT * 5,
                ),
                Text(
                  initAccountNum,
                  style: TextStyle(
                    fontSize: size.FONT_SIZE * 18,
                    color: kWhite,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT,
                ),
                Container(
                  child: TextFormField(
                    onChanged: (value) => setState(() {
                      newAccountNum = value;
                    }),
                    initialValue: '987654321',
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
                        RequiredValidator(
                            errorText: "Account Number is Required!"),
                        MinLengthValidator(9,
                            errorText: "Please enter a valid Account Number!"),
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
                SizedBox(
                  height: size.BLOCK_HEIGHT * 5,
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
                                  // TODO: updateBankInfo();
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
