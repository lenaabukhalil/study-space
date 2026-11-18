# Yasmine Workspace

**Your calm corner to study and work in Amman.**

Yasmine Workspace is a Flutter app for booking study rooms and desks at a co-working space in Jabal Al-Weibdeh, Amman. Customers can browse spaces, pick a date and time, and book in a few taps. Admins manage rooms and all bookings. Bookings update live for every user. This is my final project for a Flutter training program.

---

## Features

### For customers

- **Browse and filter**: room and desk cards with photo, capacity, price per hour and amenities. You can filter by All, Rooms, Desks or Favorites.
- **Favorites**: tap the heart on a card or on the room page to save it. Favorites are stored on the device for each account.
- **Booking flow**: pick a date (up to 14 days ahead), a duration (1 to 3 hours) and a start time from the hourly slot grid. Slots that are booked, in the past, or too short for the chosen duration are disabled.
- **Opening hours**: Saturday to Thursday 09:00 to 22:00, Friday 14:00 to 22:00.
- **Weather for the booking day**: the forecast from Open-Meteo is shown under the selected date and in the booking summary.
- **Payment method**: pay at the front desk or by card on arrival.
- **Booking confirmation**: a summary sheet before booking and a success dialog after it.
- **My Bookings**: all your bookings sorted by date, with cancellation when it's still allowed.
- **Cancellation policy**: shown in the app and enforced when you cancel.
- **Remembers your choices**: the last filter and the last booking duration are restored the next time the app opens.

### For admins

- **Manage rooms**: add, edit and delete rooms and desks (name, type, capacity, price, amenities, image). A room with upcoming bookings can't be deleted.
- **All bookings**: view every booking for any day and cancel any of them.

### Booking rules

| Rule              | Detail                                                                                 |
| ----------------- | -------------------------------------------------------------------------------------- |
| No past bookings  | The start time must be in the future                                                   |
| Opening hours     | The booking must start and end within that day's opening hours                         |
| Max duration      | 3 hours per booking, in whole hours                                                    |
| Daily limit       | Max 2 bookings per customer per day                                                    |
| Cancellation      | Customers can cancel up to 1 hour before the start time. Admins can cancel at any time |
| No double booking | Each room hour can only be booked once                                                 |

---

## Highlights

- **Double-booking prevention.** Each booked hour has its own lock document in `slots`, with the ID `roomId_yyyyMMdd_HH`. A booking is created inside a Firestore transaction. The transaction reads every slot in the requested range and fails if any of them already exists. Otherwise it writes the slots and the booking together. If two users book the same hour at the same moment, only one booking is saved, and the other user sees "This time was just booked by someone else".
- **Authentication vs authorization.** Firebase Auth checks who the user is (email and password). Firestore Security Rules check what they're allowed to do, using the `role` field in `users/{uid}` (`customer` or `admin`). The rules enforce the access limits, not just the UI:
  - Users can't change their own role.
  - Only admins can write rooms.
  - Customers can only read and create their own bookings.
  - Bookings in the past are rejected.
  - Customers can only cancel up to 1 hour before the start time.
- **Real-time updates.** Rooms, bookings and slot availability use Firestore snapshot streams. When one user books a slot, it becomes unavailable for everyone else straight away.

---

## Tech stack

| Package                                                           | Version            | Used for                                  |
| ----------------------------------------------------------------- | ------------------ | ----------------------------------------- |
| Flutter / Dart                                                    | Dart SDK `^3.13.7` | UI framework and language                 |
| [provider](https://pub.dev/packages/provider)                     | `^6.1.5+1`         | State management                          |
| [firebase_core](https://pub.dev/packages/firebase_core)           | `^5.2.0`           | Firebase initialization                   |
| [firebase_auth](https://pub.dev/packages/firebase_auth)           | `^7.1.0`           | Email and password sign-in                |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore)       | `^7.2.0`           | Database, transactions, real-time streams |
| [http](https://pub.dev/packages/http)                             | `^1.6.0`           | Weather forecasts from the Open-Meteo API |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | `^2.5.6`           | Favorites and saved choices on the device |
| [google_fonts](https://pub.dev/packages/google_fonts)             | `^8.0.0`           | Poppins and Playfair Display fonts        |
| [intl](https://pub.dev/packages/intl)                             | `^0.20.3`          | Date, time and price formatting           |

---

## Architecture

```
lib/
├── config/      Space info and opening hours
├── data/        Sample rooms, amenity list, room image options
├── models/      Room, Booking, WeatherForecast, result and payment types
├── providers/   ChangeNotifiers: auth, rooms, bookings, favorites, weather, admin
├── services/    Firebase Auth, Firestore, Open-Meteo HTTP client, local storage
├── screens/     Full pages: login, sign up, rooms, room details, bookings, profile, admin
├── widgets/     Small reusable UI pieces (cards, slot grid, dialogs, chips, ...)
├── theme/       App colors, text styles and layout sizes
└── utils/       Formatters and form validators
```

The app uses an MVC-style layered structure: **UI (screens/widgets) → providers → services**. Widgets read state from providers and never call Firebase, HTTP or storage directly. All Firestore access goes through one class, `FirestoreService`.

---

## Firestore data model

| Collection | Document ID          | Main fields                                                                               |
| ---------- | -------------------- | ----------------------------------------------------------------------------------------- |
| `rooms`    | auto / sample ID     | `name`, `type` (`room` \| `desk`), `capacity`, `pricePerHour`, `amenities[]`, `imagePath` |
| `bookings` | auto                 | `roomId`, `userId`, `start`, `end`, `createdAt`, `paymentMethod`, `userName`, `userEmail` |
| `slots`    | `roomId_yyyyMMdd_HH` | `roomId`, `bookingId`, `userId`, `start` (one doc per booked hour)                        |
| `users`    | Auth `uid`           | `name`, `email`, `role` (`customer` \| `admin`), `createdAt`                              |

Composite indexes on (`roomId`, `start`) for `bookings` and `slots` are defined in `firestore.indexes.json`.

---

## Course topics covered

| Topic                           | Where it appears                                                                                                                                                    |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Dart & async                    | `async`/`await` and `Future`s in services, `Stream` subscriptions in providers, records, enums, pattern-matching `switch`                                           |
| Widgets & UI                    | Material 3 theme, responsive room grid, slot grid, bottom sheets, dialogs, chips, custom reusable widgets                                                           |
| Navigation                      | Auth gate (login ↔ sign up), bottom navigation bar, push to room details and the admin room form                                                                    |
| State management with Provider  | `MultiProvider`, `ChangeNotifierProxyProvider` linked to the signed-in user, `watch`/`select`/`read`                                                                |
| HTTP & JSON                     | `WeatherService`: GET request with a timeout, status code check, JSON parsing with `fromJson`, friendly errors, 30-minute in-memory cache, loading and error states |
| Local storage                   | `LocalStorageService` with `shared_preferences`: favorites saved per user, last filter, last duration                                                               |
| Firebase Auth & Firestore       | Sign up and sign in, user profiles, real-time queries, transactions, batch writes                                                                                   |
| Authentication vs authorization | Firebase Auth for identity, `role` field plus Firestore Security Rules for access, admin-only tab in the UI                                                         |

---

## Getting started

### Prerequisites

- Flutter SDK (Dart `^3.13.7`)
- A Firebase account
- Firebase CLI (`npm install -g firebase-tools`) and FlutterFire CLI (`dart pub global activate flutterfire_cli`)

### Setup

1. **Clone and install**
   ```bash
   git clone https://github.com/lenaabukhalil/study-space.git
   cd study-space
   flutter pub get
   ```
2. **Create your own Firebase project** in the [Firebase Console](https://console.firebase.google.com/).
3. **Enable services**: turn on **Authentication → Email/Password** and create a **Cloud Firestore** database.
4. **Connect the app**
   ```bash
   firebase login
   flutterfire configure
   ```
   This creates `lib/firebase_options.dart` for your project.
5. **Deploy the security rules and indexes**
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```
6. **Run the app**
   ```bash
   flutter run -d chrome
   ```
7. **Make an admin**: sign up in the app, then in the Firestore Console open `users/{uid}` and set `role` to `"admin"`. The Admin tab appears right away. When an admin signs in and the `rooms` collection is empty, the sample rooms are added automatically.

---

## Credits

- Weather data by [Open-Meteo](https://open-meteo.com/) (free, no API key).
- Room photos are placeholders for demo purposes.

---

## Author

**Lena AbuKhalil**: [github.com/lenaabukhalil](https://github.com/lenaabukhalil)
