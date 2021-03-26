import 'package:cash_flow/models/domain/user/last_games/last_game_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_games.freezed.dart';
part 'last_games.g.dart';

@freezed
abstract class LastGames with _$LastGames {
  factory LastGames({
    List<LastGameInfo> singleplayerGames,
    List<LastGameInfo> questGames,
    List<LastGameInfo> multiplayerGames,
  }) = _LastGames;

  factory LastGames.fromJson(Map<String, dynamic> json) =>
      _$LastGamesFromJson(json);

  static LastGames empty = LastGames(
    singleplayerGames: [],
    questGames: [],
    multiplayerGames: [],
  );
}
