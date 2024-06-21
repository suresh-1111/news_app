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
   git clone https://github.com/suresh-1111/news-app.git
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


## login screen



![login](https://github.com/suresh-1111/news_app/assets/120545788/a6d7d8f5-adfd-4047-a536-c577edd3bfb6)


## login screen with validation


![login validation](https://github.com/suresh-1111/news_app/assets/120545788/29569b7b-67fe-47ff-b8b4-316bb27cc275)




## register screen


![register](https://github.com/suresh-1111/news_app/assets/120545788/c2e7807b-fb5e-4411-b15c-018a8ebab648)




## register screen with validation


![register_validation](https://github.com/suresh-1111/news_app/assets/120545788/9ac22868-c40d-4c4f-bb87-d0cc0e196017)



## signin with google option



![signin with google](https://github.com/suresh-1111/news_app/assets/120545788/41161f54-bd29-47c2-98aa-3e9e9b57a61e)




## news home page 



![news homepage](https://github.com/suresh-1111/news_app/assets/120545788/bb220c70-e605-4b82-a346-62fb54f4da73)


## Login details stored in the firebase dB


![Screenshot (3)](https://github.com/suresh-1111/news_app/assets/120545788/c0a7dccd-abe6-4e6b-a5a8-73ab7f29c49e)





Please refer to the video uploaded in this repository demonstrating all functionalities.




