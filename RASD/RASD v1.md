# RASD


## Introduction

////TODO


## Goals: Data4Help

* [G1]  The user must be able to register on the platform as an individual or third party.

* [G2]  The individual has to be monitored constantly.

* [G3]  Third party users must be able to access both individual's and group's data safely.

* [G4]  Third party users can subscribe to groups of data to be updated as soon as new data are available.


## Goals: AutomatedSOS

* [G5] The individual is assured that when his/her data fall below certain selected thresholds, his/her local emergency service is notified.


## Goals: Track4Run

* [G6]  Users can register as organizers.

* [G7]  Organizers can create runs.

* [G8]  Any user can access Track4Run as a Guest (Spectator).

* [G9]  Users can enroll to a run.

* [G10]  Spectators can follow the progress of a run.


## Domain Assumptions: Data4Help

* [D1]  Monitoring devices are always connected to the network.

* [D2]  Monitoring devices are provided with an accurate enough GPS.

* [D3]  Monitoring devices are capable of monitoring accurately Health parameters like: blood pressure, BPM, body temperature, steps, sleep quality, etc...

* [D4]  All individuals registered to Data4Help own a device capable of measuring all the parameteres required by the service application domain.

* [D5]  All third parties are capable of elaborate requests according to the types of data collected by the system.

* [D6]  Third party users are always available to receive data.

* [D7]  Third parties know the SSN of the individuals of interest.

* [D8]  Registering users must have accepted the service GDPR.

## Domain Assumptions: AutomatedSOS

* [D8]  The users' local emergency services offer APIs to communicate emergencies.

* [D9]  The users' local emergency services are always available to receive emergency aid requests.

* [D10]  The user knows the parameters he needs to have monitored and the thresholds of those parameters.


## Domain Assumptions: Track4Run

* [D11]  Track4Run is to organize No-Profit run so the system doesn't support payments.

* [D12]  Track4Run users that enroll a run also own a Data4Help account.

* [D13]  Users participating to a run must have their monitoring device equipped during the run.

* [D14]  Track4Run organizers cannot be Data4Help individuals.

* [D15]  Paths specified in runs must be feasible paths, not including obstacles of any genre.


## Functional Requirements: Data4Help
 
 ?requirements da punto di vista funzionalità utente e non da punto di vista del sistema?
#### [G1] - The user must be able to register on the platform as an individual or third party.

* [R1]  Users can register to the platform through his/her SSN and password.

* [R2]  The application has to allow the registering user to sign up as an individual or as a third party.


#### [G2] - The individual has to be monitored constantly.

* [D1]  Monitoring devices are always connected to the network.

* [D2]  Monitoring devices are provided with an accurate enough GPS.

* [D3]  Monitoring devices are capable of monitoring accurately Health parameters like: blood pressure, BPM, body temperature, steps, sleep quality, etc...

* [D4]  All individuals registered to Data4Help own a device capable of measuring all the parameteres required by the service application domain.

* [R3]  The application has to keep a log of each data registered by the monitoring devices.
  
  
#### [G3] - Third party users must be able to access both individual's and group's data safely.

* [D5]  All third parties are capable of elaborate requests according to the types of data collected by the system.

* [D7]  Third parties know the SSN of the individuals of interest.

* [R1]  Users can register to the platform through his/her SSN and password.

* [R5]  The System has to allow third party users to filter data on request.
    - [R5.1]  Third party users can specify filters by the creation of categories to which the data previously collected belong.
    
* [R6]  The System provides the requested only if there are at least 1000 users belonging to the selcted filter.

* [R7]  The System allows the third party to obtain a specific individual data only if he/she grants the acces to them.
   
   
#### [G4] - Third party users can choose to be notified about previous researches to be updated as soon as new data are available.

* [D6]  Third party users are always available to receive data.

* [R8]  The System keeps track of the last update sent to the third party.

* [R9]  The System periodically checks if new data belonging to the subscribed filter are available and sends a proper update.

* [R10]  The System periodically checks if new data belonging to the subscribed filter are available and sends a proper update.


#### [G5] - The individual is assured that when his/her data fall below certain selected thresholds, his/her local emergency service is notified.

* [D8]  The users' local emergency services offer APIs to communicate emergencies.

* [D9]  The users' local emergency services are always available to receive emergency aid requests.

* [D10]  The user knows the parameters he needs to have monitored and the thresholds of those parameters.

* [R11]  The user can specify his/her own parameters and thresholds to be monitored into the application.

* [R12]  The application monitors periodically the individual data with respect to the previously specified parameters.

* [R13]  The application notifies the user's local emergency services when his parameters fall below specified thresholds.


#### [G6] - Users can register as organizers.

* [D14]  Track4Run organizers cannot be Data4Help individuals.

* [R14]  On first login users can provide their VAT number to obtain access to the system as organizers of runs.


#### [G7] - Organizers can create runs.

* [D15]  Paths specified in runs must be feasible paths, not including obstacles of any genre.

* [R15]  Organizers can specify the path, the title, the date, the start time and a brief description of the run they are creating.


#### [G8]  Any user can access Track4Run as a Guest (Spectator).

* [R16]  Guest users can access Track4Run data on a specific run without any credential.

* [R17]  Users can visualize title, description, date, start time and path of available runs.


#### [G9] - Users can enroll to a run.

* [D12]  Track4Run users that enroll a run also own a Data4Help account.

* [R17]  Users can visualize title, description, date, start time and path of available runs.

* [R18]  Users can subscribe to a selected run using his/her Data4Help account.


#### [G10] - Spectators can follow the progress of an ongoing run.

* [D12]  Track4Run users that enroll a run also own a Data4Help account.

* [D13]  Users participating to a run must have their monitoring device equipped during the run.

* [R17]  Users can visualize title, description, date, start time and path of available runs.

* [R18]  Spectator can visualize the location of each participant to a selected run.


## Scenarios

#### Scenario 1


