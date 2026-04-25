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
    try {
      print("➡️ before banners");
      final banners = await homeRepository.getBanners();
      print("✔ banners done");

      print("➡️ before categories");
      final categories = await homeRepository.getCategories();
      print("✔ categories done");

      print("➡️ before products");
      final products = await homeRepository.getProducts();
      print("✔ products done");
      emit(
        HomeLoadedState(
          banners: banners,
          categories: categories,
          products: products,
        ),
      );
      print(
        "==========================================================================================Loaded State EMITTED",
      );
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
      print(
        "==========================================================================================Error State EMITTED",
      );
    }
  }
}
