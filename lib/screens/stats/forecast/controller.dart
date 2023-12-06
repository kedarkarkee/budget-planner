import 'dart:convert';
import 'package:http/http.dart' as http;

import '../line_chart.dart';
import '../stat_chart.dart';

class ResponseModel {
  final List<TimeSeries> predictions;
  final num mse;
  final num sse;
  final num mpe;

  ResponseModel(this.predictions, this.mse, this.sse, this.mpe);
}

class TimeSeries {
  final DateTime date;
  final num value;

  const TimeSeries(this.date, this.value);

  TRData get trData => TRData(date.weekday, value);
}

const endPoint =
    'https://lustrous-lamington-eb925e.netlify.app/.netlify/functions/api/predict';

Future<ResponseModel?> requestPredictor(
  List<TRLineData> transactions, {
  int length = 7,
}) async {
  // final dataMap = <DateTime, num>{};
  // final cutOffDate = DateTime.now().subtract(const Duration(days: 365));
  // for (final element in transactions) {
  //   if (element.date.isBefore(cutOffDate)) {
  //     continue;
  //   }
  //   if (dataMap.containsKey(element.date)) {
  //     final newAmt = dataMap[element.date]! + element.amount;
  //     dataMap[element.date] = newAmt;
  //   } else {
  //     dataMap[element.date] = element.amount;
  //   }
  // }
  final jsonBody = json
      .encode({'data': transactions.map((e) => e.value).toList(), 'length': 7});
  try {
    final res = await http.post(
      Uri.parse(endPoint),
      body: jsonBody,
      headers: {'Content-Type': 'application/json'},
    );
    final parsedData = json.decode(res.body) as Map<String, dynamic>;
    if (!(parsedData['success'] as bool)) {
      throw 'Error';
    }
    var currDate = transactions.last.date;
    final predictions = parsedData['prediction'] as List;
    final tsPreds = predictions.map((el) {
      currDate = currDate.add(const Duration(days: 1));
      return TimeSeries(currDate, (el as num).truncate());
    }).toList();
    return ResponseModel(
      tsPreds,
      parsedData['mse'] as num,
      parsedData['sse'] as num,
      parsedData['mpe'] as num,
    );
  } catch (e) {
    return null;
  }
}
