import 'package:flstn_store/features/home/data/models/banner_model.dart';
import 'package:flstn_store/features/home/data/models/category_model.dart';
import 'package:flstn_store/features/home/data/models/product_model.dart';

sealed class HomeState {
  final String userName;
  final bool hasUnreadNotifications;
  final int cartItemCount;

  const HomeState({
    this.userName = 'User',
    this.hasUnreadNotifications = false,
    this.cartItemCount = 0,
  });

  String? get bannerImageUrl => null;
  List<CategoryModel> get categories => [];
  List<ProductModel> get popularProducts => [];
}

class HomeInitialState extends HomeState {
  const HomeInitialState() : super();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState({
    super.userName,
    super.hasUnreadNotifications,
    super.cartItemCount,
  });
}

class HomeLoadedState extends HomeState {
  final List<BannerModel> banners;
  @override
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final String userImage;
  const HomeLoadedState({
    required this.banners,
    required this.categories,
    required this.products,
    required this.userImage,
    super.userName,
    super.hasUnreadNotifications,
    super.cartItemCount,
  });

  @override
  String? get bannerImageUrl =>
      banners.isNotEmpty ? banners.first.imageUrl : null;

  @override
  List<ProductModel> get popularProducts => products;
}

class HomeErrorState extends HomeState {
  final String error;

  const HomeErrorState({
    required this.error,
    super.userName,
    super.hasUnreadNotifications,
    super.cartItemCount,
  });
}
