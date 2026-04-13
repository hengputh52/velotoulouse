You are an expert Flutter developer. I am building a bike-sharing mobile app 
using Flutter with MVVM architecture, Provider for state management, get_it 
for dependency injection, and Firebase (Firestore + Auth) as the backend.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DOMAIN MODELS  (already exist in lib/domain/models/)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// location.dart
class Location {
  final String  id;
  final double  latitude;
  final double  longitude;
  final String? address;
  final String? city;
  // distanceTo(Location) Haversine in km
  // toLatLng() -> google_maps_flutter LatLng
}

// station.dart
class Station {
  final String          id;
  final String          locationId;
  final String          name;
  final List<BikeSlot>  slots;
  final Location        location;   // hydrated by repo
  // availableBikes getter
  // lat, lng, address passthrough getters
  // distanceTo(Location) delegates to location
}

// bike_slot.dart
class BikeSlot {
  final String id;
  final String stationId;
  final int    slotNumber;
  final bool   isAvailable;
  // copyWith(isAvailable)
}

// app_user.dart
class AppUser {
  final String   uid;
  final String   email;
  final String?  displayName;
  final DateTime createdAt;
  // factory AppUser.fromFirebase(User u)
}

// pass.dart
enum PassType { day, monthly, annual }
class Pass {
  final String   id;
  final String   userId;
  final String   paymentId;
  final PassType type;
  final DateTime expiresAt;
  // isActive getter
  // daysLeft getter
}

// payment.dart
enum PaymentMethod  { card, mobileMoney, cash }
enum PaymentStatus  { pending, success, failed }
enum PaymentPurpose { singleTicket, dayPass, monthlyPass, annualPass }
class Payment {
  final String         id;
  final String         userId;
  final double         amount;
  final PaymentMethod  method;
  final PaymentStatus  status;
  final PaymentPurpose purpose;
  final DateTime       createdAt;
  // isForPass getter
}

// booking.dart
enum BookingStatus { confirmed, cancelled, completed }
class Booking {
  final String        id;
  final String        userId;
  final String        bikeSlotId;
  final String        stationId;
  final String?       paymentId;  // null if pass used
  final String?       passId;     // null if ticket used
  final BookingStatus status;
  final DateTime      bookedAt;
  // assert: exactly one of paymentId / passId is non-null
  // paidByPass getter
  // paidByTicket getter
}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TASK 1 — FIREBASE SETUP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Update pubspec.yaml to add these dependencies (use latest stable versions):
  firebase_core, firebase_auth, cloud_firestore,
  provider, get_it, google_maps_flutter, shared_preferences, go_router

Create lib/core/firebase/firebase_options.dart as a placeholder with a 
comment explaining the developer must run:
  flutterfire configure
to auto-generate the real file.

Create lib/main.dart that:
  1. Calls WidgetsFlutterBinding.ensureInitialized()
  2. Awaits Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  3. Calls setupLocator(useMocks: false)
  4. Runs runApp(const App())

Create lib/app.dart with MaterialApp, a basic AppTheme, and placeholder routes 
for: /map, /station/:id, /pass, /booking/:slotId, /payment, /confirmation.

Create lib/core/di/service_locator.dart with get_it that registers:
  - All repository interfaces mapped to either mock or Firebase implementations
    based on a useMocks boolean flag
  - All ViewModels registered as registerFactory (not singleton)
  - Include: StationRepository, PassRepository, PaymentRepository, 
    BookingRepository, AuthRepository

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TASK 2 — DTOs  (create in lib/data/dtos/)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Create one file per DTO. Each DTO must have:
  - All fields as final
  - A factory fromJson(Map<String, dynamic> json) constructor
  - A toJson() -> Map<String, dynamic> method
  - A toModel() method that returns the corresponding domain model
  - Handle Firestore Timestamp -> DateTime conversion where needed
  - Handle nullable fields safely with null-aware operators

Files to create:
  location_dto.dart   -> LocationDto   -> Location
  station_dto.dart    -> StationDto    -> Station  (accepts List<BikeSlot> + Location as toModel params)
  bike_slot_dto.dart  -> BikeSlotDto   -> BikeSlot
  app_user_dto.dart   -> AppUserDto    -> AppUser
  pass_dto.dart       -> PassDto       -> Pass     (map 'day'/'monthly'/'annual' string <-> PassType enum)
  payment_dto.dart    -> PaymentDto    -> Payment  (map all 3 enums to/from string)
  booking_dto.dart    -> BookingDto    -> Booking  (map BookingStatus to/from string)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TASK 3 — REPOSITORY INTERFACES  (create in lib/domain/repositories/)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Create one abstract class per file:

station_repository.dart:
  Future<List<Station>> getStations()
  Stream<List<Station>> watchStations()
  Future<Station?> getStationById(String id)

pass_repository.dart:
  Future<Pass?> getActivePass(String userId)
  Future<List<Pass>> getPassHistory(String userId)
  Future<Pass> purchasePass(String userId, PassType type, String paymentId)

payment_repository.dart:
  Future<Payment> processPayment({
    required String userId,
    required double amount,
    required PaymentMethod method,
    required PaymentPurpose purpose,
  })
  Future<List<Payment>> getPaymentHistory(String userId)

booking_repository.dart:
  Future<Booking> createBooking({
    required String userId,
    required String bikeSlotId,
    required String stationId,
    String? paymentId,
    String? passId,
  })
  Future<Booking?> getActiveBooking(String userId)
  Future<void> cancelBooking(String bookingId)

auth_repository.dart:
  Future<AppUser?> signInWithEmail(String email, String password)
  Future<AppUser> registerWithEmail(String email, String password)
  Future<void> signOut()
  Stream<AppUser?> watchAuthState()
  AppUser? get currentUser

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TASK 4 — MOCK REPOSITORIES  (create in lib/data/repositories/)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Create one file per mock repository. Each mock must:
  - implement the abstract interface
  - use realistic hardcoded data (use Phnom Penh coordinates for stations)
  - simulate async delay with: await Future.delayed(const Duration(milliseconds: 600))
  - NOT throw errors (happy path only — used for UI development)

Files:
  mock_station_repository.dart   — 4 stations with real Phnom Penh lat/lng,
                                   each with 4-6 bike slots, some available some not
  mock_pass_repository.dart      — return a monthly pass active for 20 more days
  mock_payment_repository.dart   — always returns PaymentStatus.success
  mock_booking_repository.dart   — returns a confirmed Booking with fake IDs
  mock_auth_repository.dart      — returns a hardcoded AppUser, watchAuthState 
                                   emits that user immediately

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TASK 5 — FIREBASE REPOSITORIES  (create in lib/data/repositories/)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Create one file per Firebase repository. Each must:
  - implement the abstract interface
  - use FirebaseFirestore.instance and FirebaseAuth.instance
  - use the corresponding DTOs for all serialization
  - handle errors by wrapping in try/catch and rethrowing typed exceptions
  - use Firestore transactions where atomicity is needed

firebase_station_repository.dart:
  - getStations(): fetch stations collection, for each doc fetch its slots 
    sub-collection, parse location from embedded map field, return List<Station>
  - watchStations(): use snapshots() stream, same hydration logic

firebase_pass_repository.dart:
  - getActivePass(): query passes where userId==uid AND expiresAt > now, 
    return first result or null
  - purchasePass(): write new Pass doc to passes/ collection

firebase_payment_repository.dart:
  - processPayment(): write Payment doc to payments/ collection with 
    status=pending, simulate processing (1s delay), update to success, return Payment
  - This is the MOCK-REAL hybrid: writes to Firestore but doesn't call 
    a real payment gateway

firebase_booking_repository.dart:
  - createBooking(): use a Firestore TRANSACTION that:
      1. Reads the bikeSlot document
      2. Checks isAvailable == true (throws if not)
      3. Writes new Booking document to bookings/
      4. Updates bikeSlot.isAvailable = false
    All in one atomic transaction.
  - getActiveBooking(): query bookings where userId==uid AND status==confirmed

firebase_auth_repository.dart:
  - signInWithEmail / registerWithEmail using FirebaseAuth
  - After register: write AppUser doc to users/ collection
  - watchAuthState(): FirebaseAuth.instance.authStateChanges()
    .map((fbUser) => fbUser == null ? null : AppUser.fromFirebase(fbUser))

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CODING STANDARDS — apply to every file you generate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Every file starts with the correct relative import path comment
2. Use const constructors wherever possible
3. All fields are final
4. No dynamic types — use proper generics and typed maps
5. Enums are mapped to strings using .name (Dart 2.15+) and 
   parsed with EnumName.values.byName(string)
6. Firestore Timestamps converted with .toDate() 
   and DateTime stored with Timestamp.fromDate(dateTime)
7. Nullable fields handled with null-aware ?. and ?? operators
8. Each file has a single responsibility — no mixing of concerns
9. All async methods have proper try/catch with meaningful error messages
10. No print() statements — use debugPrint() if logging is needed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OUTPUT FORMAT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Generate each file in a separate code block.
Label each block with the full file path as a comment on the first line.
Work through the tasks in order: Firebase setup → DTOs → interfaces → 
mock repos → Firebase repos.
After all files, show the final lib/ folder tree showing every created file.