import 'package:firebase_auth/firebase_auth.dart';
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
      return _onHomeLoadEvent(event, emit);
    });
  }
  Future<void> _onHomeLoadEvent(
    HomeLoadEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    List<BannerModel> banners = [];
    List<CategoryModel> categories = [];
    List<ProductModel> products = [];
    final user = FirebaseAuth.instance.currentUser;
    final fullName = user?.displayName ?? user?.email ?? 'User';
    final userName = fullName.split(' ').first;
    final userImage = user?.photoURL ?? '';
    try {
      banners = await homeRepository.getBanners();
      categories = await homeRepository.getCategories();
      products = await homeRepository.getProducts();
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
      return;
    }

    emit(
      HomeLoadedState(
        userImage: userImage,
        userName: userName,
        banners: banners,
        categories: categories,
        products: products,
      ),
    );
  }
}
