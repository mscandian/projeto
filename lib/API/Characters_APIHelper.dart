import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:marvelapp/API/keys.dart';
import 'package:marvelapp/Models/Character.dart';
import 'package:dio/dio.dart';
import 'package:marvelapp/Views/characters_view.dart';

class CharacterResponse {
  static String publicKey = "b9ee0527bec5b03423304dc476ed2835";
  static String privateKey = "80e416a9b74d3ee28b23524b53dd571172263e37";

  final itemsPerPage = 20;
  final url = "https://gateway.marvel.com" + "/v1/public/characters";
  var page = 0;
  var offset = 0;
  var lastTotalReturnedItems = 0;
  var firstCall = true;
  var searchTerm = "";
  CharactersView view;

  CharacterResponse(this.view);

  void getCharacters() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey).toString();

    try {
      offset = (page * itemsPerPage);
      Map<String, dynamic> queryParameters = {
        "apikey": Keys.publicKey,
        "hash": hash,
        "ts": timestamp,
        "limit": itemsPerPage.toString(),
        "offset": offset.toString()
      };

      if (searchTerm.isNotEmpty && searchTerm != null) {
        queryParameters['nameStartsWith'] = searchTerm;
      }

      if (!firstCall) {
        if (lastTotalReturnedItems < itemsPerPage) {
          view.addItems(<Character>[]);
        }
      }

      view.showLoading();
      firstCall = false;
      var response = await Dio().get(url, queryParameters: queryParameters);

      final jsonValue = jsonDecode(response.toString());
      final object = CharactersResponse.fromJson(jsonValue);
      print("Resultado " + object.data.characters.length.toString());
      this.lastTotalReturnedItems = object.data.count;
      if (object.data.count == 0){
        view.snackBarMessage();
      }

      page++;
      view.addItems(object.data.characters);

      view.hideLoading();
    } catch (e) {
      print("Ocorreu um erro" + e.toString());
    }
  }

  void searchCharacters([String searchTerm = ""]) async {
    refresh();
    this.searchTerm = searchTerm;
    getCharacters();
  }

  generateMd5(String data) {
    var content = Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  void refresh() {
    page = 0;
    offset = 0;
    lastTotalReturnedItems = 0;
    firstCall = true;
    searchTerm = "";
    view.clearList();
  }
}