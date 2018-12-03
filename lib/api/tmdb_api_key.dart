// If you a hosting a fork of the app repository on any public server 
// you are advised to remove this file from the repository after 
// adding the secret key.
// to do this run:
//     git rm --cached lib/api/tmdb_api_key.dart
//     git commit -m 'removed secret api key from repository' -o lib/api/tmdb_api_key.dart

const String tmdbApiKey = 'put your api key here';

// the api read access token is not required for this app to run.
// I am including it anyway because it is delivered together with the key
// and might be of use later on.
const String tmdbApiReadAccessToken ='put the api read acces token here';
