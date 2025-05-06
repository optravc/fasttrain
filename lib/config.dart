const bool useProductionApi = false;

const String productionUrl = ' https://d956-2001-fb1-5a-94fe-bd2a-68a8-848f-1c36.ngrok-free.app ';
const String localUrl = 'http://localhost:5000/api';

String get apiUrl => useProductionApi ? productionUrl : localUrl;