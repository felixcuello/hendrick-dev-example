# README

This application is a sample Ruby on Rails app to understand development styles and thought processes.  You should **fork this repository** to your personal github account and make the repository public so that your work can be reviewed.  Do NOT make pull requests against the original repository.

## Scenario
This Rails application servers as an API endpoint into an organization. Business partners or other systems post data to this endpoint throughout the day via blobs/create.  The API generates a unique file for every inbound file that it receives.  It places these files in /received_files where some other application may do something with the file.

Both redis and postgresql gems are included, however the current function of the API doesn't make use of either data stores as it simply receives JSON and stores the data.

The api has basic authentication enabled so that only known or approved systems can post files to the API.

All inbound files to this API are less than 100MB in size.

## Challenge 1
The business unit that is sending the bank transactions file now needs the file manipulated before it is sent on for further processing.  We still want to keep the one original file on the webserver so that there is an immutable copy, however we need make an edit to a file once it is received through the API.  This will result in there being two files in the /received_files folder, the original that we were always receiving and the new edited version.

The business unit has asked that transactions with descriptions that contain "mechanincal business transoformation GCP" have an 'in/out' line added to the transaction file.

You will need to find those transactions and ADD two lines to the transacation file.  One line will have a description of "consolidated mechanical business transformation GCP" with a transaction value equal to the sum of the matching transactions.  A second transaction line will offset that transaction and be labled "offset consolidated mechanical business transformation GCP" and will be the negative sum of the matching transactions.

The total at the bottom of the file should still sum to the original totals so you can validate your consolidation math.

You can find a sample of the desired outcome in the /docs folder as well as a sample of the original file.

## Challenge 2
A business unit wants to know information about inbound file and possibly retrieve those files via this API application.  

You need to add a way of logging inbound files to the API.  A downstream application must be able to make a JSON request that lists the files and provides a way for the downstream application to retrieve the files.  The downstream application is capable of decodeing file data as long as you indicate what it may be encoded in.

Create a way of recording the JSON data in the API application so that it can be retreived by having a system access the record in typical rails CRUD format.  For instance a system should be able to go to /blobs/{id} and return the record for that JSON document.  Similarly, a downstream application should be able to go to /blobs and retrieve a listing of files.

The API should continue to be fast and simple as it is just a way of receiving or providing access to information.
