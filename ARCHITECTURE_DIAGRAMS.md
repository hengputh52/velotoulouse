# Integration Architecture Diagram

## Complete Data Flow & Component Relationships

### 1. Dependency Injection Container (main_common.dart)

```
╔════════════════════════════════════════════════════════════════════════════╗
║                          main_common.dart                                  ║
║                    (Central Dependency Injection)                          ║
├════════════════════════════════════════════════════════════════════════════┤
║                                                                            ║
║  MultiProvider(                                                            ║
║    providers: [                                                            ║
║                                                                            ║
║      ┌─────────────────────────────────────────────────────────────────┐  ║
║      │  LAYER 1: REPOSITORIES (Data Sources)                          │  ║
║      ├─────────────────────────────────────────────────────────────────┤  ║
║      │  Provider<AuthRepository>(                                      │  ║
║      │    create: (_) => MockAuthRepository(),  // or Firebase       │  ║
║      │  ),                                                            │  ║
║      │  Provider<StationRepository>(                                  │  ║
║      │    create: (_) => MockStationRepository(),                    │  ║
║      │  ),                                                            │  ║
║      │  Provider<PassRepository>(                                     │  ║
║      │    create: (_) => MockPassRepository(),                       │  ║
║      │  ),                                                            │  ║
║      │  Provider<PaymentRepository>(                                  │  ║
║      │    create: (_) => MockPaymentRepository(),                    │  ║
║      │  ),                                                            │  ║
║      │  Provider<BookingRepository>(                                  │  ║
║      │    create: (_) => MockBookingRepository(),                    │  ║
║      │  ),                                                            │  ║
║      └─────────────────────────────────────────────────────────────────┘  ║
║                                    ↓                                       ║
║      ┌─────────────────────────────────────────────────────────────────┐  ║
║      │  LAYER 2: GLOBAL STATE (Available to entire app)                │  ║
║      ├─────────────────────────────────────────────────────────────────┤  ║
║      │  ChangeNotifierProvider<AuthViewModel>(                         │  ║
║      │    create: (ctx) => AuthViewModel(                             │  ║
║      │      ctx.read<AuthRepository>(),  // ← Inject repo            │  ║
║      │    ),                                                           │  ║
║      │  ),                                                             │  ║
║      │  ChangeNotifierProvider<PassSelectionViewModel>(              │  ║
║      │    create: (ctx) => PassSelectionViewModel(                   │  ║
║      │      ctx.read<PassRepository>(),                               │  ║
║      │      ctx.read<PaymentRepository>(),                            │  ║
║      │    ),                                                           │  ║
║      │  ),                                                             │  ║
║      │  ChangeNotifierProvider<ActiveBookingViewModel>(              │  ║
║      │    create: (_) => ActiveBookingViewModel(),                   │  ║
║      │  ),                                                             │  ║
║      └─────────────────────────────────────────────────────────────────┘  ║
║                                    ↓                                       ║
║      ┌─────────────────────────────────────────────────────────────────┐  ║
║      │  LAYER 3: SCREEN-LEVEL VIEWMODELS (Per-screen instances)       │  ║
║      ├─────────────────────────────────────────────────────────────────┤  ║
║      │  ProxyProvider<StationRepository, StationDetailViewModel>(   │  ║
║      │    update: (_, stationRepo, __) =>                            │  ║
║      │      StationDetailViewModel(stationRepo),                     │  ║
║      │  ),                                                             │  ║
║      │  ProxyProvider2<PaymentRepository, PassRepository,             │  ║
║      │    PaymentViewModel>(                                          │  ║
║      │    update: (_, paymentRepo, passRepo, __) =>                  │  ║
║      │      PaymentViewModel(paymentRepo, passRepo),                 │  ║
║      │  ),                                                             │  ║
║      └─────────────────────────────────────────────────────────────────┘  ║
║    ],                                                                       ║
║    child: const MyApp(),                                                   ║
║  )                                                                          ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
```

---

### 2. Screen-to-Widget Connection Pattern

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                        APP NAVIGATION LAYER                              ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                           ║
║  ┌───────────────────────────────────────────────────────────────────┐  ║
║  │  MyApp / MyHomePage                                               │  ║
║  │  ├─ BottomBar with navigation                                     │  ║
║  │  └─ Shows different screens based on selected tab                │  ║
║  └───────┬───────────────────────────────────────────────────────────┘  ║
║          │                                                               ║
║          ├─────────────────┬──────────────────┬──────────────────┐      ║
║          ↓                 ↓                  ↓                  ↓      ║
║  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ ║
║  │   MapScreen  │  │ PassSelection│  │ ActivityScreen│ │ AuthScreen   │ ║
║  │              │  │   Screen     │  │              │  │              │ ║
║  └──────────────┘  └──────┬───────┘  └──────────────┘  └──────────────┘ ║
║                           │                                             ║
║                           ↓                                             ║
║  ┌─ Using Selector Pattern (reads from global provider) ─────────────┐  ║
║  │                                                                  │  ║
║  │  class PassSelectionScreen extends StatelessWidget {            │  ║
║  │    build() => Selector<PassSelectionViewModel, PassSelection... │  ║
║  │      selector: (_, vm) => vm,                                   │  ║
║  │      builder: (context, vm, _) =>                               │  ║
║  │        const PassSelectionContent(),                            │  ║
║  │    );                                                            │  ║
║  │  }                                                               │  ║
║  └─────────────────────────┬──────────────────────────────────────┘  ║
║                            │                                          ║
║                            ↓                                          ║
║  ┌─ Using Consumer Pattern (receives ViewModel) ──────────────────┐  ║
║  │                                                               │  ║
║  │  class PassSelectionContent extends StatelessWidget {       │  ║
║  │    build() => Consumer<PassSelectionViewModel>(             │  ║
║  │      builder: (context, vm, _) =>                           │  ║
║  │        Scaffold(                                            │  ║
║  │          body: Column(children: [                           │  ║
║  │            if (vm.state == loading) Spinner(),             │  ║
║  │            if (vm.state == success)                         │  ║
║  │              PassTypeCard(                                 │  ║
║  │                isSelected: vm.selectedPassType == type,    │  ║
║  │                onTap: () => vm.selectPass(type),           │  ║
║  │              ),                                            │  ║
║  │            Button(onPressed: vm.proceedToPayment),        │  ║
║  │          ]),                                               │  ║
║  │        ),                                                  │  ║
║  │    ),                                                       │  ║
║  │  }                                                           │  ║
║  └────────────────────────┬────────────────────────────────────┘  ║
║                           │                                        ║
║                           ↓                                        ║
║  ┌──────────────────────────────────────────────────────────────┐  ║
║  │ User sees UI with data from ViewModel                        │  ║
║  │ - Pass cards with prices                                     │  ║
║  │ - Active pass banner (if any)                               │  ║
║  │ - Payment button                                             │  ║
║  └──────────────────────────────────────────────────────────────┘  ║
║                                                                     ║
╚═════════════════════════════════════════════════════════════════════════╝
```

---

### 3. ViewModel Architecture

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                       AuthViewModel                                       ║
║                  (Business Logic & State)                                 ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                           ║
║  Extends ChangeNotifier                                                  ║
║  Injected Dependency:                                                    ║
║  ┌─────────────────────────────────────────────────────────────────┐    ║
║  │ final AuthRepository _authRepository;                           │    ║
║  │                                                                 │    ║
║  │ Constructor:                                                    │    ║
║  │ AuthViewModel(this._authRepository);  ← Dependency Injection    │    ║
║  └─────────────────────────────────────────────────────────────────┘    ║
║                                                                           ║
║  STATE PROPERTIES:                                                       ║
║  ┌─────────────────────────────────────────────────────────────────┐    ║
║  │ ViewState _state = ViewState.idle;                              │    ║
║  │ AppUser? _currentUser;                                          │    ║
║  │ String? _errorMessage;                                          │    ║
║  │ bool _isLoginMode = true;                                       │    ║
║  │ bool _obscurePassword = true;                                   │    ║
║  │                                                                 │    ║
║  │ TextEditingController _emailController = ...;                   │    ║
║  │ TextEditingController _passwordController = ...;                │    ║
║  │ TextEditingController _nameController = ...;                    │    ║
║  └─────────────────────────────────────────────────────────────────┘    ║
║                                                                           ║
║  GETTERS (expose state to UI):                                          ║
║  ┌─────────────────────────────────────────────────────────────────┐    ║
║  │ ViewState get state => _state;                                  │    ║
║  │ AppUser? get currentUser => _currentUser;                       │    ║
║  │ String? get errorMessage => _errorMessage;                      │    ║
║  │ bool get isLoginMode => _isLoginMode;                           │    ║
║  │ TextEditingController get emailController => _emailController; │    ║
║  └─────────────────────────────────────────────────────────────────┘    ║
║                                                                           ║
║  METHODS (business logic):                                              ║
║  ┌─────────────────────────────────────────────────────────────────┐    ║
║  │ Future<void> submit() async {                                   │    ║
║  │   _state = ViewState.loading;                                   │    ║
║  │   notifyListeners();  // UI shows spinner                       │    ║
║  │                                                                 │    ║
║  │   try {                                                         │    ║
║  │     if (_isLoginMode) {                                         │    ║
║  │       // Uses injected repository                               │    ║
║  │       _currentUser = await _authRepository                      │    ║
║  │         .signInWithEmail(email, password);                      │    ║
║  │     } else {                                                    │    ║
║  │       _currentUser = await _authRepository                      │    ║
║  │         .registerWithEmail(email, password);                    │    ║
║  │     }                                                           │    ║
║  │                                                                 │    ║
║  │     _state = ViewState.success;                                 │    ║
║  │     _errorMessage = null;                                       │    ║
║  │   } catch (e) {                                                 │    ║
║  │     _errorMessage = _mapErrorMessage(e);                        │    ║
║  │     _state = ViewState.error;                                   │    ║
║  │   }                                                             │    ║
║  │                                                                 │    ║
║  │   notifyListeners();  // UI rebuilds with result                │    ║
║  │ }                                                               │    ║
║  │                                                                 │    ║
║  │ void toggleMode() {                                             │    ║
║  │   _isLoginMode = !_isLoginMode;                                 │    ║
║  │   notifyListeners();                                            │    ║
║  │ }                                                               │    ║
║  └─────────────────────────────────────────────────────────────────┘    ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

### 4. User Interaction Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    COMPLETE USER INTERACTION FLOW                           │
└─────────────────────────────────────────────────────────────────────────────┘

SCENARIO: User selects pass and proceeds to payment

┌──────────────────────────────────────────────────────────────┐
│ 1. UI EVENT - User taps Day Pass card                        │
├──────────────────────────────────────────────────────────────┤
│ PassTypeCard(                                                │
│   isSelected: vm.selectedPassType == PassType.day,          │
│   onTap: () => vm.selectPass(PassType.day),  ← Tap here    │
│ )                                                             │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│ 2. VIEWMODEL METHOD - selectPass() called                   │
├──────────────────────────────────────────────────────────────┤
│ void selectPass(PassType type) {                             │
│   _selectedPassType = type;                                  │
│   notifyListeners();  ← Signal UI to rebuild                │
│ }                                                             │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│ 3. UI REBUILD - Consumer notices change                     │
├──────────────────────────────────────────────────────────────┤
│ Consumer<PassSelectionViewModel>(                            │
│   builder: (context, vm, _) {  ← vm.selectedPassType is now │
│                                  PassType.day               │
│     return PassTypeCard(                                     │
│       isSelected: true,  ← Now shows as selected            │
│       onTap: () => vm.selectPass(PassType.day),             │
│     );                                                       │
│   },                                                         │
│ )                                                             │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│ 4. VISUAL UPDATE - User sees selection                      │
├──────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│  │Day Pass ✓│  │Monthly   │  │Annual    │                   │
│  │€1.50    │  │€15.00    │  │€99.00    │                   │
│  │24 hours │  │30 days   │  │365 days  │                   │
│  └──────────┘  └──────────┘  └──────────┘                   │
│   ↑ Selected!                                                │
│                                                               │
│ User taps "Continue to Payment" button                       │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│ 5. ASYNC OPERATION - Payment processing starts              │
├──────────────────────────────────────────────────────────────┤
│ Future<void> proceedToPayment() async {                      │
│   _state = ViewState.loading;                                │
│   notifyListeners();  ← UI shows loading spinner             │
│                                                               │
│   try {                                                       │
│     // Create pass for user                                  │
│     final pass = await _passRepository                       │
│       .createPass(type: _selectedPassType);                  │
│                                                               │
│     // Navigate to payment screen                            │
│     // _navigationService.gotoPayment(pass);                 │
│                                                               │
│     _state = ViewState.success;                              │
│   } catch (e) {                                              │
│     _errorMessage = e.toString();                            │
│     _state = ViewState.error;                                │
│   }                                                          │
│   notifyListeners();                                         │
│ }                                                             │
│                                                               │
│ ↓↓↓ Repository makes HTTP request ↓↓↓                       │
│                                                               │
│ await _passRepository.createPass(...)  {                     │
│   // Call Firebase REST API                                  │
│   final response = await http.post(                          │
│     Uri.parse('$baseUrl/passes.json'),                       │
│     body: jsonEncode({                                       │
│       'type': 'day',                                         │
│       'userId': currentUserId,                               │
│       'createdAt': DateTime.now(),                           │
│     }),                                                      │
│   );                                                         │
│   // Returns: Pass(id: '...', type: day, ...)                │
│ }                                                             │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│ 6. SUCCESS - UI rebuilds with new state                     │
├──────────────────────────────────────────────────────────────┤
│ Consumer rebuilds:                                            │
│ vm.state == ViewState.success                                │
│ vm.errorMessage == null                                      │
│                                                               │
│ Shows: "Pass purchased! Redirecting..."                      │
│ Then navigates to PaymentScreen                              │
└──────────────────────────────────────────────────────────────┘
```

---

### 5. Repository Layer

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                     REPOSITORY PATTERN                                    ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                           ║
║  ABSTRACT INTERFACE (contract)                                           ║
║  ┌┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┐               ║
║  ┆ abstract class AuthRepository {                                 ┆               ║
║  ┆   Future<AppUser?> signInWithEmail(String email,              ┆               ║
║  ┆                                     String password);          ┆               ║
║  ┆   Future<AppUser> registerWithEmail(String email,             ┆               ║
║  ┆                                      String password);         ┆               ║
║  ┆   Future<void> signOut();                                      ┆               ║
║  ┆   Stream<AppUser?> watchAuthState();                          ┆               ║
║  ┆   AppUser? get currentUser;                                    ┆               ║
║  ┆ }                                                              ┆               ║
║  └┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┐               ║
║              │                               │                            ║
║              ├──────────────────────────────┼──────────────────────┐     ║
║              │                              │                      │     ║
║              ↓                              ↓                      ↓     ║
║  ┌──────────────────────┐   ┌──────────────────────┐   ┌──────────────────┐ ║
║  │  MOCK IMPLEMENTATION │   │ FIREBASE IMPL        │   │ (Alternative)    │ ║
║  │  (FOR TESTING)       │   │ (PRODUCTION)         │   │                  │ ║
║  ├──────────────────────┤   ├──────────────────────┤   ├──────────────────┤ ║
║  │ class MockAuthRep    │   │ class UserRepository │   │ REST / GraphQL   │ ║
║  │ implements AuthRep   │   │ Firebase implements  │   │ or Custom API    │ ║
║  │ {                    │   │ AuthRepository {     │   │                  │ ║
║  │   @override          │   │   @override          │   │                  │ ║
║  │   Future<AppUser?>   │   │   Future<AppUser?>   │   │                  │ ║
║  │   signInWithEmail... │   │   signInWithEmail... │   │                  │ ║
║  │   {                  │   │   {                  │   │                  │ ║
║  │     // Return dummy  │   │     // HTTP POST     │   │                  │ ║
║  │     // user or null  │   │     // to Firebase   │   │                  │ ║
║  │     return AppUser(  │   │     final resp =     │   │                  │ ║
║  │       id: '123',     │   │       await http...  │   │                  │ ║
║  │       email: email,  │   │     return AppUser   │   │                  │ ║
║  │     );               │   │       .fromJson(...) │   │                  │ ║
║  │   }                  │   │   }                  │   │                  │ ║
║  │ }                    │   │ }                    │   │                  │ ║
║  └──────────────────────┘   └──────────────────────┘   └──────────────────┘ ║
║                                                                           ║
║  KEY PRINCIPLE:                                                          ║
║  ┌───────────────────────────────────────────────────────────────────┐  ║
║  │ ViewModel NEVER knows which implementation is used!               │  ║
║  │ It only depends on AuthRepository interface.                     │  ║
║  │ This allows:                                                      │  ║
║  │ • Easy testing (swap Mock in)                                    │  ║
║  │ • Easy implementation switching (swap Firebase in)               │  ║
║  │ • Clear separation of concerns                                   │  ║
║  └───────────────────────────────────────────────────────────────────┘  ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

### 6. Navigation & Screen Management

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    SCREEN LIFECYCLE (per navigation)                    │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ StationDetailScreen(stationId: '123')               │
│ StatefulWidget                                      │
└─────────────────┬───────────────────────────────────┘
                  │
        ┌─────────▼──────────┐
        │   initState()      │
        │  addPostFrameCall- │
        │  back to load data │
        └─────────┬──────────┘
                  │
        ┌─────────▼──────────────────────────────────┐
        │ build() returns MultiProvider with:        │
        │                                             │
        │ ProxyProvider<StationRepository,           │
        │   StationDetailViewModel>(                 │
        │   update: (_, repo, __) =>                │
        │     StationDetailViewModel(repo)          │
        │ )                                          │
        │                                             │
        │ └─ Creates NEW instance each time!        │
        └─────────┬──────────────────────────────────┘
                  │
        ┌─────────▼──────────────────────────────────┐
        │ ViewModel methods called:                  │
        │ _stationDetailVM.loadStation('123')        │
        │                                             │
        │ state transitions:                         │
        │ idle ──> loading ──> success (or error)   │
        └─────────┬──────────────────────────────────┘
                  │
        ┌─────────▼──────────────────────────────────┐
        │ StationDetailContent (Consumer) rebuilds   │
        │ Displays:                                   │
        │ - Station name                             │
        │ - Bike count                               │
        │ - Available slots                          │
        │ - Book button                              │
        └─────────┬──────────────────────────────────┘
                  │
        ┌─────────▼──────────────────────────────────┐
        │ User navigates away (pops route)           │
        └─────────┬──────────────────────────────────┘
                  │
        ┌─────────▼──────────────────────────────────┐
        │ ProxyProvider disposes ViewModel           │
        │ (automatic cleanup)                        │
        │                                             │
        │ No memory leaks!                           │
        └─────────────────────────────────────────────┘

Note: This pattern works for any screen-level ViewModel:
- ProxyProvider<Repo, VM> for single dependency
- ProxyProvider2<Repo1, Repo2, VM> for two dependencies
- ProxyProvider3<..., VM> for three dependencies
```

---

### 7. Complete Data Model

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     DATA MODELS (in lib/model)                          │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ AppUser (from AuthViewModel after sign in)                              │
├─────────────────────────────────────────────────────────────────────────┤
│ {                                                                         │
│   "id": "user123",         // Firebase UID                              │
│   "email": "user@example.com",                                          │
│   "name": "John Doe",                                                    │
│   "createdAt": "2025-04-15T10:30:00Z",                                 │
│   "updatedAt": "2025-04-15T10:30:00Z"                                  │
│ }                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ Pass (from PassSelectionViewModel after creation)                       │
├─────────────────────────────────────────────────────────────────────────┤
│ {                                                                         │
│   "id": "pass456",                                                       │
│   "userId": "user123",                                                   │
│   "type": "day" | "monthly" | "annual",                                │
│   "price": 1.50,                                                         │
│   "createdAt": "2025-04-15T10:30:00Z",                                 │
│   "expiresAt": "2025-04-16T10:30:00Z",                                 │
│   "isActive": true                                                       │
│ }                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ Station (from StationDetailViewModel.loadStation())                     │
├─────────────────────────────────────────────────────────────────────────┤
│ {                                                                         │
│   "id": "station1",                                                      │
│   "name": "Gare Montparnasse",                                         │
│   "latitude": 48.8344,                                                   │
│   "longitude": 2.3232,                                                   │
│   "address": "123 rue de la Paix, Paris 75000",                        │
│   "bikesAvailable": 12,                                                  │
│   "totalSlots": 25,                                                      │
│   "slots": [                                                             │
│     {                                                                    │
│       "id": "slot1",                                                     │
│       "bikeId": "bike456",                                               │
│       "status": "available" | "reserved"                                │
│     },                                                                   │
│     ...                                                                  │
│   ]                                                                      │
│ }                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ Payment (from PaymentViewModel.processPayment())                        │
├─────────────────────────────────────────────────────────────────────────┤
│ {                                                                         │
│   "id": "payment789",                                                    │
│   "userId": "user123",                                                   │
│   "passId": "pass456",                                                   │
│   "amount": 15.00,                                                       │
│   "currency": "EUR",                                                     │
│   "method": "card" | "mobile" | "cash",                                │
│   "status": "pending" | "completed" | "failed",                        │
│   "createdAt": "2025-04-15T10:30:00Z"                                  │
│ }                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ Booking (from ActiveBookingViewModel)                                   │
├─────────────────────────────────────────────────────────────────────────┤
│ {                                                                         │
│   "id": "booking999",                                                    │
│   "userId": "user123",                                                   │
│   "bikeId": "bike456",                                                   │
│   "stationId": "station1",                                               │
│   "startTime": "2025-04-15T14:00:00Z",                                 │
│   "endTime": null,                 // Null while active                 │
│   "status": "active" | "completed",                                    │
│   "duration": null,                // Calculated when ended             │
│   "cost": null                     // Calculated from trip time        │
│ }                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Summary

- **Repositories** handle all data operations (HTTP, Firebase)
- **ViewModels** contain business logic and state management
- **Content Widgets** consume ViewModels and display UI
- **Screen Widgets** wrap content with Provider setup
- **Navigation** triggers new screen instantiation
- **ProxyProvider** creates screen-level ViewModels automatically
- **notifyListeners()** triggers Consumer rebuilds
- **All injection** happens in main_common.dart
