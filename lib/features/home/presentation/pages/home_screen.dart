import 'package:flstn_store/core/app_routes.dart';
import 'package:flstn_store/core/utils/string_utils.dart';
import 'package:flstn_store/features/home/presentation/bloc/home_bloc.dart';
import 'package:flstn_store/features/home/presentation/bloc/home_event.dart';
import 'package:flstn_store/features/home/presentation/bloc/home_state.dart';
import 'package:flstn_store/shared/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/category_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, theme, state),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(HomeLoadEvent());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchAndCart(context, theme, state),
                  const SizedBox(height: 24),
                  _buildBanner(context, theme, state),
                  const SizedBox(height: 32),
                  _buildCategories(context, theme, state),
                  const SizedBox(height: 32),
                  _buildBestSellers(context, theme, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    HomeState state,
  ) {
    return AppBar(
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          /////////////////////////////////////////////////////AVATAR////////////////////////////////////////////
          child: CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              StringUtils.getInitials(state.userName),
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            /////////////////////////////////////////////////////HELLO////////////////////////////////////////////
            'Hello 👋',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color ?? Colors.grey,
            ),
          ),
          Text(
            /////////////////////////////////////////////////////NAME////////////////////////////////////////////
            state.userName.isNotEmpty ? state.userName : 'User',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Badge(
            isLabelVisible: state.hasUnreadNotifications,
            backgroundColor: theme.colorScheme.error,
            smallSize: 8,
            child: Container(
              /////////////////////////////////////////////////////NOTIFICATION BADGE////////////////////////////////////////////
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.scaffoldBackgroundColor,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: theme.iconTheme.color,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndCart(
    BuildContext context,
    ThemeData theme,
    HomeState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // Navigate to search or emit event to search
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                /////////////////////////////////////////////////////SEARCH BAR////////////////////////////////////////////
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.hoverColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: theme.iconTheme.color?.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Badge(
            /////////////////////////////////////////////////////CART BADGE////////////////////////////////////////////
            isLabelVisible: state.cartItemCount > 0,
            label: Text(state.cartItemCount.toString()),
            backgroundColor: theme.colorScheme.error,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cart);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context, ThemeData theme, HomeState state) {
    if (state is HomeLoadingState) {
      return Container(
        /////////////////////////////////////////////////////LOADING BANNER////////////////////////////////////////////
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.hoverColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    } else if (state is HomeErrorState) {
      return Container(
        /////////////////////////////////////////////////////ERROR BANNER////////////////////////////////////////////
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load banner',
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(HomeLoadEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final imageUrl = state.bannerImageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Today's Deal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Special Offer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Shop Now →",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, color: Colors.white),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(
    BuildContext context,
    ThemeData theme,
    HomeState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //////////////////////////////////////////////////////CATEGORIES TITLE//////////////////////////////////////////////////////////
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        //////////////////////////////////////////////////////LOADING CATEGORIES////////////////////////////////////////////
        if (state is HomeLoadingState)
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: theme.hoverColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          )
        //////////////////////////////////////////////////////ERROR CATEGORIES////////////////////////////////////////////
        else if (state is HomeErrorState)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Failed to load',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          )
        //////////////////////////////////////////////////////LOADED CATEGORIES////////////////////////////////////////////
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return CategoryItem(
                  name: category.name,
                  imageUrl: category.imageUrl,
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBestSellers(
    BuildContext context,
    ThemeData theme,
    HomeState state,
  ) {
    //////////////////////////////////////////////////////BEST SELLERS TITLE//////////////////////////////////////////////////////////
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Sellers',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        //////////////////////////////////////////////////////LOADING BEST SELLERS////////////////////////////////////////////
        if (state is HomeLoadingState)
          SizedBox(
            height: 250,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: theme.hoverColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              },
            ),
          )
        //////////////////////////////////////////////////////ERROR BEST SELLERS////////////////////////////////////////////
        else if (state is HomeErrorState)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Failed to load',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(HomeLoadEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        //////////////////////////////////////////////////////LOADED BEST SELLERS////////////////////////////////////////////
        else
          SizedBox(
            height: 250,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: state.popularProducts.length,
              itemBuilder: (context, index) {
                final p = state.popularProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 160,
                    child: ProductCard(
                      id: p.name,
                      title: p.name,
                      imageUrl: p.images.isNotEmpty ? p.images.first : '',
                      price: p.price,
                      rating: 4.5,
                      reviewsCount: 10,
                      description: p.description,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
