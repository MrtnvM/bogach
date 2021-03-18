import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class GamesLoadableListView<T extends StoreListItem>
    extends LoadableListView<T> {
  const GamesLoadableListView({
    @required LoadableListViewModel<T> viewModel,
  }) : super(viewModel: viewModel);

  @override
  State<StatefulWidget> createState() {
    return SnapLoadableListViewState<T>();
  }
}

class SnapLoadableListViewState<T extends StoreListItem>
    extends LoadableListViewState<T> {
  @override
  Widget build(BuildContext context) {
    final state = viewModel.getPaginationState();

    switch (state) {
      case PaginationState.loading:
        return buildProgressState();
      case PaginationState.empty:
        return buildEmptyState();
      case PaginationState.error:
        return buildErrorState();
      default:
        break;
    }

    return SizedBox(
      height: 150,
      child: Swiper(
        itemBuilder: (context, index) => Transform.translate(
          offset: Offset(-MediaQuery.of(context).size.width * 0.155, 0),
          child: buildListItem(context, index),
        ),
        itemCount: viewModel.itemsCount,
        viewportFraction: 0.6,
        scale: 0.8,
        loop: false,
      ),
    );
  }
}
