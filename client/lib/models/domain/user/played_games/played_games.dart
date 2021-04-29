import 'package:cash_flow/models/domain/user/played_games/played_game_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'played_games.freezed.dart';
part 'played_games.g.dart';

@freezed
class PlayedGames with _$PlayedGames {
    factory PlayedGames({
    @Default(<PlayedGameInfo>[]) List<PlayedGameInfo> multiplayerGames,
  }) = _PlayedGames;

   factory PlayedGames.fromJson(Map<String, dynamic> json) =>
      _$PlayedGamesFromJson(json);
}