# This is our project prototype


HOW TO RUN OUR CODE:
Once you clone our project proposal you will need to then cd navigate to the project_prototype folder and run a pub get in your command line. Then it is as simple as flutter run.  You will be presented with the login screen and by pressing sign in you can navigate to our other pages.
WARNING:
Both SQLite and fire base code is commented out in main.dart but it is working. Refer to requirements below more information and proof of images that the function
is working.
## Requirements
Max Score	Requirement	Description / Criteria
### 2.00	Multiple screens/navigation	 - Jessica and Aanisha
MoneyMinder has multiple screens that serve different purposes:
- Landing page for user to sign in or sign up
- Sign up page
- Sign in page
- Main page, where the user can see an overview of their current networth, as well as their recent expenses (partially implemented)
- Insights page, where the user can track their spending habits and follow their investments (partially implemented)
- Reminders page, where the user can set reminders for different financial tasks
- Settings page (not implemented)
#### 1.00: At least two different screens implemented.

![landingpage](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90078094/f385bffd-cff2-41f7-8589-5e6763b70e8f)
![login](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90078094/35012bad-3470-4adf-9e1f-5f8262ddc374)
![reminders](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90078094/684168be-fa3e-4dc0-b255-55e2e9f20e92)

#### 1.00: Seamless navigation between screens with no crashes or glitches.
The user can switch between the Main overview, insights, reminders, and settings tabs efficiently without any glitches.

### 2.00	Dialogs and pickers	- Aanisha
#### 1.00: At least one dialog or picker is present.

![date-dialog](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90078094/a28edb5d-90ba-482a-8a07-c57810418948)

#### 1.00: Dialog or picker serves a functional purpose and enhances user experience.
We have successfully integrated a dialog/picker function into our application. This allows the user to pick the date and time in which their task is due in the reminders tab. The date and time will be stored into a variable/database to send notifications to the user's device when their task's due date is coming up soon.

![date-dialogue-code](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90078094/26de6da1-1177-4ae9-8f90-9c49473f0a19)

### 1.00	Notifications	
#### 0.50: Notifications are implemented.

#### 0.50: Notifications are contextually appropriate and don’t spam the user.

### 1.00	Snackbars	- Aanisha
#### 0.50: Snackbar integration in the application.
We have successfully integrated a snackbar function into our application. The snackbar notifies the user once they have set a new task reminder or if they have completed a task.

![snackbar code](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90078094/bf99f941-f2ba-41d6-af66-131c06cf3f7e)

#### 0.50: Snackbars convey meaningful information or feedback to the user.
![snackbar](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90078094/48f27013-e519-4c3c-91c0-94028f1133f2)

### 2.00	Local storage	- Jahanvi and Mansi
#### 1.00: Data is saved and accessed using SQLite (or equivalent).
We have successfully integrated SQLite into our application. SqLite serves as our local storage solution, allowing us to store, manage, and retrieve data efficiently.

#### 1.00: Data integrity is maintained, and there are no issues/crashes related to storage.
Our application demonstrates efficient local data retrieval and storage with minimal delays. When data is stored in SQLite, it is readily available for retrieval and can be accessed within milliseconds.
We have verified the efficiency of our data retrieval process by printing retrieved data on the console, confirming that data retrieval occurs promptly without causing any significant performance issues or delays in our application.

Here are the screenshots of data retrieval:

![localdb_ss1](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90158170/edd3d5d5-518e-40ba-98b5-dd465070e382)

![localdb_ss2](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90158170/555bb229-6c8c-43b9-9d19-a35fde090039)


### 2.00	Cloud storage	- Jahanvi and Mansi
#### 1.00: Cloud storage (e.g., Firestore) integration.
We have successfully integrated Firebase Firestore into our application. Firestore serves as our cloud storage solution, allowing us to store, manage, and retrieve data efficiently.

#### 1.00: Cloud data retrieval and storage are efficient with minimal delays.
Our application demonstrates efficient cloud data retrieval and storage with minimal delays. When data is stored in Firestore, it is readily available for retrieval and can be accessed within milliseconds.
We have verified the efficiency of our data retrieval process by printing retrieved data on the console, confirming that data retrieval occurs promptly without causing any significant performance issues or delays in our application.

Here are the screenshots of data retrieval:
<img width="1077" alt="Screenshot 2023-11-12 114631" src="https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90855128/d809f17f-39b7-4b8f-a03b-e76eb03f1495">

<img width="904" alt="Screenshot 2023-11-12 114701" src="https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/90855128/1d5fcc11-9e21-40b6-abe0-23faa4ec71eb">


### 2.00	HTTP Requests
#### 1.00: HTTP requests are made within the app.
A brief summary of the HTTP requests is that we are using a free public API called IEX cloud that allows you to get real time stock data and have it be parsed to your code and updated. So theoretically if you launched our app during the week at different times of day the app would display the correct live prices.

Snippet of code for HTTP requests
![image](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/61356946/d6d123a7-3732-4837-a0c4-c87c39b24f53)
The starting stock page
![stockHome](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/61356946/9e0dda68-334d-4423-aa03-e7cf7f055c2e)
Adding a new stock
![stockAdd](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/61356946/e803ccdc-5c85-4e0c-9e2d-83145e811c20)

![stockUpdated](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/61356946/c8cfbeb6-e879-409e-9e33-7be4eb15dd62)

![stockRed](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/61356946/7398bfd6-ccfb-40ca-b639-925e99ca40d7)

![image](https://github.com/CSCI4100U/mobile-group-project-2023-mjja/assets/61356946/91616dfe-93e5-4df9-837f-f62a821839f4)
The updated list
If a stock is down for the day the text is red 
If you type a stock symbol that does not exist this error is printed to the console but the app does not crash
#### 1.00: Proper error handling and data parsing are observed.
