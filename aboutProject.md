Project Evaluation
The evaluation is divided into six key parts:
PART 1 - UX / UI
✅Wireframe validates Nielsen’s 10 Usability Heuristics for mobile apps
✅Project Design System is well defined on Figma (colors, texts, spacings, components)
PART 2 - WIDGETS ARCHITECTURE
✅App Theme is well defined with a Design System (colors, texts, spacings, components)
✅No hard-coded styles repeated in many places
✅Library of reusable widgets created
✅Screens are well organized and divided into sub-widgets
PART 2 – STATE ARCHITECTURE
✅State architecture well defined (global VS screen VS widget states)
✅MVVM architecture: VM manages screen logic, VIEW remains presentation-focused
PART 3 – DATA ARCHITECTURE
✅ Repositories defined through abstract interfaces
✅ DTOs used for data transfer
✅ Both mock repositories and real repositories implemented
✅ Async calls handled correctly (Future, Streams)
✅ Loading and error states managed in the view model and view
PART 4 – FIREBASE, LOCAL STORAGE
✅App connected to Firebase and local storage if needed
✅Firebase collections properly designed
✅Data models mapped to Firebase documents
✅Push notifications are integrated (OPTIONAL)
PART 6 – TEAMWORK & PROJECT OUTCOMES
✅Jira User Stories are well-defined and broken down into subtasks
✅Subtasks are correctly assigned per team member
PART 7 – FEATURES
✅Project finally validates at least 50% of the user specifications

US1 – Select a Pass
As a user, I want to select a pass to rent bikes so that I can ride without buying a ticket each time.
Acceptance points:
• A pass allows the user to rent bikes multiple times during its validity period.
• Available pass types:
o Day pass
o Monthly pass
o Annual pass
• Each pass has an expiration date.
• A user can have only one active pass at a time (passes are not cumulative).
US2 – View Stations on a Map
As a user, I want to view bike stations on a map so that I can easily find where to rent a bike.
Acceptance points:
• Stations are displayed on a map.
• Each station indicates the number of bikes available.
• Stations with available bikes should be visually highlighted.
US3 – View Bikes at a Station
As a user, I want to view the bikes available at a station so that I can choose a bike to rent.
Acceptance points:
• When a user selects a station on the map:
o The list of bike slots is displayed.
• Each slot shows its status:
o Available bike
o Empty slot


US4 – Book a Bike
As a user, I want to book a bike so that I can reserve it before starting my ride.
Acceptance points:
• When selecting an available bike, the booking screen should appear.
Case 1 – User already has an active pass
o The user can confirm the bike booking directly.
Case 2 – User does not have a pass
o The user must choose one of the following options:
o Buy a single ticket
o Go to the pass selection screen to buy a period-based pass
o After completing the purchase, the user can confirm the bike booking.
• After booking the bike, the bike should not be available anymore on the station.
US5 – Payment NICE TO HAVE, NOT IMPORTANT
As a user, I want to pay for my ticket or pass so that I can unlock and rent a bike.
Acceptance points:
• Payment is required when:
o buying a single ticket
o buying a period-based pass
• After successful payment:
o the pass or ticket becomes active
o the user can confirm the bike booking
US6– Pick up the bike NICE TO HAVE, NOT IMPORTANT
As a user, I want to see my currently booked bike so that I know which bike I reserved and which slot to pick it
up.
Acceptance points:
• After a bike booking is confirmed, the app displays a “Current Ride / Current Booking” panel or screen.
o The panel shows:
o the station name
o the bike slot number
o The panel remains accessible from the main screen (e.g., persistent bottom panel or ride screen).