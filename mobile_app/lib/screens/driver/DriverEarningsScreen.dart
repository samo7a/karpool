import 'package:cloud_functions/cloud_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/rounded-button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({Key? key}) : super(key: key);

  @override
  _DriverEarningsScreenState createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen> {
  late User user = Provider.of<User>(context, listen: false);
  List<FlSpot> monthlyData = [];
  List<double> weeklyData = [];
  int currentWeek = 0;
  int weekIndex = 0;
  double weekEarning = 0;
  double maxY = 1;
  String startOfWeek = '';
  String endOfWeek = '';

  void setChartData() async {
    HttpsCallable getEarnings = FirebaseFunctions.instance.httpsCallable("account-getEarnings");
    try {
      final result = await getEarnings();
      int weeklyDataLength = result.data[0].length;
      // print(result.data[0].length); //weeks
      for (int i = 0; i < weeklyDataLength; i++) {
        weeklyData.add(result.data[0][i]["amount"] * 1.0);
      }
      setState(() {
        weekEarning = weeklyData[weekIndex - 1];
      });
      //print(result.data[1]); // months
      for (int i = 0; i < 12; i++) {
        double val = result.data[1][i]["amount"] * 1.0;
        if (val > maxY)
          setState(() {
            maxY = val;
          });
        setState(() {
          monthlyData.add(FlSpot(double.parse(i.toString()), val));
        });
        if (maxY == 0)
          setState(() {
            maxY = 10;
          });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  void setDateRange() {
    final date = new DateTime.now();
    final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
    print(currentWeek);
    print(weekIndex);
    DateTime start = startOfYear.add(Duration(days: 7 * weekIndex - 4));
    DateTime end = startOfYear.add(Duration(days: 7 * weekIndex + 2));
    setState(() {
      startOfWeek = start.month.toString() + "-" + start.day.toString();
      endOfWeek = end.month.toString() + "-" + end.day.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    currentWeek = weekNumber(DateTime.now());
    weekIndex = currentWeek;
    setChartData();
    setDateRange();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Container(
      color: kDashboardColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.BLOCK_HEIGHT * 2.5,
            ),
            Text(
              "2021 Earnings",
              style: TextStyle(
                fontFamily: "Glory",
                fontSize: size.FONT_SIZE * 22,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ),
            SizedBox(
              height: size.BLOCK_HEIGHT * 2.5,
            ),
            Column(
              children: [
                Text(
                  "Earnings from Monday $startOfWeek \nto Sunday $endOfWeek",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Glory",
                    fontSize: size.FONT_SIZE * 22,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      child: Icon(Icons.remove),
                      onPressed: () {
                        if (weekIndex == 0) return null;
                        setState(() {
                          weekIndex--;
                          weekEarning = weeklyData[weekIndex - 1];
                        });

                        setDateRange();
                      },
                    ),
                    Text(
                      "\$$weekEarning",
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: size.FONT_SIZE * 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        if (weekIndex == currentWeek) return null;
                        setState(() {
                          weekIndex++;
                          weekEarning = weeklyData[weekIndex - 1];
                        });
                        setDateRange();
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.BLOCK_HEIGHT * 2.5,
            ),
            Text(
              "Monthly Earnings",
              style: TextStyle(
                fontFamily: "Glory",
                fontSize: size.FONT_SIZE * 22,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ),
            SizedBox(
              height: size.BLOCK_HEIGHT * 2.5,
            ),
            SizedBox(
              height: size.BLOCK_HEIGHT * 30,
              width: size.BLOCK_WIDTH * 90,
              child: LineChart(
                LineChartData(
                  axisTitleData: FlAxisTitleData(
                    leftTitle: AxisTitle(
                      titleText: "Earnings in \$",
                      reservedSize: 10,
                      showTitle: true,
                      textStyle: TextStyle(
                        fontSize: size.FONT_SIZE * 15,
                        color: kWhite,
                      ),
                    ),
                    bottomTitle: AxisTitle(
                      titleText: "Months",
                      reservedSize: 10,
                      showTitle: true,
                      textStyle: TextStyle(
                        fontSize: size.FONT_SIZE * 15,
                        color: kWhite,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: SideTitles(
                      showTitles: false,
                    ),
                    rightTitles: SideTitles(
                      showTitles: false,
                    ),
                    bottomTitles: SideTitles(
                        margin: size.BLOCK_WIDTH * 2,
                        showTitles: true,
                        reservedSize: size.BLOCK_WIDTH * 3,
                        getTextStyles: (_, value) => TextStyle(
                              color: Colors.white,
                              fontSize: size.FONT_SIZE * 5,
                              fontWeight: FontWeight.bold,
                            ),
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 0:
                              return 'Jan.';
                            case 1:
                              return 'Feb.';
                            case 2:
                              return 'Mar.';
                            case 3:
                              return 'Apr.';
                            case 4:
                              return 'May';
                            case 5:
                              return 'Jun.';
                            case 6:
                              return 'Jul.';
                            case 7:
                              return 'Aug.';
                            case 8:
                              return 'Sept.';
                            case 9:
                              return 'Oct.';
                            case 10:
                              return 'Nov.';
                            case 11:
                              return 'Dec.';
                          }
                          return '';
                        }),
                    leftTitles: SideTitles(
                      margin: size.BLOCK_WIDTH * 2,
                      interval: maxY / 4,
                      showTitles: true,
                      reservedSize: size.BLOCK_WIDTH * 6,
                      getTextStyles: (_, value) => TextStyle(
                        color: Colors.white,
                        fontSize: size.FONT_SIZE * 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.black12,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.black12,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      colors: [Color(0xff001845), Color(0xff001845)],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      spots: monthlyData,
                    ),
                  ],
                ),
                swapAnimationDuration: Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              ),
            ),
            SizedBox(
              height: size.BLOCK_HEIGHT * 5,
            ),
          ],
        ),
      ),
    );
  }
}
