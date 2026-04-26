import 'package:flstn_store/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_routes.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover the Authentic Spirit of Palestine',
      'description':
          'Shop genuine Palestinian products — from traditional clothing to delicious foods and handcrafted accessories',
      'image': 'assets/images/on1.jpg',
    },
    {
      'title': 'Everything in One Place',
      'description':
          'Authentic Palestinian clothing, accessories, and foods — delivered right to your door, wherever you are',
      'image': 'assets/images/on2.jpg',
    },
    {
      'title': 'Support and Shop with Pride',
      'description':
          'Every purchase is real support for Palestinian artisans. Join us and start your journey today',
      'image': 'assets/images/on3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('onboardingSeen', true);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.authWrapper,
                    );
                  }
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            _onboardingData[index]['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          _onboardingData[index]['title']!,
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _onboardingData[index]['description']!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: _currentPage == _onboardingData.length - 1
                        ? "Let's Go"
                        : 'Next',
                    onPressed: () async {
                      if (_currentPage == _onboardingData.length - 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('onboardingSeen', true);
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.authWrapper,
                          );
                        }
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
