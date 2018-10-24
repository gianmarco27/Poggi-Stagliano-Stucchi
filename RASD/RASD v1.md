# RASD

## Introduction

////TODO

## Goals: Data4Help

* [G1]  The user must be able to register on the platform as an individual or third party.

* [G2]  The individual has to be monitored constantly.

* [G3]  The user can access his/her data anytime anywhere.

* [G4]  Third party users must be able to access both individual's and group's data safely.

  [Requirement related]  If there are at least 1000 users belonging to the selected category the system provides the data.
  
  [Requirement related]  If the Individual grants the access to his data to a specific request of a third party, the system allows the third party to obtain said user data.

* [G5]  Third party users can subscribe to groups of data to be updated as soon as new data are available.

## Goals: AutomatedSOS

* [G6] The individual is assured that when his/her data fall below certain selected thresholds, his/her local emergency service is notified.

 [Requirement related]  The user can specify his own parameters and thresholds to be monitored into the application.

 [Requirement related]  The application constantly monitors the individual data.

 [Requirement related]  The application guarantees within 5 seconds to detect the emergency.


## Goals: Track4Run
        to use this service a user first must own a data4help account

* [G8]  Users can register as organizers.

* [G9]  Organizers can create a run specifying its path.

* [G10]  Participants can enroll to a run through their Data4Help account.

* [G11]  Any user can access Track4Run as a Guest (Spectator).

* [G12]  Spectators can visualize the location of each participant to a selected run.


## Domain Assumptions: Data4Help

* [D1]  Monitoring devices are always connected to the network.

* [D2]  Monitoring devices are provided with an accurate enough GPS.

* [D3]  Monitoring devices are capable of monitoring accurately Health parameters like: blood pressure, BPM, body temperature, steps, sleep quality, etc...

* [D4]  All individuals registered to Data4Help own a device capable of measuring all the parameteres required by the service application domain.

* [D5]  All third parties posses a unique Identifier.

## Domain Assumptions: AutomatedSOS

* [D6]  The users' local emergency services offer APIs to communicate emergencies.

* [D7]  The users' local emergency services are always available to receive emergency aid requests.

* [D8]  The user knows the parameters he needs to have monitored and the thresholds of those parameters.


## Domain Assumptions: Track4Run

* [D9]  Track4Run is to organize No-Profit run so the system doesn't support payments.

* [D10]  Track4Run Users that enroll a run also own a Data4Help account.

* [D11]  Guest users can access Track4Run data on a specific run without any credential.

* [D12]  Users participating to a run must have their monitoring device equipped during the run.

## Functional Requirements: Data4Help

#### [G1] - The user must be able to register on the platform as an individual or third party.

* [D5]  All third parties posses a unique Identifier.

* [R1]  Users can register to the platform through his/her SSN and password.

* [R2]  The application has to allow the registering user to sign up as an individual or as a third party.


#### [G2] - The individual has to be monitored constantly.

* [D1]  Monitoring devices are always connected to the network.

* [D2]  Monitoring devices are provided with an accurate enough GPS.

* [D3]  Monitoring devices are capable of monitoring accurately Health parameters like: blood pressure, BPM, body temperature, steps, sleep quality, etc...

* [D4]  All individuals registered to Data4Help own a device capable of measuring all the parameteres required by the service application domain.

* [R3]  The application has to keep a log of each data registered by the monitoring devices.
  

#### [G3] - The user can access his/her data anytime anywhere.

* [R4]  The application allows the user to select certain periods of time from which retrieve his/her data.  


#### [G4] - Third party users must be able to access both individual's and group's data safely.

* [R5]  The System has to allow third party users to filter data on request.
    - [R5.1]  Third party users can specify filters by the creation of categories to which the data previously collected belong.
    
            [R7]  Organizers can register via Organizers Identifier and password
            requirement for track for run.
