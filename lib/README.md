assets/
├── images/                    # Hình ảnh sử dụng trong app
└── icons/                     # Icon tùy chỉnh SVG, PNG,...

lib/
├── main.dart                  # Entry point của app
├── app.dart                   # Khởi tạo MaterialApp, theme, routes

├── constants/                 # Hằng số toàn cục
│   ├── app_colors.dart
│   ├── app_styles.dart
│   └── app_sizes.dart

├── themes/                    # Giao diện light/dark theme
│   └── app_theme.dart

├── models/                    # Các model như User, Product, Cart, ...
│   ├── user.dart
│   ├── product.dart
│   └── cart.dart

├── services/                  # Gọi API, xử lý dữ liệu từ server
│   ├── product/
│   │   └── product_services.dart
│   └── cart/
│       └── cart_services.dart

├── providers/                # State management (Provider, Riverpod, ...)
│   ├── user_provider.dart
│   ├── cart_provider.dart
│   └── product_provider.dart

├── utils/                     # Hàm tiện ích dùng chung
│   ├── validators.dart
│   ├── formatters.dart
│   └── logger.dart

├── routes/                    # Quản lý route toàn app
│   └── app_routes.dart

├── widgets/                   # Widget dùng lại (UI components)
│   ├── button/
│   │   └── custom_button.dart
│   ├── input/
│   │   └── custom_input.dart
│   └── product/
│       └── product_card.dart

└── screens/                   # Giao diện chính (chia theo chức năng)
    ├── home/
    │   └── home_screen.dart
    ├── cart/
    │   └── cart_screen.dart
    ├── product/
    │   ├── product_detail_screen.dart
    │   └── product_list_screen.dart
    └── auth/
        ├── login_screen.dart
        └── register_screen.dart

