import 'package:flstn_store/features/home/data/models/banner_model.dart';
import 'package:flstn_store/features/home/data/models/category_model.dart';
import 'package:flstn_store/features/home/data/models/product_model.dart';
import 'package:flstn_store/features/home/presentation/bloc/home_event.dart';
import 'package:flstn_store/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flstn_store/features/home/data/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  HomeBloc({required this.homeRepository}) : super(HomeInitialState()) {
    on<HomeLoadEvent>((event, emit) {
      print(
        '==========================================================================================HomeLoadEvent==========================================',
      );
      return _onHomeLoadEvent(event, emit);
    });
  }
  Future<void> _onHomeLoadEvent(
    HomeLoadEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    print(
      "==========================================================================================Loading State EMITTED",
    );
    List<BannerModel> banners = [];
    List<CategoryModel> categories = [];
    List<ProductModel> products = [];
    try {
      print("➡️ before banners");
      banners = await homeRepository.getBanners();
      print("✔ banners done");
    } catch (e) {
      print("Error banners: $e");
    }
    try {
      print("➡️ before categories");
      categories = await homeRepository.getCategories();
      print("✔ categories done");
    } catch (e) {
      print("Error categories: $e");
    }
    try {
      print("➡️ before products");
      products = await homeRepository.getProducts();
      print("✔ products done");
    } catch (e) {
      print("Error products: $e");
    }

    emit(
      HomeLoadedState(
        banners: banners,
        categories: categories,
        products: products,
      ),
    );
  }
}
