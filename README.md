# Abap Changelog project

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








