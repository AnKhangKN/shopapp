import 'package:go_router/go_router.dart';
import 'package:shopapp/screens/discover/about/structure_26.dart';
import 'package:shopapp/screens/discover/discover_screen.dart';
import 'package:shopapp/screens/login/forgot_password_screen.dart';
import 'package:shopapp/screens/login/login_screen.dart';
import 'package:shopapp/screens/login/reset_password_screen.dart';
import 'package:shopapp/screens/login/verify_otp_screen.dart';
import 'package:shopapp/screens/product_detail/product_detail_screen.dart';
import 'package:shopapp/screens/search/search_screen.dart';
import 'package:shopapp/screens/signup/signup_screen.dart';
import 'package:shopapp/screens/wish/wish_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/product/product_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/BottomNav/bottom_nav.dart';
import '../screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  routes: [
    // Những trang KHÔNG có BottomNav
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const SplashScreen()),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const LoginScreen()),
    ),
    GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        pageBuilder: (context, state) =>
            NoTransitionPage(
                key: state.pageKey, child: const ForgotPasswordScreen()),
    ),
    GoRoute(
      path: '/verify-otp',
      name: 'verify-otp',
      builder: (context, state) {
        final email = state.extra;
        if (email is! String || email.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('❌ Không tìm thấy email')),
          );
        }
        return VerifyOtpScreen(email: email);
      },
    ),

    GoRoute(
      path: '/reset-password',
      name: 'reset-password', // <-- tên này phải khớp
      builder: (context, state) {
        final email = state.extra;
        if (email is! String || email.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('❌ Không tìm thấy email')),
          );
        }
        return ResetPasswordScreen(email: email);
      },
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

    // Các route CÓ BottomNav
    ShellRoute(
      builder: (context, state, child) => BottomNav(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const HomeScreen()),
        ),
        GoRoute(
          path: '/discover/:type',
          name: 'discover',
          builder: (context, state) {
            final type = state.pathParameters['type']!;
            return DiscoverScreen(contentType: type);
          },
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
          pageBuilder: (context, state) =>
              NoTransitionPage(
                  key: state.pageKey, child: const ProductScreen()),
        ),
        GoRoute(
          path: '/product/:productId',
          name: 'product_detail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['productId']!;
            final from = state.uri.queryParameters['from'];
            return NoTransitionPage(
              key: state.pageKey,
              child: ProductDetailScreen(productId: id, from: from),
            );
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) =>
              NoTransitionPage(
                  key: state.pageKey, child: const ProfileScreen()),
        ),
        GoRoute(
          path: '/wish',
          name: 'wish',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const WishScreen()),
        ),
      ],
    ),
  ],
);