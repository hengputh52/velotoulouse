You are a senior Flutter engineer. Before writing any code, scan the entire 
project directory tree and read these files completely:
  - lib/ui/theme/theme.dart (or equivalent theme file)
  - The existing bottom navigation bar file (search for BottomNavigationBar 
    or NavigationBar in the project) lib/ui/widgets/bottom_bar/bottom_bar.dart
  - Any existing screen files to understand current naming conventions

Do NOT assume any color value, text style, font name, radius, or spacing.
Every style token you use MUST come from the existing theme files.
If a token does not exist in the theme, create it in the correct theme file 
first, then reference it.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GLOBAL STATE vs SCREEN STATE — define before writing any ViewModel
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GLOBAL (registered as singleton in service_locator.dart, provided at app root 
in app.dart via MultiProvider):
  - AuthViewModel        — current AppUser, auth state stream
  - ActivePassViewModel  — currently active Pass (null if none), shared across 
                           map screen, booking screen, pass screen
  - ActiveBookingViewModel — currently confirmed Booking (null if none), drives 
                             the persistent bottom booking panel

SCREEN-LOCAL (registered with registerFactory in get_it, provided only at 
the screen's route level via ChangeNotifierProvider):
  - StationViewModel     — list of stations, selected station, loading/error
  - StationDetailViewModel — slots for the currently tapped station
  - PassSelectionViewModel — pass type selection state, purchase flow state
  - PaymentViewModel     — payment method selection, processing state
  - BookingViewModel     — booking confirmation logic, links payment to slot

STATE ENUM — create once in lib/core/enums/view_state.dart and import 
everywhere:
  enum ViewState { idle, loading, success, error }

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FIREBASE / HTTP PATTERN  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Payments use Firebase Realtime Database REST API (not Firestore) via http 
package. All other collections use Firestore. The payment base URI pattern is:

  final Uri paymentsUri = Uri.https(
    'YOUR_PROJECT_ID-default-rtdb.firebaseio.com',
    '/payments.json',
  );

In firebase_payment_repository.dart:
  - Use http.post(paymentsUri, body: jsonEncode(dto.toJson())) to write
  - Use http.get(Uri.https(host, '/payments/$id.json')) to read one record
  - Use http.patch(Uri.https(host, '/payments/$id.json'), body: ...) to update
  - Parse response with jsonDecode(response.body)
  - On http status != 200/201: throw a typed PaymentException with the body
  - Add 'Content-Type': 'application/json' to all request headers
  - The RTDB returns the new record's name (id) in {"name": "..."} on POST
  - Add the http package to pubspec.yaml if not already present

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FOLDER STRUCTURE — create every file in this exact location
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

lib/
  ui/
    screens/
      auth/
        auth_screen.dart
        auth_screen_content.dart
        auth_view_model.dart            ← GLOBAL singleton
        widgets/
          auth_form_field.dart
          social_login_button.dart
      station/
        station_detail_screen.dart
        station_detail_content.dart
        station_detail_view_model.dart
        widgets/
          bike_slot_card.dart
          slot_status_badge.dart
          station_header_card.dart
      pass/
        pass_selection_screen.dart
        pass_selection_content.dart
        pass_selection_view_model.dart
        widgets/
          pass_type_card.dart
          active_pass_banner.dart
          pass_price_tag.dart
      payment/
        payment_screen.dart
        payment_content.dart
        payment_view_model.dart
        widgets/
          payment_method_tile.dart
          order_summary_card.dart
          payment_processing_overlay.dart
      map/
        map_screen.dart
        map_screen_content.dart
        map_view_model.dart (StationViewModel)
        widgets/
          station_info_bottom_sheet.dart
          active_booking_panel.dart      ← driven by global ActiveBookingViewModel
          map_search_bar.dart
    widgets/                             ← shared across all screens
      app_primary_button.dart
      app_loading_overlay.dart
      app_error_banner.dart
      app_bottom_nav_bar.dart            ← your existing bottom bar

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN ARCHITECTURE PATTERN — apply identically to all 4 screens
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Every screen follows this exact 3-file pattern:

FILE 1: [name]_screen.dart
  - StatelessWidget (no logic here)
  - Wraps with ChangeNotifierProvider<[Name]ViewModel>(
      create: (_) => sl<[Name]ViewModel>(),
      child: const [Name]ScreenContent(),
    )
  - Also consumes global ViewModels with context.read<AuthViewModel>() etc.
  - Handles top-level navigation: if auth fails, redirect to auth screen
  - Sets up any initState logic via a Consumer that calls vm.init() once

FILE 2: [name]_screen_content.dart
  - StatelessWidget, uses context.watch<[Name]ViewModel>()
  - Renders the Scaffold, AppBar, body, floatingActionButton
  - Uses switch(vm.state) { ViewState.loading => ..., error => ..., success => ... }
  - Delegates sub-sections to named private methods or extracted widgets
  - Never contains business logic — only reads from ViewModel and calls its methods
  - Integrates the existing app bottom navigation bar at the Scaffold level

FILE 3: [name]_view_model.dart
  - extends ChangeNotifier
  - Constructor receives repository interfaces via get_it (no BuildContext)
  - ViewState state = ViewState.idle;
  - String? errorMessage;
  - All public methods are async, set state to loading first, 
    then success or error, always call notifyListeners() last
  - No Navigator calls — expose a callback or result object instead
  - No BuildContext stored anywhere

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 1 — AUTHENTICATION SCREEN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

auth_view_model.dart (GLOBAL singleton):
  Fields:
    ViewState state
    AppUser? currentUser
    String?  errorMessage
    bool     isLoginMode  (toggle login / register)
    final _emailController  = TextEditingController()
    final _passwordController = TextEditingController()
    final _nameController   = TextEditingController()
    bool obscurePassword = true

  Methods:
    void toggleMode()       — flips isLoginMode, clears error
    void toggleObscure()    — flips obscurePassword
    Future<void> submit()   — calls signIn or register based on isLoginMode
    Future<void> signOut()
    void initAuthListener() — called at app startup, listens to 
                             authRepository.watchAuthState() and sets currentUser

  Validation (in ViewModel, not widget):
    - email must contain '@' and '.'
    - password must be >= 6 characters
    - name required only in register mode
    Sets errorMessage and returns early if invalid (no network call)

auth_screen_content.dart:
  Layout:
    - No AppBar (full-screen auth experience)
    - SafeArea with SingleChildScrollView
    - App logo or branded header (use app primary color from theme)
    - AnimatedSwitcher between login form and register form 
      (keyed on isLoginMode) — smooth crossfade transition
    - Login form fields: Email, Password (obscurable)
    - Register form adds: Display Name field above email
    - "Forgot password?" TextButton (show SnackBar "not implemented yet")
    - Primary submit button: text changes between "Sign in" and "Create account"
      — shows CircularProgressIndicator when state == loading
    - TextButton to toggle mode: "Don't have an account? Register" / "Back to login"
    - Error display: AnimatedContainer that expands to show AppErrorBanner 
      when errorMessage != null

  Reusable widgets to extract:
    auth_form_field.dart:
      - Styled TextFormField using theme's inputDecorationTheme
      - Accepts: label, controller, isObscure, suffixIcon, keyboardType, validator
      - Shows trailing eye icon when isObscure param is provided

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 2 — VIEW BIKES AT A STATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

station_detail_view_model.dart:
  Constructor: StationDetailViewModel(this._stationRepo, this._bookingRepo)
  Fields:
    ViewState state
    Station?  station
    String?   errorMessage
    String?   selectedSlotId  (null until user taps a slot)

  Methods:
    Future<void> loadStation(String stationId)
    void selectSlot(String slotId)   — only if slot.isAvailable
    void clearSelection()

station_detail_screen.dart:
  - Receives stationId as a route parameter (via go_router extra or pathParam)
  - Provides StationDetailViewModel and calls vm.loadStation(stationId) in 
    a post-frame callback (using addPostFrameCallback)

station_detail_content.dart:
  Layout:
    - SliverAppBar with expandedHeight showing station name and 
      location address (collapsed on scroll)
    - SliverList of BikeSlotCards
    - Persistent bottom bar: "Book this bike" PrimaryButton
      — disabled (greyed) when selectedSlotId == null
      — on tap: navigate to /booking/:slotId passing station as extra
    - Loading state: Shimmer-style placeholder cards 
      (use AnimatedContainer with cycling opacity or just CircularProgressIndicator)
    - Error state: centered AppErrorBanner with retry button that calls vm.loadStation

  Reusable widgets to extract:

    bike_slot_card.dart:
      - Card with SlotNumber (large, prominent), status badge, tap ripple
      - Two visual states controlled by isAvailable:
          available: border uses theme primaryColor, white background
          unavailable: grey border, grey background, "Occupied" label
      - isSelected state: add a colored checkmark overlay, border thicker
      - onTap: only fires when isAvailable == true, calls vm.selectSlot(id)
      - Animate between states with AnimatedContainer (duration: 200ms)

    slot_status_badge.dart:
      - Pill-shaped chip: green background + "Available" 
        OR grey background + "Occupied"
      - Uses theme color tokens, not hardcoded colors

    station_header_card.dart:
      - Shows: station name (titleLarge), address (bodyMedium, muted),
        distance from user (bodySmall), available count "X bikes available"
      - Available count text color: green if > 0, red if 0

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 3 — PASS SELECTION SCREEN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

pass_selection_view_model.dart:
  Constructor: PassSelectionViewModel(this._passRepo, this._paymentRepo)
  Fields:
    ViewState     state
    PassType?     selectedPassType
    Pass?         activePass          (loaded on init)
    String?       errorMessage
    static const Map<PassType, double> prices = {
      PassType.day:     1.50,
      PassType.monthly: 15.00,
      PassType.annual:  99.00,
    }
    static const Map<PassType, String> descriptions = {
      PassType.day:     'Valid for 24 hours from activation',
      PassType.monthly: 'Valid for 30 days from activation',
      PassType.annual:  'Valid for 365 days from activation',
    }

  Methods:
    Future<void> loadActivePass(String userId)
    void selectPassType(PassType type)  — only if no active pass of same type
    Future<Payment?> initiatePayment(String userId, PaymentMethod method)
      — creates Payment via paymentRepo, returns Payment on success, null on fail
      — does NOT create the Pass here (PaymentScreen handles confirmation)

pass_selection_content.dart:
  Layout:
    - AppBar: "Choose a pass"
    - If activePass != null AND activePass.isActive:
        Show ActivePassBanner at top (non-dismissible)
        Still show other pass type cards below (user can upgrade)
    - PassTypeCard list (3 cards: Day, Monthly, Annual)
    - Selected card gets elevated border (primaryColor), unselected grey
    - Bottom sticky bar:
        Shows selected pass price "Total: $X.XX"
        "Continue to payment" PrimaryButton — disabled if selectedPassType == null
        On tap: navigate to /payment passing PassType and amount as extras

  Reusable widgets to extract:

    pass_type_card.dart:
      - Selectable card: PassType name (titleMedium), 
        description (bodySmall, muted), price (headlineSmall, primary color)
      - Duration badge top-right: "24h" / "30 days" / "1 year"
      - isSelected state: colored left border accent (3px), 
        light primary background tint
      - AnimatedContainer border transition (200ms)
      - If this pass type is the user's current active pass: 
        show "Current plan" badge, disable selection

    active_pass_banner.dart:
      - Info card with green tint (use theme success color or green from palette)
      - Shows: type label, expiry date formatted as "Expires 12 Jan 2026",
        days remaining as a pill "18 days left"
      - Compact — max 80px height

    pass_price_tag.dart:
      - Reusable price display: currency symbol small + amount large
      - Accepts: amount (double), label (String)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 4 — PAYMENT SCREEN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

payment_view_model.dart:
  Constructor: PaymentViewModel(this._paymentRepo, this._passRepo, 
                                this._bookingRepo)
  Fields:
    ViewState        state
    PaymentMethod    selectedMethod = PaymentMethod.card
    Payment?         completedPayment
    String?          errorMessage
    PaymentPurpose   purpose         (set from route extra)
    double           amount          (set from route extra)
    String?          pendingSlotId   (set from route extra if booking flow)
    String?          pendingPassType (set from route extra if pass flow)

  Methods:
    void init({required PaymentPurpose purpose, required double amount,
               String? slotId, String? passTypeString})
    void selectMethod(PaymentMethod method)
    Future<void> processPayment(String userId) 
      Steps (in order, each awaited):
        1. state = loading, notifyListeners()
        2. payment = await _paymentRepo.processPayment(
             userId, amount, selectedMethod, purpose)
        3. If payment.status == failed: state = error, return
        4. If purpose is a pass type:
             await _passRepo.purchasePass(userId, passType, payment.id)
        5. If purpose == singleTicket AND pendingSlotId != null:
             await _bookingRepo.createBooking(
               userId, pendingSlotId, stationId, paymentId: payment.id)
        6. completedPayment = payment
        7. state = success, notifyListeners()
      Wrap entire flow in try/catch — on any exception: 
        errorMessage = exception.toString()
        state = error
        notifyListeners()

payment_content.dart:
  Layout:
    - AppBar: "Payment" with back arrow
    - OrderSummaryCard at top (what they're paying for + amount)
    - Section label "Payment method"
    - List of PaymentMethodTile for each PaymentMethod enum value
    - Terms text (bodySmall, muted): "By continuing you agree to our terms"
    - Bottom sticky bar with total and "Pay [amount]" PrimaryButton
    - PaymentProcessingOverlay shown on top of everything when state == loading:
        Semi-transparent barrier + Card with CircularProgressIndicator + 
        "Processing payment..." text — NOT a Dialog (to avoid Navigator issues)
    - On state == success: navigate to /confirmation (handled in Screen file 
      via listener, NOT in Content widget)
    - On state == error: show AppErrorBanner inline (not a dialog), 
      button remains tappable so user can retry

  Reusable widgets to extract:

    payment_method_tile.dart:
      - ListTile-style row: leading icon (credit card / phone / cash),
        method name, trailing Radio widget
      - isSelected: Radio filled, row background lightly tinted
      - onTap: calls vm.selectMethod(method)
      - Icons: use Icons.credit_card, Icons.phone_android, Icons.money

    order_summary_card.dart:
      - Bordered card showing:
          Label (e.g. "Day Pass" or "Single Ticket") — titleMedium
          Description line — bodySmall, muted
          Divider
          Row: "Total" label left, amount right (large, primary color)
      - If pass type: show duration "Valid for 24 hours" below amount

    payment_processing_overlay.dart:
      - Stack child, fills parent with Colors.black.withOpacity(0.3)
      - Centered white card: CircularProgressIndicator + "Processing..." text
      - IgnorePointer wraps it so taps pass through only when not visible
      - Controlled by visibility (AnimatedOpacity), not mounted/unmounted

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BOTTOM NAVIGATION BAR — integrate existing widget
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Read the existing bottom bar widget file completely before touching it.
Identify the current items and their index mapping.

The nav bar must appear on these screens:
  - map_screen (index 0)
  - pass_selection_screen (index 1)
  - auth/profile_screen (index 2)

It must NOT appear on:
  - station_detail_screen (sub-screen)
  - payment_screen (modal flow)
  - booking confirmation screen

Integration approach:
  - The bottom bar reads context.watch<AuthViewModel>() for the profile icon 
    — show user initials if logged in, guest icon if not
  - Use go_router's StatefulShellRoute (or IndexedStack if not yet using 
    ShellRoute) to keep tab state alive between switches
  - Active booking indicator: if context.watch<ActiveBookingViewModel>()
    .activeBooking != null, show a small green dot badge on the map tab icon
  - Do NOT modify the existing bottom bar widget's visual styling — only 
    add the auth-awareness and booking badge

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ACTIVE BOOKING PANEL — persistent across map screen
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

active_booking_panel.dart (widget inside map/widgets/):
  - Reads context.watch<ActiveBookingViewModel>()
  - Shown as a DraggableScrollableSheet or bottom panel when 
    activeBooking != null
  - Shows: station name, slot number, "Booked" status chip, 
    "Cancel booking" TextButton
  - Slides in with AnimatedPositioned or SlideTransition when booking appears
  - Position: sits above the bottom nav bar (adjust bottom padding by 
    kBottomNavigationBarHeight)
  - Cancel booking: calls activeBookingVm.cancelBooking() 
    which calls bookingRepo.cancelBooking(id) then sets activeBooking = null

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UI/UX REQUIREMENTS — apply to all 4 screens
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Theme adherence:
  - All colors: Theme.of(context).colorScheme.XXX or AppColors.XXX
  - All text styles: Theme.of(context).textTheme.XXX or AppTextStyles.XXX
  - All border radii: AppRadius.XXX or Theme.of(context).XXX
  - Zero hardcoded Color(), TextStyle(), or BorderRadius() anywhere in widgets
  - All spacing: use AppSpacing constants or Theme spacing if defined

Loading states:
  - Every async action shows loading feedback immediately (never silent)
  - Buttons show CircularProgressIndicator inside them during loading 
    (replace the label, keep button same size to avoid layout shift)
  - List loads show shimmer-style placeholders (3 grey animated containers)
    Use AnimatedContainer with a repeating opacity tween

Error handling:
  - Network errors: show retry button + error message (never crash or freeze)
  - Auth errors: map Firebase error codes to human messages:
      'user-not-found' -> 'No account with that email'
      'wrong-password' -> 'Incorrect password'
      'email-already-in-use' -> 'An account already exists with that email'
      'network-request-failed' -> 'No internet connection'
      Default: 'Something went wrong. Please try again'
  - Payment errors: show inline error with specific message from repository

Empty states:
  - Station detail with 0 slots: "No slots found at this station" + icon
  - No active pass: handled by the booking flow branching, not an error
  - Payment history empty: not needed for this scope

Navigation:
  - All navigation uses go_router — no Navigator.push() anywhere
  - Auth guard: wrap protected routes with a redirect that checks 
    context.read<AuthViewModel>().currentUser != null
  - After successful payment, navigate to /confirmation then clear the 
    back stack so pressing back goes to map, not payment
  - Pass ?from=booking query param through the payment route so after 
    completing a pass purchase during booking, the app returns to 
    the booking screen automatically

Accessibility:
  - All buttons have Semantics label
  - Images and icons have semanticsLabel or excludeSemantics
  - Form fields have textInputAction set (TextInputAction.next / .done)
  - FocusNode management: tab order follows visual top-to-bottom order

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CODING STANDARDS — non-negotiable for every file
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Dart / Flutter:
  - All widgets: const constructor where possible
  - Extract any widget subtree > 15 lines into a named private widget class
    or a separate file if reused across screens
  - Never store BuildContext in a ViewModel or Repository
  - Dispose TextEditingControllers and FocusNodes in ViewModel.dispose()
  - Use addListener / removeListener cleanly — no leaked listeners
  - All Streams: cancel StreamSubscription in dispose()
  - Prefer final over var everywhere
  - No magic strings: route names in a AppRoutes constants class, 
    Firestore collection names in a AppCollections constants class

File structure:
  - Each file has exactly one public class
  - Imports ordered: dart:, package:flutter, package:third_party, 
    relative project imports (use your IDE's organizer)
  - File names: snake_case matching the class name

Documentation:
  - Each ViewModel method has a one-line // comment explaining its purpose
  - Each repository method has a one-line // comment
  - No obvious comments ("// set state to loading") — only explain WHY

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OUTPUT ORDER — generate files strictly in this sequence
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1.  lib/ui/state/view_state.dart
2.  lib/core/constants/app_routes.dart
3.  lib/core/constants/app_collections.dart
4.  lib/data/repositories/firebase_payment_repository.dart  (RTDB REST)
5.  lib/ui/widgets/app_primary_button.dart
6.  lib/ui/widgets/app_loading_overlay.dart
7.  lib/ui/widgets/app_error_banner.dart
8.  lib/ui/screens/auth/auth_view_model.dart
9.  lib/ui/screens/auth/widgets/auth_form_field.dart
10. lib/ui/screens/auth/auth_screen_content.dart
11. lib/ui/screens/auth/auth_screen.dart
12. lib/ui/screens/station/station_detail_view_model.dart
13. lib/ui/screens/station/widgets/slot_status_badge.dart
14. lib/ui/screens/station/widgets/bike_slot_card.dart
15. lib/ui/screens/station/widgets/station_header_card.dart
16. lib/ui/screens/station/station_detail_content.dart
17. lib/ui/screens/station/station_detail_screen.dart
18. lib/ui/screens/pass/pass_selection_view_model.dart
19. lib/ui/screens/pass/widgets/pass_price_tag.dart
20. lib/ui/screens/pass/widgets/active_pass_banner.dart
21. lib/ui/screens/pass/widgets/pass_type_card.dart
22. lib/ui/screens/pass/pass_selection_content.dart
23. lib/ui/screens/pass/pass_selection_screen.dart
24. lib/ui/screens/payment/payment_view_model.dart
25. lib/ui/screens/payment/widgets/order_summary_card.dart
26. lib/ui/screens/payment/widgets/payment_method_tile.dart
27. lib/ui/screens/payment/widgets/payment_processing_overlay.dart
28. lib/ui/screens/payment/payment_content.dart
29. lib/ui/screens/payment/payment_screen.dart
30. lib/ui/screens/map/widgets/active_booking_panel.dart
33. lib/main_dev.dart                     (update MultiProvider with global VMs)
32. lib/main_common.dart                   (update the bottom bar to align new update with screen)

After all files: run flutter analyze and fix every warning and error shown.
Then show me the complete updated folder tree.