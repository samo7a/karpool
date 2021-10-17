import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';

class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({Key? key}) : super(key: key);

  @override
  _DriverEarningsScreenState createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen> {
  List<FlSpot> weeklyData = [
    FlSpot(1, 4),
    FlSpot(2, 6),
    FlSpot(3, 1),
    FlSpot(4, 6),
    FlSpot(5, 4),
    FlSpot(6, 4),
    FlSpot(7, 3),
    FlSpot(8, 1),
    FlSpot(9, 0),
    FlSpot(10, 1),
    FlSpot(11, 3),
    FlSpot(12, 3),
  ];
  List<FlSpot> monthlyData = [
    FlSpot(1, 4),
    FlSpot(2, 6),
    FlSpot(3, 1),
    FlSpot(4, 6),
    FlSpot(5, 4),
    FlSpot(6, 4),
    FlSpot(7, 3),
    FlSpot(8, 1),
    FlSpot(9, 0),
    FlSpot(10, 1),
    FlSpot(11, 3),
    FlSpot(12, 1),
  ];
  int currentWeek = 0;
  int currentMonth = 0;
  void setChartData() async {}

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Container(
      color: kDashboardColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Weekly Earnings"),
            SizedBox(
              height: size.BLOCK_HEIGHT * 30,
              width: size.BLOCK_WIDTH * 90,
              child: LineChart(
                LineChartData(
                  axisTitleData: FlAxisTitleData(
                    leftTitle: AxisTitle(titleText: "Earnings", reservedSize: 10, showTitle: true),
                    bottomTitle: AxisTitle(titleText: "Months", reservedSize: 10, showTitle: true),
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
                        fontSize: size.FONT_SIZE * 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leftTitles: SideTitles(
                      margin: size.BLOCK_WIDTH * 2,
                      showTitles: true,
                      reservedSize: size.BLOCK_WIDTH * 3,
                      getTextStyles: (_, value) => TextStyle(
                        color: Colors.white,
                        fontSize: size.FONT_SIZE * 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // borderData: FlBorderData(
                  //   show: true,
                  //   border: Border(
                  //     color: Colors.blue,
                  //     width: 1,
                  //   ),
                  // ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.black,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.black,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  minX: 1,
                  maxX: 12,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      colors: [Colors.white, Colors.black],
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.white, Colors.black],
                      ),
                      spots: weeklyData,
                    ),
                  ],
                ),
                swapAnimationDuration: Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              ),
            ),
            Text("Monthly Earnings"),
            SizedBox(
              height: size.BLOCK_HEIGHT * 30,
              width: size.BLOCK_WIDTH * 100,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 6,
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData,
                    )
                  ],
                  // isShowingMainData ? sampleData1() : sampleData2(),
                ),
                swapAnimationDuration: Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
