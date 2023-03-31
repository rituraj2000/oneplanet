# OnePlanet

[![OnePlanet Logo](http://img.youtube.com/vi/3rXXsrO_mBQ/0.jpg)](http://www.youtube.com/watch?v=3rXXsrO_mBQ "OnePlanet")

# About App

OnePlanet aims to foster a more sustainable future by encouraging SDG action and continually evaluating their strategy to better serve their users.The app enables users to organize and participate in various drives, such as cleanliness drives and donation drives, to contribute towards achieving the SDGs.


## Installation Guide

1. **Install Flutter on your machine**

    Install flutter by selecting the operating system on which you are installing Flutter: [Flutter installation tutorial](https://flutter.dev/docs/get-started/install)

    To check if you have flutter installed along wtih proper necesarry SDKs installed
    run `flutter doctor`
    
2. **Fork and Clone the Repo**

    Fork the repo by clicking on the **Fork** button on the top right corner of the page.
    
    To clone this repository, run `git clone https://github.com/asutoshranjan/oneplanet.git`
    
    Make sure you are inside `oneplanet` directory
    
    
3. **Get Packages**

    - From the terminal: Run `flutter pub get`.
      _OR_
    - From Android Studio/IntelliJ: **Click Packages get** in the action ribbon at the top of `pubspec.yaml`.
    - From VS Code: **Click Get Packages** located in right side of the action ribbon at the top of `pubspec.yaml`.

    After the above steps, you should see the following message in the terminal   
    
4. **Create Firebase Project**
    
    Go to [Firebase website](https://firebase.google.com/) make sure you are loggedin with a google account and cick on **Go to console** button.<br>
    Add a **new firebase project** with desired name and now your firebase project is up and running<br>
    Enable **Google** for authentication as the auth provider in firebase authentication setting<br>
    Add your **SHA1** key so that you can test as a developer on an emulator or device
    
    
5. **Add Flutter App to your Firebase Project**

    Make sure that you have the [Firebase CLI](https://firebase.google.com/docs/cli?authuser=0&hl=en#install_the_firebase_cli) installed in your machine<br>
    
    Run `firebase login` to **login** with your **firebase account** <br>
    
    Run `dart pub global activate flutterfire_cli` <br>
    
    Then run `flutterfire configure --project=PLACE YOUR PROJECTID` at the root of your Flutter project directory
    



### Run the App

  On terminal:

- Check that an Android device is running by running `flutter devices`. If none are shown, follow the device-specific instructions on the [Install](https://flutter.dev/docs/get-started/install) page for your OS.
- Run the app with the following command: `flutter run`


## Contributing

Please refer to the project's style and contribution guidelines for submitting patches and additions. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes


## Use

- Organizing social welfare events 
- Participating in events 
- Reading blogs of prev events 
- Connecting to people 
- Community chat groups
- Goverment schemes and awareness
