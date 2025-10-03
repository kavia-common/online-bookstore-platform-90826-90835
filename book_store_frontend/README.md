# Ocean Bookstore – book_store_frontend

A modern Flutter mobile app frontend for an online bookstore.

Theme: Ocean Professional (blue primary with amber accents), rounded corners, subtle shadows, minimalist layout, and smooth transitions.

Features implemented:
- Home (featured books)
- Catalog with search, category filter chips, and sorting (title, author, price, rating)
- Book details with rating and add-to-cart
- Cart with quantity controls and total price
- Checkout (mock) with shipping/payment and order summary
- Profile (mock) with simple edit and quick actions

Architecture and state:
- Provider for app state: CatalogState (search/filter/sort), CartState, UserState
- MockBookRepository simulates API calls and data flow
- Stateless widgets and lightweight stateful screens organized in a single entry file for simplicity

How to run:
1. flutter pub get
2. flutter run

Notes:
- No backend integration is included. Replace MockBookRepository with real API calls in the future.
- All UI adheres to the Ocean Professional color palette and modern design guidelines.
