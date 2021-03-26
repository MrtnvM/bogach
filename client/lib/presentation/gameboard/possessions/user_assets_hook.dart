import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';

List<Asset> useUserAssets() {
  final assets = _getAssets();
  return assets;
}

List<T> useUserAssetsWithType<T>(AssetType assetType) {
  final assets = _getAssets();
  final assetsWithType = _getAssetsWithType<T>(assets, assetType);
  return assetsWithType;
}

List<T> _getAssetsWithType<T>(List<Asset> assets, AssetType type) {
  return assets.where((a) => a.type == type).cast<T>().toList();
}

List<Asset> _getAssets() {
  final userId = useUserId();
  return useCurrentGame((g) => g.participants[userId].possessionState.assets);
}
