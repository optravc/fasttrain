Map<String, dynamic> calculatePrice(
  List<String> stations,
  String startStation,
  String endStation,
  String selectedLine,
) {
  int startIndex = stations.indexOf(startStation);
  int endIndex = stations.indexOf(endStation);

  if (startIndex == -1 || endIndex == -1) {
    return {
      'price': 0.0,
      'message': 'ไม่พบสถานีที่เลือก'
    };
  }

  int numStations = (endIndex - startIndex).abs();

  double total = 0.0;
  String explanation = '';

  if (selectedLine == 'Sukhumvit Line') {
    if (numStations == 1) total = 16;
    else if (numStations == 2) total = 23;
    else if (numStations == 3) total = 26;
    else if (numStations == 4) total = 30;
    else if (numStations == 5) total = 33;
    else if (numStations == 6) total = 37;
    else if (numStations == 7) total = 40;
    else if (numStations >= 8 && numStations <= 15) total = 44;
    else if (numStations >= 16) total = 59;
    explanation = 'เดินทาง $numStations สถานี สายสุขุมวิท = ${total.toStringAsFixed(2)} บาท';
  }

  else if (selectedLine == 'Silom Line') {
    if (numStations > 15) {
      total = 59.0;
      explanation = 'เหมาจ่ายสำหรับระยะทางเกิน 15 สถานี: 59 บาท';
    } else {
      double basePrice = 16.0;
      double priceIncrement = 3.5;
      total = basePrice + (numStations * priceIncrement);
      explanation = '$basePrice + ($numStations x $priceIncrement) = ${total.toStringAsFixed(2)}';
    }
  }

  else if (selectedLine == 'Gold Line') {
    total = 15.0;
    explanation = 'ค่าโดยสารสายสีทอง เหมาจ่าย 15 บาทตลอดสาย';
  }

  else {
    return {
      'price': 0.0,
      'message': 'ยังไม่รองรับสายนี้'
    };
  }

  return {
    'price': total,
    'message': explanation
  };
}
