import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyPieChart extends StatefulWidget {

  String effectOrSideEffect;
  double effectGood;
  double effectSoso;
  double effectBad;
  double sideEffectYes;
  double sideEffectNo;

  MyPieChart(this.effectOrSideEffect, this.effectGood, this.effectSoso, this.effectBad, this.sideEffectYes, this.sideEffectNo);

  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  static const green = Color(0xff88F0BE);
  static const yellow = Color(0xffFED74D);
  static const red = Color(0xffFF7070);


  @override
  Widget build(BuildContext context) {
    double effectSum = (widget.effectGood + widget.effectSoso + widget.effectBad) *1.0;
    double effectGood = (widget.effectGood/effectSum)*100;
    double effectSoso = (widget.effectSoso/effectSum)*100;
    double effectBad = (widget.effectBad/effectSum)*100;

    double sideEffectSum = (widget.sideEffectYes + widget.sideEffectNo)*1.0;
    double sideEffectYes = (widget.sideEffectYes/sideEffectSum)*100;
    double sideEffectNo = (widget.sideEffectNo/sideEffectSum)*100;

    List<PieChartSectionData> effect = [
      if(widget.effectGood != 0)
        PieChartSectionData(
          color: green,
          value: effectGood,
          title: 'good',
          radius: 18,
          titleStyle: TextStyle(color: Colors.white, fontSize:12),
        ),
      if(widget.effectSoso != 0)
        PieChartSectionData(
          color: yellow,
          value: effectSoso,
          title: 'soso',
          radius: 18,
          titleStyle: TextStyle(color: Colors.white, fontSize:12),
        ),
      if(widget.effectBad != 0)
        PieChartSectionData(
          color: red,
          value: effectBad,
          title: 'bad',
          radius: 18,
          titleStyle: TextStyle(color: Colors.white, fontSize:12),
        )
    ];

    List<PieChartSectionData> sideEffect = [
      if(widget.sideEffectYes != 0)
        PieChartSectionData(
          color: red,
          value: sideEffectYes,
          title: 'yes',
          radius: 18,
          titleStyle: TextStyle(color: Colors.white, fontSize:12),
        ),
      if(widget.sideEffectNo != 0)
        PieChartSectionData(
          color: green,
          value: sideEffectNo,
          title: 'no',
          radius: 18,
          titleStyle: TextStyle(color: Colors.white, fontSize:12),
        )
    ];

    return  Container(
      width: 100,
      height: 100,
      child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sections: widget.effectOrSideEffect == "effect" ? effect : sideEffect,
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 20,
              sectionsSpace: 1,
            ),
          )
      ),
    );

  }
}
