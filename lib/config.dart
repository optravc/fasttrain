const bool useNgrok = true;

const String ngrokUrl = 'https://trainfast-pqxrpm...vercel.app/api/stations';
const String localUrl = 'http://localhost:5000';

String get apiBaseUrl => useNgrok ? ngrokUrl : localUrl;
