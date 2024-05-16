import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_speak_talk/utils/extensions/color_extensions.dart';
import '../resources/app_colors.dart';

class AchieveBarChart extends StatefulWidget {
  final List<int> messageCounts;

  const AchieveBarChart({super.key, required this.messageCounts});

  @override
  State<StatefulWidget> createState() => AchieveBarChartState();
}

class AchieveBarChartState extends State<AchieveBarChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _AchieveBarChart(messageCounts: widget.messageCounts),
    );
  }
}

class _AchieveBarChart extends StatelessWidget {
  final List<int> messageCounts;

  const _AchieveBarChart({required this.messageCounts});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        backgroundColor: Colors.white.withOpacity(0.15),
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: AppColors.contentColorCyan,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppColors.contentColorBlue.darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '월';
        break;
      case 1:
        text = '화';
        break;
      case 2:
        text = '수';
        break;
      case 3:
        text = '목';
        break;
      case 4:
        text = '금';
        break;
      case 5:
        text = '토';
        break;
      case 6:
        text = '일';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      AppColors.contentColorBlue.darken(20),
      AppColors.contentColorCyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups {
    // Get today's date
    DateTime now = DateTime.now();
    DateTime thisMonday = now.subtract(Duration(days: now.weekday - 1));
    List<BarChartGroupData> barDataList = [];

    // Iterate over 7 days (a week)
    for (int i = 0; i < 7; i++) {
      DateTime currentDate = thisMonday.add(Duration(days: i));
      int dayOfWeek = (currentDate.weekday % 7);
      int messageCountsIndex = dayOfWeek;
      int count = messageCountsIndex >= 0 ? messageCounts[messageCountsIndex] : 0;
      barDataList.add(BarChartGroupData(
        x: i, // Use i directly as x value
        barRods: [
          BarChartRodData(
            toY: count.toDouble(), // Set y value directly
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      ));
    }
    return barDataList;
  }
}