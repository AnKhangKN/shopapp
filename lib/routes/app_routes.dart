import 'package:go_router/go_router.dart';
import 'package:shopapp/screens/login/login_screen.dart';
import 'package:shopapp/screens/product_detail/product_detail_screen.dart';
import 'package:shopapp/screens/search/search_screen.dart';
import 'package:shopapp/screens/signup/signup_screen.dart';
import 'package:shopapp/screens/wish/wish_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/product/product_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/BottomNav/bottom_nav.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      builder: (context, state, child) => BottomNav(child: child),
      routes: [
        GoRoute(
          path: '/', // Tương đương với '/'
          name: 'home',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const HomeScreen()),
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const CartScreen()),
        ),
        GoRoute(
          path: '/product',
          name: 'product',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ProductScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ProfileScreen(),
          ),
        ),
        GoRoute(
          path: '/wish',
          name: 'wish',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const WishScreen()),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const LoginScreen()),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const SignupScreen()),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          pageBuilder: (context, state) {
            final from = state.uri.queryParameters['from'];
            return NoTransitionPage(
              key: state.pageKey,
              child: SearchScreen(from: from),
            );
          },
        ),

        GoRoute(
          path: '/product/:productId',
          name: 'product_detail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['productId']!;
            final from = state.uri.queryParameters['from'];
            return NoTransitionPage(
              key: state.pageKey,
              child: ProductDetailScreen(
                productId: id,
                from: from,
              ),
            );
          },
        ),

      ],
    ),
  ],
);
