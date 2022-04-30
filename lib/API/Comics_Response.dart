import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:dio/dio.dart';
import 'package:marvelapp/API/keys.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:marvelapp/Models/Comics.dart';
import 'package:marvelapp/Views/characters_details_view.dart';

class ComicResponse {
  final itemsPerPage = 21;
  final url = "https://gateway.marvel.com" + "/v1/public/comics";
  var page = 0;
  var offset = 0;
  var lastTotalReturnedItems = 0;
  var firstCall = true;
  CharactersDetailsView view;
  int characterId;

  ComicResponse(this.view, this.characterId);

  void getComics() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash =
        generateMd5(timestamp + Keys.privateKey + Keys.publicKey).toString();

    try {
      offset = (page * itemsPerPage);
      Map<String, dynamic> queryParameters = {
        "apikey": Keys.publicKey,
        "hash": hash,
        "ts": timestamp,
        "limit": itemsPerPage.toString(),
        "offset": offset.toString(),
        "characters": characterId.toString()
      };

      if (!firstCall) {
        if (this.lastTotalReturnedItems < itemsPerPage) {
          view.addItems(<Comic>[]);
        }
      }

      view.showLoading();
      firstCall = false;
      var response = await Dio().get(url, queryParameters: queryParameters);

      final jsonValue = jsonDecode(response.toString());
      final object = Comics.fromJson(jsonValue);

      print("Resultado " + object.data.comics.length.toString());

      lastTotalReturnedItems = object.data.count;
      page++;
      view.addItems(object.data.comics);

      view.hideLoading();
    } catch (e) {
      print("Ocorreu um erro" + e.toString());
    }
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
    view.clearList();
  }
}