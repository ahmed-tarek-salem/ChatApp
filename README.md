# ChatApp

Social media application using flutter firebase services as back-end.

# Download link

https://drive.google.com/file/d/1yvGnjbWtCEMxJOAek1rtfPFL8ZQim-4-/view?usp=sharing

# Screenshots
<p align="center">
  <img src='Screenshots/Demo.png' width="800" /> 
  <img src='Screenshots/sc1.jpg' width="450" /> 
  <img src='Screenshots/sc2.jpg' width="450" /> 
  <img src='Screenshots/sc3.jpg' width="450" /> 
  <img src='Screenshots/sc4.jpg' width="450" /> 
  <img src='Screenshots/sc5.jpg' width="450" /> 
  <img src='Screenshots/sc6.jpg' width="450" /> 
  <img src='Screenshots/sc7.jpg' width="450" /> 
  <img src='Screenshots/sc8.jpg' width="450" /> 
  <img src='Screenshots/sc9.jpg' width="450" /> 
  <img src='Screenshots/sc10.jpg' width="450" /> 
  <img src='Screenshots/sc11.jpg' width="450" /> 
  <img src='Screenshots/sc12.jpg' width="450" /> 
  <img src='Screenshots/sc13.jpg' width="450" /> 
  <img src='Screenshots/sc14.jpg' width="450" /> 
  <img src='Screenshots/sc15.jpg' width="450" /> 
  
  

</p>

# Features
- Full authentication with firebase containing (Sign in, Sign up, logout).
 -Save the user data when sign up or log in for the first time to keep logged in using Shared-Preferences.
- Back end validation and error handling incase of wrong inputs or technical issue.
- Updating profile info like status, username and user's profile image.
- Searching for users by username.
- Real-time messages with immediate response using streams.
- User friendly screens with some smooth animations like Hero animation.
- Beautiful UI and color alerting when receiving unseen messages.
- Exploring other user's profiles and ability to know whether they offline or online.
- Get Location with Geoloactor to get latitude and longitude and geocoding to determine your exact address.
- Uploading posts with description and location, and ability to remove them later.
- Exploring posts and searching for some keywords.
- Provider as statemanagement

# Why used Cloud Firestore rather than Real-time database?

This is a one-to-one application, there are no chat groups or something like that. Let's assume we have two friends each one sends 10 messages to the other, we will have 20 messages and the users will read the 20 documents so we will have 40 reads. It is good. 

But if we have a chat group that contains 10 friends. and only two friends send each other 10 messages; we will have 20 documents. but 200 reads. because every friend will read these 20 documents. So in this case (which is not included in our application), we might need to use a real-time database. 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
