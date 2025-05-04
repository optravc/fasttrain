const bool useNgrok = true;

const String ngrokUrl = 'https://7eab-2001-fb1-5a-94fe-d4a1-65c1-605d-fbc6.ngrok-free.app';
const String localUrl = 'http://localhost:5000';

String get apiBaseUrl => useNgrok ? ngrokUrl : localUrl;
