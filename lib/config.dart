const bool useProductionApi = true;

const String productionUrl = 'https://trainfast-omega.vercel.app';
const String localUrl = 'http://localhost:5000/api';

String get apiUrl => useProductionApi ? productionUrl : localUrl;