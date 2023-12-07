# Project README

### Group Members Name and SID
#### Member 1: Jahanvi Mathukia - [SID]
#### Member 2: Aanisha Newaz - 100788588 - [Aanisha02](https://github.com/Aanisha02)
#### Member 3: Jessica Patel - 100785837 - [JessicaPatel711](https://github.com/JessicaPatel711?)
#### Member 4: Mansi Patel - [SID]
#### Member 5: Ethan Randle-Bragg - [SID]

## Changes from the Proposal
### Additions
Internationalization: Content and writings in Money Minder are translated into Spanish.
### Modification
Financial Goal Tracking and Budgeting: These two features are merged as they serve similar purposes. This will prevent the user from being confused about which list to navigate.

### Removal:
All attempts at challenging features have been discarded to ensure our app only has complete, usable features. <br>
**Extra challenges**: Receipt scanning, location tracking, multiple user support

## Working of the Whole App
### Brief Overview
MoneyMinder is a finance app designed to make daily tasks easier and more efficient. 
This application aims to develop a robust and user-friendly mobile application to track expenses, analyze spending patterns, and manage budgets and stocks. 
The developers of this application aim to provide users with a comprehensive tool to organize and manage their daily expenses. 

### Page Descriptions and Navigation
#### Landing Page
**Functionality**: Once the app is opened, the user is given the option to sign in or sign up to use the app. <br>
**Navigation**: This will be the landing page once the app is opened.

#### Sign in/Sign up pages
**Functionality**: User will be prompted to sign into their existing account using their email and password. Signing up will require their email, full name, username and password.<br>
**Navigation**: Landing page -> sign in or sign up button.

#### Transactions page
**Functionality**: User can view all their recent transactions, including income that comes in and expenses that goes out. The user can also filter their transactions by date. Finally, the user can export their transactions in a .csv format and upload it to drive or share it via email.<br>
**Navigation**: Landing Page -> *log in/sign up* -> the page will show up 

#### Financial insights
**Functionality**: This page will show two different graphs to visualize the user's recent spending. The first graph is a pie chart that shows a breakdown of where the user has been spending money on. The second graph is a double br graph which shows income and expenses side by side during the three most recent months.<br>
**Navigation**: Landing Page -> *log in/sign up* -> second button on bottom navigation **OR** Landing Page -> *log in/sign up* -> click hamburger menu -> click Financial Insights 

#### Add Transactions
**Functionality**: The user can add their transactions through this page. The user can add their transactions based on the following categories: Food, Shopping, Travel, Bills, Education, Subscriptions, Home, Other, and Income. Once the transaction has been added it can be soon on the transactions screen.<br>
**Navigation**:  Landing Page -> *log in/sign up* -> third button on bottom navigation 

#### Reminders
**Functionality**: The user can use the reminders functionality to be reminded to pay bills, to add in transactions or for any other financial reminders. The user will be notified 1 day before the due date of the reminder.]<br>
**Navigation**:  Landing Page -> *log in/sign up* -> fourth button on bottom navigation **OR** Landing Page -> *log in/sign up* -> click hamburger menu -> click Reminders

#### Investment insights
**Functionality**: [Description]<br>
**Navigation**: 

#### Budget goals
**Functionality**: [Description]<br>
**Navigation**:   Landing Page -> *log in/sign up* -> click hamburger menu -> click Budget Goals 

#### Settings
**Functionality**: The settings page is where the user can find user settings and learn about the data & privacy policies, help and support, and more about the application.<br>
**Navigation**:  Landing Page -> *log in/sign up* -> last button on bottom navigation **OR** Landing Page -> *log in/sign up* -> click hamburger menu -> click Settings

[Continue for each page as necessary]

Contribution of Each Member
[Jahanvi Mathukia]: [Describe the contributions, tasks, or roles of this member.]

[Aanisha Newaz]: [Worked on designing the user interface of the following pages: Financial Insights, Reminders, Budget goals. Worked on functionalities: Snackbar implementations, file sharing functionality, data visualizing using graphs, multiple pages/navigations, dialogs and pickers to create new reminders, goals, and add new transactions.]

[Jessica Patel]: [Worked on the user interface of the MoneyMinder application, more specifically worked on the following pages: Landing Page, Sign-In, Sign up, Home(transactions), Add transactions, Reminders, Settings, About, Privacy and security, Help & Support. Worked on functionalities: Notifications, custom navigation (app header and footer), multiple screen navigation, dialogs, and pickers for different pages.]

[Mnasi Patel]: [Contributions]

[Ethan Randle-Bragg]: [Contributions]

## How to run:
- git pull
- in your terminal, cd money_minder
- flutter pub get 
- flutter run      

## Some important points for development:

- Always run git pull before pushing
- flutter pub get 
- All the code for final project goes in this folder
- File structure:
     - assets - all the images that are used for the development of the mobile application.
       - Also add the images in pubspec.yaml file
    
    - lib
         - data - files for the SQLite database
         - model - files for SQLite database
         - views - all dart files
         - main.dart - code for the home page and other required imports

      - pubspec.yaml
          - all the required dependencies for the project
       
  ## *** New dependencies added***

  - Write the name of all new dependencies we added here so that we don't forget to add those when we run the project.

