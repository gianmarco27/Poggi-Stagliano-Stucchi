# Design Document

## 2. Overall Architecture

### 2.1 Overview

Depending on the functionality the system software should rely on different types of architecture, traditional requests are served via a Client-Server paradigm implementation while the most active operations are performed following the Publisher-Subscriber paradigm.

The system should be structured as follows:  
A server node and a Database Management System.  
The server node has the task to receive data from the registered users both sending it to the DBMS and elaborating it, along with checking if such data respect any possible constraints of the AutomatedSOSUser could have set, alerting the Emergency Service on need.
Upon new data arrival the server has the task to check if any of it matches filters of subscribed third parties and in such case proceeds to forward said data to the specific Third Party, it also has to handle Third Parties subscription requests, single filters request and emergency notifications, to achieve these tasks it is linked directly with the DBMS, for mapping and localization purposes both User's client and the TrackMe system communicate with external cloud services.
    
    
<img src="./ArchitectureDiagrams/Architecture.JPG"/>

### 2.2 High Level Architecture and deployment

Below are described via a High Level Architechture graph the main components of our system and their main processes.  
The main core of our system is rapresented by the Router and Dispatcher processes in the TrackMe System, toghether with the DBMS that is accessed by them to read and store collected data.

The different Users of the services are provided with different Point Of Access depending on their needs, respectively implemented on different platforms like web browser for Organizers and Third Parties and mobile application for the data providing User.

<img src="./ArchitectureDiagrams/HighLevelArchitecture.png"/>

### 2.3 Component View

In the following diagram we have depicted more accurately the services, the links between them and how they are interfaced with each other. Notice the DBMS interface is generalized because it depends on the choiche of the DBMS technology and in order to mantain things more general we didn't want to rule out any option.  
As for DBMS here the External Services are not specifically charachterized to allow a consequent choiche of the most appropriate service basing on the needs of the application.  

<img src="./ArchitectureDiagrams/ComponentVIew.JPG"/>


- **LoginService** - Provides authentication and registration services including eventual parameters setting depending on the type of user (i.e. The insertion of AutomatedSOSUser's monitoring constraints are handled here).
- **DataCollectionService** - It is responsible for collecting and persistently storing in the Database the data received by the clients and sends them to: DataMonitoringService and SubscriptionService.
- **DataMonitoringService** - Receives data from the DataCollectionService and performs controls based on users imposed constraints previously stored in the DBMS.
- **SubscriptionService** - This service is responsible for managing subscriptions both receiving and storing them into the Database, it also receives real time data from DataCollectionService, if such data belong to subscribed topics it proceeds to forward those data to the PrivatizationService and successively to the DispatchingService (or directly to it in case of specific user data request).
- **FilteringService** - Receives one-time data requests from Third Parties and queries the Database for the results to return to the DispatchingService, it is also responsible of forwarding eventual requests on specified topics to the PrivatizationService before forwarding it to the responsible service.
- **PrivatizationService** - Receives data anonymization requests from other services and after processing user data returning the result to the caller.
- **DispatchingService** - Is responsible of forwarding Data matching subscriptions and filtering requests to Third Parties.
- **RoutingService** - This services takes care of handling various types of request received from users forwarding each of them to the appropriate service.
- **RunManagementService** - Is responsible for Subscription, Insertion and Spectating requests for the Track4Run Service.

We assume that the routing functionality is responsible of forwarding messages to the directly interested services depending on the client that has performed the request. 


The diagram below describes the data model of the entire application, more specifically the data rapresentation in memory used by software components to achieve their objective.  
The dispatching functionality implemented by the dispatching service is built on top of the architecture described below:

<img src="./ArchitectureDiagrams/MessageQueueing.JPG"/>


Data management is operated by most of the services previously listed in their implementation such as FilteringService, SubscriptionService and PrivatizationService.  
The architecture is supposed to resemble the publish/subscribe paradigm, in order to achieve this type of communication, the data model includes information to reach the subscribed client everytime an appropriate update about the subscribed topic is performed.  
Information about where to send the subscription updates are collected upon registration from the Third Party.


Subscriptions are stored into the Database, on first boot the system loads in an appropriate data structure the tuples stored, extracting from the relational database couples of subscription topic and subscriber, thus strongly reducing the response time on each update to be performed.

<img src="./ArchitectureDiagrams/UMLClassDiagram.JPG"/>


<img src="./ArchitectureDiagrams/InterfaceImplementation.JPG"/>

## 2.4 Runtime View

### 2.4.1 Data4Help

#### Filtering Request

<img src="./ArchitectureDiagrams/FilteringRequestSequenceDiagram.JPG"/>

#### New Data Collection

<img src="./ArchitectureDiagrams/NewDataCollectionSequenceDiagram.JPG"/>

        remember to describe the motivation why whe use async messages
#### Emergency Notification

<img src="./ArchitectureDiagrams/NotifyEmergency.JPG"/>

#### Run Enrollment

<img src="./ArchitectureDiagrams/runEnrollment.JPG"/>

## 2.5 Component Intefaces

The aim of the following diagram is to highlight the relationships between services implemented on the server of the entire system, in particular the interfaces exposing their public methods and the use relation between them.

<img src="./ArchitectureDiagrams/ComponentInterfaces.JPG"/>

## 2.6 Selected architectural styles and patterns

The main architectural style adopted, on which the communication with third party relies, is the Publisher/Subscriber paradigm.  
It has been adopted to be able to manage the inherent transient nature of communication and asynchronicity of the services offered by the system. At the opposite the classical client-server architectural style doesn't fit with the purpose of queueing and dispatching of messages, as it would have made necessary establishing a new connection everytime the system had to send new data.  
This type of paradigm is used anyway on a different level in order to handle users' interactions via the provided interfaces, as for registration, run enrollment and other operations that can be performed in a single connection instance.


<img width=150/><img src="./ArchitectureDiagrams/SubscribingClients.JPG" width=600/>


As described in the picture above, a part of the Database is devoted to store topics and subsricptions of Third Parties along with the pure application data.  
Upon receiving a new data the system performs a check on the subrsciptions and relative topics and eventually dispatches, after an optional further elaboration of the data operated by internal services, new information to the interested Third Parties.

The basical structure relies on a message queueing middleware (implemented by JMQS in our choiche) that ensures message ordering at receiver side and also recovery on message loss.

<img src="./ArchitectureDiagrams/JMQSspecific.JPG"/>

The address lookup database figured above, is stored in the system along with other data as described in the **<a href="#23-component-view">Component View Class Diagram</a>** : each record contains the EndPoint reference (Transport Level Address [IP, Port]) of the receivers of the service.

The system is designed to allow future scalability improvements on need i.e. by means of a routing application layer on top of which could be applied the current implementation to improve the delivery time by the usage of a routing algorithm and spreading the communication overhead on different nodes.


Notice that in order to model the server-side data context we adopted an objective memory representation, performing a one to one mapping with the relational model of the Database to obtain a faster access intermediate representation of the queried data, making them available to processes for elaboration.  
This type of rapresentation could be compared with the model part of the MVC pattern.

Regarding the client level the Individual user is provided with an application deployed on his mobile, interfacing with his activity monitoring device APIs that takes care both of allowing the user to interact with the services offered by the server and to communicate monitored data to the appropriate service.  
Third Parties for the Data4Help service and Organizers for Track4Run are provided with a web portal through which they can perform active interactions with the server such as sending Filtering Requests or creating a new Run for the Users, while passive interactions such as data-sending regarding subscriptions to certain topics are perfomed on a different channel, on the IP and port provided at the moment of registration and stored in the Database.