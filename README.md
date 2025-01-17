# snaarp

A feature-rich mobile client application that connects to an existing WebSocket server to
receive and execute remote control commands.

## Setup
1. Clone the repository:
   
       git clone <https://github.com/TheDanielsdev/Snaarp-assessment/tree/master>
       cd snaarp

2. flutter pub get
3. Run the app:

       flutter run
4. Features

       Connection Status: Shows whether the app is connected to the WebSocket server.
       User Logout: Allows remote logout of the user.
       Simulate Shutdown: Simulates a device shutdown when commanded.
       Geo-location Tracking: Real-time location tracking that can be toggled on/off from the server.
       Device Statistics: Displays and can update device statistics like battery level and storage usage.
       Remote Configuration: App settings can be configured remotely.

5. Code Structure

       Providers: Manage app state with RiverPod.
       Screens: Handle UI logic for different views.
       Widgets: Custom components for reusable UI elements.


6. Utils
       
       Contains helper functions
    
