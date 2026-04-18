# Implementation Guide: Backend Integration

## Quick Reference - How Everything Works Together

### 1️⃣ Repository → ViewModel → Content Widget Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    main_common.dart                         │
│         (Central Dependency Injection Container)            │
├─────────────────────────────────────────────────────────────┤
│ MultiProvider([                                             │
│   // Repositories are provided FIRST                       │
│   Provider<AuthRepository>(                                │
│     create: (_) => MockAuthRepository()  // or Firebase   │
│   ),                                                        │
│   // ViewModels depend on repositories                     │
│   ChangeNotifierProvider<AuthViewModel>(                  │
│     create: (ctx) => AuthViewModel(                       │
│       ctx.read<AuthRepository>()  // ← Get from Provider  │
│     )                                                      │
│   ),                                                       │
│ ])                                                         │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│               AuthViewModel (State Management)              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ final AuthRepository _authRepository;                │  │
│  │ ViewState _state = ViewState.idle;                   │  │
│  │ AppUser? _currentUser;                               │  │
│  │ String? _errorMessage;                               │  │
│  │                                                       │  │
│  │ Future<void> submit() async {                        │  │
│  │   _state = ViewState.loading;                        │  │
│  │   try {                                              │  │
│  │     _currentUser =                                   │  │
│  │       await _authRepository.signInWithEmail(...);    │  │
│  │     _state = ViewState.success;                      │  │
│  │   } catch (e) {                                      │  │
│  │     _errorMessage = e.toString();                    │  │
│  │     _state = ViewState.error;                        │  │
│  │   }                                                  │  │
│  │   notifyListeners();  // ← Notify UI of changes      │  │
│  │ }                                                     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│             AuthScreenContent (UI Layer)                    │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Consumer<AuthViewModel>(                             │  │
│  │   builder: (context, vm, _) {                        │  │
│  │     return Scaffold(                                 │  │
│  │       body: Form(                                    │  │
│  │         child: Column(                               │  │
│  │           children: [                                │  │
│  │             // Show error if vm.errorMessage exists  │  │
│  │             if (vm.errorMessage != null)             │  │
│  │               AppErrorBanner(message: vm.errorMessage),│  │
│  │             // Show loading spinner                  │  │
│  │             if (vm.state == ViewState.loading)       │  │
│  │               CircularProgressIndicator(),           │  │
│  │             // Show success message                  │  │
│  │             if (vm.state == ViewState.success)       │  │
│  │               SuccessMessage(),                      │  │
│  │             // Call ViewModel method on button tap   │  │
│  │             AppPrimaryButton(                        │  │
│  │               onPressed: vm.submit,  // ← Triggers flow │  │
│  │               label: 'Sign In',                      │  │
│  │             ),                                       │  │
│  │           ],                                         │  │
│  │         ),                                           │  │
│  │       ),                                             │  │
│  │     );                                               │  │
│  │   },                                                 │  │
│  │ )                                                    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 2️⃣ Real Implementation Examples

### Example A: Pass Selection Screen

**What the User Sees:**
```
┌──────────────────────────────────┐
│  Choose a Pass                   │ ← AppBar from PassSelectionContent
├──────────────────────────────────┤
│ ✅ Your Current Pass (if any)   │ ← ActivePassBanner (if activePass != null)
│    Annual Pass, Valid until 2025 │
├──────────────────────────────────┤
│                                  │
│  [Day Pass]     [Monthly Pass]   │ ← PassTypeCard widgets
│  €1.50                           │   - Read: vm.selectedPassType
│  24 hours                        │   - Click: vm.selectPass(type)
│                                  │
│  [Annual Pass]                   │
│  €99.00                          │
│  365 days                        │
│                                  │
├──────────────────────────────────┤
│  [Continue to Payment] →          │ ← Calls vm.proceedToPayment()
└──────────────────────────────────┘
```

**Behind the Scenes:**

```dart
// 1. In main_common.dart - Set up injection
ChangeNotifierProvider<PassSelectionViewModel>(
  create: (context) => PassSelectionViewModel(
    context.read<PassRepository>(),      // ← Inject PassRepository
    context.read<PaymentRepository>(),   // ← Inject PaymentRepository
  ),
),

// 2. In PassSelectionViewModel
class PassSelectionViewModel extends ChangeNotifier {
  final PassRepository _passRepository;
  final PaymentRepository _paymentRepository;
  
  ViewState _state = ViewState.idle;
  PassType? _selectedPassType;
  Pass? _activePass;
  
  Future<void> loadActivePas() async {
    _state = ViewState.loading;
    try {
      // Uses injected repository
      _activePass = await _passRepository.getActivePass();
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
    }
    notifyListeners();
  }
  
  void selectPass(PassType type) {
    _selectedPassType = type;
    notifyListeners();  // ← This triggers Consumer rebuild
  }
}

// 3. In PassSelectionContent
Consumer<PassSelectionViewModel>(
  builder: (context, vm, _) {
    return Column(
      children: [
        // UI reads state
        if (vm.selectedPassType == PassType.day)
          Text('You selected: Day Pass'),
        
        // UI calls methods
        PassTypeCard(
          isSelected: vm.selectedPassType == PassType.day,
          onTap: () => vm.selectPass(PassType.day),  // ← Triggers selectPass
        ),
      ],
    );
  },
)

// 4. Result: When user taps PassTypeCard
//    - PassTypeCard calls vm.selectPass(PassType.day)
//    - ViewModel calls notifyListeners()
//    - Consumer rebuilds automatically
//    - UI shows selected state
```

---

### Example B: Station Detail Screen (Screen-Level ViewModel)

**What the User Sees:**
```
┌──────────────────────────────────┐
│  Station Name              ← Title│
├──────────────────────────────────┤
│  [Loading...]                    │ ← While loading
│                                  │
│  Once loaded:                    │
├──────────────────────────────────┤
│  📍 123 Main Street, Paris      │ ← Station info
│  🚲 12 bikes available          │
│                                  │
│  Available Slots:                │
│  ┌──────┐ ┌──────┐ ┌──────┐     │
│  │ [1]  │ │ [2]  │ │[3]✓  │     │ ← Selected slot
│  └──────┘ └──────┘ └──────┘     │
│  [4]  [5]  [6x]  [7x]  [8]      │ ← x = unavailable
│                                  │
├──────────────────────────────────┤
│  [Book This Bike] →              │
└──────────────────────────────────┘
```

**Behind the Scenes:**

```dart
// 1. In main_common.dart - Screen-level ViewModel as ProxyProvider
ProxyProvider<StationRepository, StationDetailViewModel>(
  update: (_, stationRepo, __) => 
    StationDetailViewModel(stationRepo),  // ← New instance each navigation
),

// 2. In StationDetailScreen (StatefulWidget)
class _StationDetailScreenState extends State<StationDetailScreen> {
  @override
  void initState() {
    super.initState();
    // AFTER first frame, load station data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StationDetailViewModel>()
        .loadStation(widget.stationId);  // ← Trigger load
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the injected ViewModel to content
        ProxyProvider<StationRepository, StationDetailViewModel>(
          update: (_, stationRepo, __) => 
            StationDetailViewModel(stationRepo),
        ),
      ],
      child: const StationDetailContent(),
    );
  }
}

// 3. In StationDetailViewModel
class StationDetailViewModel extends ChangeNotifier {
  final StationRepository _stationRepository;
  
  ViewState _state = ViewState.idle;
  Station? _station;
  String? _selectedSlotId;
  
  Future<void> loadStation(String stationId) async {
    _state = ViewState.loading;
    notifyListeners();  // ← UI shows loading spinner
    
    try {
      // Uses injected repository
      _station = await _stationRepository
        .getStationById(stationId);
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();  // ← UI updates with data
  }
  
  void selectSlot(String slotId) {
    _selectedSlotId = slotId;
    notifyListeners();  // ← UI shows selected slot
  }
}

// 4. In StationDetailContent
Consumer<StationDetailViewModel>(
  builder: (context, vm, _) {
    // Switch on state
    if (vm.state == ViewState.loading) {
      return LoadingOverlay();
    }
    if (vm.state == ViewState.error) {
      return ErrorBanner(message: vm.errorMessage);
    }
    if (vm.state == ViewState.success && vm.station != null) {
      return Column(
        children: [
          StationHeaderCard(station: vm.station!),
          BikeSlotCard(
            slot: slot,
            isSelected: vm.selectedSlotId == slot.id,
            onTap: () => vm.selectSlot(slot.id),  // ← Select slot
          ),
        ],
      );
    }
    return SizedBox();
  },
)

// 5. Flow:
//    User navigates to StationDetailScreen(stationId: "123")
//    ↓
//    _StationDetailScreenState.initState() calls loadStation()
//    ↓
//    StationDetailViewModel calls _stationRepository.getStationById()
//    ↓
//    Repository makes HTTP call to Firebase
//    ↓
//    ViewModel calls notifyListeners()
//    ↓
//    Consumer rebuilds with new data
//    ↓
//    UI shows station, slots, and booking button
```

---

## 3️⃣ Switching from Mock to Firebase

**Current Setup (Testing):**
```dart
// main_common.dart
Provider<AuthRepository>(
  create: (_) => MockAuthRepository(),
),
```

**Production Setup (One-line change!):**
```dart
// main_common.dart
Provider<AuthRepository>(
  create: (_) => UserRepositoryFirebase(),  // ← Just change this
),
```

**That's it!** The entire app automatically uses Firebase because:
- All ViewModels depend on the abstract `AuthRepository` interface
- They don't care if it's Mock or Firebase
- The ViewModel code stays exactly the same
- The UI code stays exactly the same
- Only the data source changes

---

## 4️⃣ Data Flow Examples

### Auth Sign In Flow
```
User taps "Sign In" button
         ↓
AuthScreenContent calls vm.submit()
         ↓
AuthViewModel.submit() {
  _state = ViewState.loading;
  notifyListeners();  // UI shows spinner
         ↓
  _currentUser = await _authRepository.signInWithEmail(email, password);
         ↓
  [MockAuthRepository | UserRepositoryFirebase]
    Makes HTTP call to Firebase:
    POST https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword
    {
      "email": "user@example.com",
      "password": "password123",
      "returnSecureToken": true
    }
         ↓
  Response: { "idToken": "...", "localId": "...", ... }
         ↓
  Returns AppUser(id: "...", email: "...", ...)
         ↓
  _state = ViewState.success;
  notifyListeners();  // UI hides spinner
}
         ↓
AuthScreenContent Consumer rebuilds
         ↓
Checks vm.state == ViewState.success
         ↓
Shows success animation or navigates to next screen
```

### Pass Purchase Flow
```
User selects pass and taps "Continue to Payment"
         ↓
PassSelectionContent calls vm.selectPass(PassType.monthly)
         ↓
PassSelectionViewModel.selectPass(type) {
  _selectedPassType = type;
  notifyListeners();  // UI shows selected pass highlighted
}
         ↓
User taps "Continue to Payment"
         ↓
App navigates to PaymentScreen
         ↓
PaymentScreen creates new PaymentViewModel (factory)
         ↓
PaymentViewModel.init(purpose: PASS, amount: 15.00)
         ↓
User selects payment method and taps "Pay"
         ↓
PaymentViewModel.processPayment() {
  _state = ViewState.loading;
  notifyListeners();  // Show loading overlay
         ↓
  // Use injected repositories
  _paymentRepository.processPayment(...)  // Firebase
  _passRepository.createPass(...)         // Firebase
         ↓
  _state = ViewState.success;
  notifyListeners();  // Show success
}
         ↓
UI shows success and navigates back
```

---

## 5️⃣ Testing Strategy

### Unit Test: ViewModel

```dart
void main() {
  group('AuthViewModel Tests', () {
    late MockAuthRepository mockRepo;
    late AuthViewModel viewModel;

    setUp(() {
      mockRepo = MockAuthRepository();
      viewModel = AuthViewModel(mockRepo);
    });

    test('submit() transitions through states correctly', () async {
      // ARRANGE - Set up mock
      when(mockRepo.signInWithEmail(any, any))
          .thenAnswer((_) async => AppUser(...));

      // ACT - Call the method
      final stateChanges = <ViewState>[];
      viewModel.addListener(() {
        stateChanges.add(viewModel.state);
      });
      
      await viewModel.submit();

      // ASSERT - Verify state transitions
      expect(stateChanges, [
        ViewState.loading,
        ViewState.success,
      ]);
      expect(viewModel.currentUser, isNotNull);
    });

    test('submit() sets error message on failure', () async {
      // ARRANGE
      when(mockRepo.signInWithEmail(any, any))
          .thenThrow(Exception('Invalid credentials'));

      // ACT
      await viewModel.submit();

      // ASSERT
      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, contains('Invalid credentials'));
    });
  });
}
```

### Widget Test: Content Widget

```dart
void main() {
  group('AuthScreenContent Tests', () {
    testWidgets('shows error banner when vm.errorMessage is set',
        (WidgetTester tester) async {
      // ARRANGE - Create mock viewmodel
      final mockVm = MockAuthViewModel();
      when(mockVm.errorMessage).thenReturn('Invalid email');
      when(mockVm.state).thenReturn(ViewState.error);

      // ACT - Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockVm,
            child: const AuthScreenContent(),
          ),
        ),
      );

      // ASSERT
      expect(find.byType(AppErrorBanner), findsOneWidget);
      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('shows loading spinner when state is loading',
        (WidgetTester tester) async {
      final mockVm = MockAuthViewModel();
      when(mockVm.state).thenReturn(ViewState.loading);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockVm,
            child: const AuthScreenContent(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

---

## 6️⃣ Common Patterns

### Pattern 1: Load Data on Screen Entry
```dart
class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyViewModel>().loadData();
    });
  }
}
```

### Pattern 2: Respond to ViewModel Changes
```dart
Consumer<MyViewModel>(
  builder: (context, vm, _) {
    if (vm.state == ViewState.success) {
      return SuccessWidget(data: vm.data);
    } else if (vm.state == ViewState.error) {
      return ErrorWidget(message: vm.errorMessage);
    } else {
      return LoadingWidget();
    }
  },
)
```

### Pattern 3: Call ViewModel Methods on User Action
```dart
TextButton(
  onPressed: () => context.read<AuthViewModel>().submit(),
  child: const Text('Sign In'),
)
```

### Pattern 4: Select Specific Data to Avoid Rebuilds
```dart
Selector<PassSelectionViewModel, PassType?>(
  selector: (_, vm) => vm.selectedPassType,  // Only listen to this
  builder: (context, selectedType, _) {
    return Text(selectedType?.name ?? 'None selected');
  },
)
```

---

## ✅ Checklist: Before Deploying to Production

- [ ] All repositories implement abstract base interface
- [ ] All ViewModels request repositories via constructor
- [ ] All Content widgets use Consumer<ViewModel>
- [ ] All mock repositories replaced with Firebase versions
- [ ] Error messages mapped to user-friendly strings
- [ ] Unit tests written for ViewModels
- [ ] Widget tests written for Content widgets
- [ ] Integration tests for user flows
- [ ] Firebase credentials configured in `.env`
- [ ] Analytical events added to key flows
- [ ] Crash reporting connected (Sentry/Firebase)
- [ ] Performance monitoring enabled
