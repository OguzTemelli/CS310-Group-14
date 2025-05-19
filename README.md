# CS310-Group-14
# DormMate 

# Main Purpose:

The app aims to solve the challenge of finding compatible roommates in dormitories. By collecting detailed lifestyle and preference data from students, the app uses clustering and similarity algorithms to match individuals with similar habits and needs. This improves living experiences and reduces conflicts among roommates.


# Target Audience:

Particularly those living in dorms or shared housing who want to ensure they are paired with compatible roommates. Also, the staff who oversee housing assignments and wish to streamline the process through data-driven matchings.


# Key Features:

# User Registration and Authentication:
  Secure sign-up and login features to protect user data.

# Test Submission:
  A detailed questionnaire where students provide information such as desired dorm size, daily room time, music disturbance tolerance, sports preferences, and cleanliness level.

# Data Processing and Matching:
# Clustering:
  The K-Means algorithm is used to group students based on test results.
# Weighted Similarity:
  Calculates similarity scores between student responses to recommend the best possible roommate matches.

# Admin Panel:
  Admins can trigger the matching process and release the results after verifying data quality.
  
# User Interface:
  Engaging UI screens for registration, test submission, and displaying match results.

# Email Notifications:
  Automatic email confirmations for premium membership purchases and feedback submissions using Firebase Cloud Functions and Brevo (SendInBlue).


# Platform:
  This app is developed via Flutter.

# Data Storage:
  User Profiles
  Test Results
  Clustering Results
  Admin Settings

# Unique Selling Point:
  The app distinguishes itself using advanced data-driven algorithms to ensure that roommate matches are not just random pairings. Its dual approach—clustering combined with a weighted similarity function—provides a more precise and personalized matching process.

# Challenges:
  
  -Optimizing performance, especially as the dataset grows.
  -Protecting sensitive user information with robust authentication and secure storage practices.
  -Maintaining performance and data integrity as the number of users increases.

## Firebase Features

DormMate uses several Firebase services:

- **Firestore Database**: Stores user profiles, test results, and matches
- **Authentication**: Secure user registration and login
- **Cloud Functions**: Handles email notifications for purchases and feedback
- **Hosting**: Deploys web version of the application

## Email Integration

The app includes automated email functionality for:
- Membership purchase confirmations
- Feedback submission acknowledgments

See [functions/README.md](functions/README.md) for details on email integration.
