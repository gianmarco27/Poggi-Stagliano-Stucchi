# RASD

## Introduction

////TODO

## Goals: Data4Help

[G1]  The Application must allow the user to register on the platform as an individual or third party

[G2]  The Application allows the individual to be monitored constantly

[G3]  The System allows the user to access his/her data anytime anywhere

[G4]  The System has to allow third party users to select categories of data based on his/her categorization preferencies

[G5]  The System allows third party users to access users' data safely

  [Requirement related]  If there are at least 1000 users belonging to the selected category the system provides the data
  
  [Requirement related]  If the Individual grants the access to his data to a specific request of a third party, the system allows the third party to obtain said user data

[G6]  The System sends new data to the subscribed third party as soon as they are available


## Goals: AutomatedSOS

[G7]  The System notifies the users's local emergency service when the user's data fall below certain selected thresholds

[Domain Assumption related]  The user knows the parameters he needs to have monitored and the thresholds of those parameters

[Requirement related]  The user can specify his own parameters and thresholds to be monitored into the application

[Requirement related]  The application constantly monitors the individual data

[Requirement related]  The application guarantees within 5 seconds to detect the emergency


## Goals: Track4Run
        to use this service a user first must own a data4help account

[G8]  The System allows new users to register as organizers

[G9]  Organizers can create a run specifying its path

[G10]  The System allows participants to enroll to a run through his/her Data4Help account

[G11]  Any user can access Track4Run as a Guest (Spectator)

[G12]  Spectators can visualize the location of each participant to a selected run


## Domain Assumptions: Data4Help

[D1]  User registers to the service through his SSN and a password

[D2]  Monitoring devices are always connected to the network

[D3]  Monitoring devices are provided with an accurate enough GPS 

[D4]  Monitoring devices are capable of monitoring accurately Health parameters like: blood pressure, BPM, body temperature, steps, sleep quality, etc...

[D5]  All individuals registered to Data4Help own a device capable of measuring all the parameteres required by the service application domain

## Domain Assumptions: AutomatedSOS

[D6]  The users' local emergency services offer APIs to communicate emergencies

[D7]  The users' local emergency services are always available to receive emergency aid requests


## Domain Assumptions: Track4Run

[D8]  Organizers can register via Organizers Identifier and password

[D9]  Track4Run is to organize No-Profit run so the system doesn't support payments

[D10]  Track4Run Users that enroll a run also own a Data4Help account

[D11]  Guest users can access Track4Run data on a specific run without any credential

[D12]  Users participating to a run must have their monitoring device equipped during the run