double calculatePrice(List<String> stations, String startStation, String endStation, String selectedLine) {
  // หาตำแหน่งของสถานีต้นทางและปลายทางใน List
  int startIndex = stations.indexOf(startStation);
  int endIndex = stations.indexOf(endStation);

  // ตรวจสอบว่าผู้ใช้เลือกสถานีต้นทางและปลายทางที่ถูกต้องหรือไม่
  if (startIndex == -1 || endIndex == -1) {
    return 0.0;  // คืนค่า 0 หากไม่พบสถานี
  }

  // คำนวณจำนวนสถานีที่เดินทาง
  int numStations = (endIndex - startIndex).abs();

  // กำหนดราคาเริ่มต้นและอัตราค่าธรรมเนียมเพิ่มขึ้นตามแต่ละสาย
  double basePrice;
  double priceIncrement;
  double maxPrice;

  switch (selectedLine) {
    case 'Sukhumvit Line':
      basePrice = 17.0; 
      priceIncrement = 7.0; 
      maxPrice = 62.0;  
      break;
    case 'Silom Line':
      basePrice = 16.0; 
      priceIncrement = 4.0;  
      maxPrice = 59.0;  
      break;
    case 'Gold Line':
      basePrice = 16.0;  
      priceIncrement = 4.0;  
      maxPrice = 16.0;  
      break;
    case 'Yellow Line':
      basePrice = 15.0;  
      priceIncrement = 4.0;  
      maxPrice = 45.0;  
      if (numStations > 3) {
        priceIncrement = 3.0; 
      }
      break;
    case 'Pink Line':
      basePrice = 15.0;  
      priceIncrement = 3.0; 

      if (numStations > 3) {
        priceIncrement = 4.0; 
      } 
        if (numStations > 4) {
        priceIncrement = 5.0; 
      } 
       if (numStations > 5) {
        priceIncrement = 7.0; 
      } 
        if (numStations > 10) {
        priceIncrement =2.0; 
      } 

      maxPrice = 45.0;  
      break;
      
    default:
      basePrice = 20.0;  
      priceIncrement = 10.0; 
      maxPrice = 50.0;  
      break;
  }

 
  double price = basePrice + (numStations * priceIncrement);

  // ตรวจสอบว่าไม่ให้ราคามากกว่าราคาสูงสุด
  if (price > maxPrice) {
    price = maxPrice;
  }

  return price;
}