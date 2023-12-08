# MoneyMinder README

## Group Members Name and SID
#### Member 1: Jahanvi Mathukia - 100832165 - [JahanviMathukia](https://github.com/JahanviMathukia)
#### Member 2: Aanisha Newaz - 100788588 - [Aanisha02](https://github.com/Aanisha02)
#### Member 3: Jessica Patel - 100785837 - [JessicaPatel711](https://github.com/JessicaPatel711?)
#### Member 4: Mansi Patel - 100805283 - [mansi-patel3](https://github.com/mansi-patel3)
#### Member 5: Ethan Randle-Bragg - [100742591] [EthanRandle](https://github.com/EthanRandle)

## Changes from the Proposal
### Additions
Internationalization: Content and writings in Money Minder are translated into Spanish.
### Modification
Financial Goal Tracking and Budgeting: These two features are merged as they serve similar purposes. This will prevent the user from being confused about which list to navigate.

### Removal:
All attempts at challenging features have been discarded to ensure our app only has complete, usable features. <br>
**Challenges Removed**: Receipt scanning, location tracking, multiple user support. 

## Working of the Whole App
### Brief Overview
MoneyMinder is a finance app designed to make daily tasks easier and more efficient. 
This application aims to develop a robust and user-friendly mobile application to track expenses, analyze spending patterns, and manage budgets and stocks. 
The developers of this application aim to provide users with a comprehensive tool to organize and manage their daily expenses. 

## Page Descriptions and Navigation
### Landing Page
**Functionality**: Once the app is opened, the user is given the option to sign in or sign up to use the app. <br>
**Navigation**: This will be the landing page once the app is opened.

### Sign in/Sign up pages
**Functionality**: User will be prompted to sign into their existing account using their email and password. Signing up/ creating account for new users will require their email, full name, username and password. <br>
**Navigation**: Landing page -> sign in or sign up button.

**To test this app**: For sign in use emailAddress: testuser@gmail.com and Password: Password1!

### Transactions page
**Functionality**: User can view all their recent transactions, including income that comes in and expenses that goes out with the current total balance of the account. The user can also filter their transactions by date. Finally, the user can export their transactions in a .csv format and upload it to drive or share it via email, discord, etc based on device permissions.<br>
**Navigation**: Landing Page -> *log in/sign up* -> *Home*

### Financial insights
**Functionality**: This page will show two different graphs to visualize the user's recent spending. The first graph is a donut chart that shows a breakdown of where the user has been spending money based on different expense categories. The second graph is a double bar graph which shows total income and total expense side by side of last three months.<br>
**Navigation**: Landing Page -> *log in/sign up* -> *Insights* 
**OR** Landing Page -> *log in/sign up* -> click hamburger menu -> *Financial Insights*

### Add Transactions
**Functionality**: The user can add their new transactions through this page. The user can add their transactions based on the following categories: Food, Shopping, Travel, Bills, Education, Subscriptions, Home, Other, and Income. Once the transaction has been added it can be seen on the transactions screen.<br>
**Navigation**:  Landing Page -> *log in/sign up* -> *Add +* 

### Reminders
**Functionality**: The user can use the reminders functionality to be reminded to pay bills, to add in transactions or for any other financial reminders. The user will be notified 1 day(24 hours) before the due date of the reminder.<br>
**Navigation**:  Landing Page -> *log in/sign up* -> *Reminders* 
**OR** Landing Page -> *log in/sign up* -> click hamburger menu -> *Reminders*

### Investment insights
**Functionality**: The user can see the real time stock prices. The user can also add the stocks for companies that are not present in the default list.<br>
**Navigation**: Landing Page -> *log in/sign up* -> click hamburger menu -> *Investment Insights*

### Budget goals
**Functionality**: The user can set their saving or any other finance related goals by entering their title, description, anount and deadline date. After completing the goal, user can mark it as completed or can delete the budget goal. <br>
**Navigation**: Landing Page -> *log in/sign up* -> click hamburger menu -> *Budget Goals*

#### Settings
**Functionality**: The settings page is where the user can find information about the data & privacy policies, help and support, or can logout of the app.<br>
**Navigation**:  Landing Page -> *log in/sign up* -> *Settings* **OR** Landing Page -> *log in/sign up* -> click hamburger menu -> *Settings*

## Contribution of Each Member
#### Jahanvi Mathukia: 
Worked on integrating the whole transaction page with firebase from sending all the data from add transaction page to firebase and fetching it back to fill up the UI on tarnsaction page. Worked on the integrating the required data from firebase to create donut chart for expenses and design of that page. Created required structure for firebase and SQLIte database. Documented and formatted the code.

#### Aanisha Newaz: 
Worked on designing the user interface of the following pages: Financial Insights, Reminders, Budget goals. Worked on functionalities: Snackbar implementations, file sharing functionality, data visualizing using graphs, multiple pages/navigations, dialogs and pickers to create new reminders, goals, and add new transactions.

#### Jessica Patel: 
Worked on the user interface of the MoneyMinder application, more specifically worked on the following pages: Landing Page, Sign-In, Sign up, Home(transactions), Add transactions, Reminders, Settings, About, Privacy and security, Help & Support. Worked on functionalities: Notifications, custom navigation (app header and footer), multiple screen navigation, dialogs, and pickers for different pages.

#### Mansi Patel: 
- Main Focus on the backend side integrating UI with Firebase and/or SQLite
- End to end implementation of signup and login from UI to firebase
- End to end implementation of budget-goals and reminders from UI to SQLite
- Setup the Firebase and SQLite DB structure for the project.  

#### Ethan Randle-Bragg: 

Language:
Using your systems current default language the app will launch with that language and all widgets and text will be translated

Stock: The investment insights page uses IEX cloud API to get the most accurate stock data for the day as well as display its current price and daily change whether that be positive or negative %
We also have a + button in the bottom right that allows for a user to add a new stock and the listview will automatically update with this new stock and price
there is also a search bar at the top that you can use to search any stock by either is 4 letter symbol or company name
An example stock to add in the Alert dialog when you click that add floating action button is COST for costco. Additionally the Stock API only lasts 7 days so if the project is marked after that date you will need to replace   final apiKey = 'sk_bf99b81898b649bb84952d702e939384'; in investment_insight.dart line 49 with sk_0310f693e25a492aab102ef5231fe40b if that doesn't work you will need to sign up for IEX cloud here at https://iexcloud.io/

## How to run:
- git pull
- in your terminal, cd money_minder
- flutter pub get 
- flutter run

## YouTube Link
- Mansi Patel - [Walkthrough](https://www.youtube.com/watch?v=Svr-eegoS7E)
- Ethan Randle-Bragg https://youtu.be/8qyC-UONRuA
