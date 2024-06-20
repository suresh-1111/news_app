# News App with Authentication and Offline Storage

## Overview

This mobile application provides users with the latest news from various sources using the NewsAPI. It features a login/signup system, third-party authentication (Google ), and offline storage capabilities. The app ensures that users can access news even when they're offline.

## Features

- **User Authentication:** Users can sign up and log in using their credentials or via Google for quick access.
- **News Display:** News articles are fetched from NewsAPI and displayed in a user-friendly card format.
- **Offline Access:** News articles are stored locally, allowing users to read news even when offline.
- **Search and Filter:** Users can search for specific news articles and filter results within the app.
- **Responsive UI:** Each news card includes a title, description, publication date, source, and an image, all formatted for easy reading.

## Libraries/Frameworks Used

### Flutter and Related Packages

- **Flutter**: A comprehensive framework for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **firebase_core & firebase_auth**: Core Firebase libraries necessary for using Firebase services, including user authentication.
- **cloud_firestore & firebase_database**: Used for real-time database operations, data storage, and retrieval.
- **google_sign_in**: Allows authentication using Google OAuth, which simplifies the login process for users.
- **connectivity_plus**: Checks for an internet connection to handle online and offline data synchronization.

### UI and Utility Packages

- **cupertino_icons & fluttertoast**: Enhance the UI with icons and toast notifications for a better user interface experience.
- **cached_network_image**: Manages network images, caching them for quick reload and reduced bandwidth consumption.
- **country_code_picker & intl_phone_number_input**: Provide user-friendly, interactive tools for selecting country codes and inputting international phone numbers.

### Data Management and Storage

- **hive & hive_flutter**: NoSQL database for effective and efficient local storage and retrieval of data.
- **path_provider**: Finds commonly used locations on the filesystem for storing app data.
- **intl**: Facilitates internationalization and localization operations, including formatting dates and times.

### Networking

- **http**: Facilitates network requests to APIs, essential for fetching data from remote servers like the NewsAPI.

## Installation

1. Clone the repository:
   git clone https://github.com/yourusername/news-app.git
2. Navigate to the project directory:
   cd news-app
3. Install dependencies:
  flutter pub get
4. Run the app:
   flutter run
## How to Use

- **Sign Up/Login:** Start by signing up or logging in using your email and password, or use the Google sign-in option.
- **Browse News:** After logging in, browse the news presented in a card format.
- **Search and Filter:** Use the search bar to find specific news articles or apply filters.
- **Read Offline:** Access stored news articles even without an internet connection.
  
## Screenshots/Videos
Please refer to the screenshots uploaded in this repository demonstrating all functionalities.

1.login screen
2.login screen with validation
3.register screen
4.register screen with validation
5.signin with google option
6.news home page 

Please refer to the video uploaded in this repository demonstrating all functionalities.




