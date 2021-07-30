import 'dart:async';
import 'dart:convert';

import 'package:apidemo/constants/Strings.dart';
import 'package:apidemo/models/TournamentModel.dart';
import 'package:http/http.dart' as http;

class ApiData {
  final _stateStreamController = StreamController<TournamentModel>.broadcast();

  StreamSink<TournamentModel> get customListSink => _stateStreamController.sink;

  Stream<TournamentModel> get customListStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<String>.broadcast();

  StreamSink<String> get eventSink => _eventStreamController.sink;

  Stream<String> get eventStream => _eventStreamController.stream;

  ApiData() {
    eventStream.listen((event) async {
      try {
        customListSink.add(await getApiResponse(event.toString()));
      } on Exception catch (e) {
        customListSink.addError("Something went wrong");
      }
    });
  }

  Future<TournamentModel> getApiResponse(String end_cursor) async {
    var client = http.Client();
    var newsModel;
    String apiUrl = end_cursor.isNotEmpty
        ? Strings.base_url + "&cursor=${end_cursor}"
        : Strings.base_url;

    try {
      var response = await client.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = TournamentModel.fromJson(jsonMap);
      } else {
        return newsModel;
      }
    } catch (Exception) {
      return newsModel;
    }

    return newsModel;
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
