import 'package:flstn_store/shared/widgets/product_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/category_item.dart';
import '../../../../shared/widgets/custom_text_field.dart';

final List<String> _placeholderBanners = [
  'https://images.everydayhealth.com/images/diet-nutrition/olive-oil-nutrition-facts-benefits-for-skin-and-health-side-effects-more-722x406.jpg?sfvrsn=d588ad6_1',
  'https://img.drz.lazcdn.com/g/kf/S690e92aa4047432d85e483982af0e2d5e.jpg_720x720q80.jpg',
];

final List<Map<String, dynamic>> _placeholderCategories = [
  {
    'name': 'Herbs',
    'image': 'https://cdn-icons-png.flaticon.com/128/8290/8290412.png',
  },
  {
    'name': 'Accessories',
    'image': 'https://cdn-icons-png.flaticon.com/128/6184/6184829.png',
  },
  {
    'name': 'Clothing',
    'image': 'https://cdn-icons-png.flaticon.com/128/15131/15131339.png',
  },
];

final List<Map<String, dynamic>> _placeholderProducts = [
  {
    'id': '1',
    'title': 'Palestine map medal',
    'price': 4.99,
    'rating': 4.8,
    'reviewsCount': 120,
    'imageUrl':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKJJESQpeJMpnnLk_TLIddblQP3ODFpwfmCw&s',
    'description': 'High quality Palestine map with the Palestinian flag.',
  },
  {
    'id': '2',
    'title': 'Palestine canvas bag',
    'price': 59.99,
    'rating': 4.9,
    'reviewsCount': 250,
    'imageUrl':
        'https://ih1.redbubble.net/image.5587478781.8823/tb,840x840,medium-c,1,198,600,600-bg,f8f8f8.jpg',
    'description':
        'High quality Palestine canvas bag with the Palestinian flag.',
  },
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', height: 100),
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          child: const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000&auto=format&fit=crop',
            ),
          ),
        ),
        actions: [
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shopping_cart,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  spacing: 2,
                  children: [
                    SizedBox(
                      width: 250,
                      child: const CustomTextField(
                        hintText: 'Search',
                        prefixIcon: Icons.search,
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.filter_alt,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Banner Slider
              SizedBox(
                height: 150,
                child: PageView.builder(
                  padEnds: false,
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: _placeholderBanners.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 16, left: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(_placeholderBanners[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: _placeholderCategories.length,
                  itemBuilder: (context, index) {
                    final category = _placeholderCategories[index];
                    return CategoryItem(
                      name: category['name'],
                      imageUrl: category['image'],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Products
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Products',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _placeholderProducts.length,
                itemBuilder: (context, index) {
                  final p = _placeholderProducts[index];
                  return ProductCard(
                    id: p['id'],
                    title: p['title'],
                    imageUrl: p['imageUrl'],
                    price: p['price'],
                    rating: p['rating'],
                    reviewsCount: p['reviewsCount'],
                    description: p['description'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
