import 'package:freezed_annotation/freezed_annotation.dart';

part 'selected_item_view_model.freezed.dart';

@freezed
abstract class SelectedItemViewModel with _$SelectedItemViewModel {
  factory SelectedItemViewModel({
    @Default('') String selectedSingleplayerGame,
    @Default('') String selectedQuest,
    @Default('') String selectedMultiplayerGame,
  }) = _SelectedItemViewModel;

  static SelectedItemViewModel selectGame(String id) {
    return SelectedItemViewModel(
      selectedSingleplayerGame: id,
      selectedQuest: '',
      selectedMultiplayerGame: '',
    );
  }
}
