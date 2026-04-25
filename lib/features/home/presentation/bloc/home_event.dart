import 'package:flstn_store/features/home/data/models/banner_model.dart';
import 'package:flstn_store/features/home/data/models/category_model.dart';
import 'package:flstn_store/features/home/data/models/product_model.dart';

sealed class HomeEvent {}

class HomeLoadEvent extends HomeEvent {}

class HomeLoadSuccessEvent extends HomeEvent {
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<ProductModel> products;

  HomeLoadSuccessEvent({
    required this.banners,
    required this.categories,
    required this.products,
  });
}

class HomeLoadFailureEvent extends HomeEvent {
  final String error;

  HomeLoadFailureEvent({required this.error});
}
