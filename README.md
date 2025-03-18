# ABAP Changelog project
[Quick presentation :)](https://youtu.be/z3L1WhiMtHA)

# Documentation
## Purpose
Main goal of this project was to challenge myself and create a changelog function usable by user without access to any other transaction codes (as se16n or other DDIC tables).
To do so, a simple program allowing user to manager customer's data was created. Changelog is showing changes made by user while managing customer's data via this program.


## Requirments
Program was developed on on-premise [SAP ABAP AS 7.52 SP04](https://developers.sap.com/trials-downloads.html?search=7.52) system only because part of the challenge was to show GUI without touching FIORI tech, focusing only on ABAP practice. Server was installed and launched with help of [this tutorial](https://abapacademy.com/blog/how-to-install-free-sap-system/) and a [fix](https://community.sap.com/t5/technology-blogs-by-members/adjusting-installer-script-for-sap-netweaver-dev-edition-for-distros-with/ba-p/13492318).
IDEs used for development: SAP Logon and Eclipse ADT. 


## Installing
To download, launch and test this program please use [abapgit](https://docs.abapgit.org/) in SAP Logon (abapgit in Eclipse is supporting only CLoud systems, so our on-premise version code was transported to github via se38 report). 


## Structure
Program is allowing user to create/search/modify/delete costumers on DDIC table ZCUST_DETAILS. During these functions user's input is checked/validated.
Every time when one of mentioned CRUD operation is performed, a new entry is added to ZCUST_CHANGELOG table. Every DDIC data element and domain has been created from scratch.
If user wants to check changes made by other users, changelog function is visible under one of GUI buttons. 
GUI is represented by combination of two dynpro screens:
- first representing main menu of the program with most of i/o fields, labels, one ALV grid,
- second available as an pop-out (modal dialog box), containing two options (one closing pop-out and returning to main window, second allowing to search for entries by customer's ID) and ALV report to display search result.
Most od data declaration and objects initialization/creation has been deployed in PBOs of used dynpros, most of options and CRUD logic implemented in PAIs.
All the errors/confirmation messages are handled by single message class.


## Functions
### Main screen:
![image](https://github.com/user-attachments/assets/afe79224-f11d-4b24-8946-8b57889ffc67)

- Clear - for clearing fields of mandatory data
- Create - creating new customers based on 3 mandatory data: first and last name + email,
- Search - searching for customers, possible to search through entire table when not providing any mandatory details (at this stage*),
- Update basic details - update customer's mandatory data,
- Delete - removing customers from ZCUST_DETAILS (upon removing, customer's ID is removed from the table and stored in ZCUST_ID_STORAGE table**),
- Show/hide address details - to show/hide fields and labels of address details(this is implemented mostly because I assume that not every modification will be about address data):

![image](https://github.com/user-attachments/assets/d27d466a-cc47-450a-a866-e83334024cb8)

Example of search:

![image](https://github.com/user-attachments/assets/4b35e064-2e7d-4ea0-a2fb-9e364ea87a97)


Please note, that ALV above, showing search results, has hotspot event implemented for ID column only.

- Update address details - to update address details.
### Pop-out (changelog) screen:
![image](https://github.com/user-attachments/assets/0c939758-6b39-4aef-ab26-b1734abd4ac0)


- Back - to simply allow user to go back to main screen,
- Search - to allow searching by customer's ID***.

Important notes:
- "*" At this stage I wanted to allow user to search the entire table in first window. By default, once shipped to production system, it would be blocked (at least one mandatory data would be a must).
- "**" This approach was quite the opposite of the approach from *. Program was inspired and designed to work on a table of around 30k customers. That is why I decided to not leave empty customer_IDs in the table, but to put them in another table. During creation of new customer I wanted to avoid asking main table for a number, but to work on another 'storage' one.
- "***" Because the project was developed on on-premise system with only one user, all entries are assigned to the same user. In production environment, search option could be enchanced by searching not only with customer_ID, but also with username(sy-uname).









