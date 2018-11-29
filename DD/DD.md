# Design Document

## 2. Overall Architecture

#### Description

Depending on the functionality the system software should rely on different types of architecture, traditional requests are served via a Client-Server paradigm implementation while the most active operations are performed following the Publisher-Subscriber paradigm.

The system should be structured as follows:  
Internally it relies on a router node, a Database Management System and a dispatcher node.  
The router node has the task to receive data from the registered users both sending it to the DBMS and notifying the dispatcher of the availability of new data, along with checking if such data respect any possible constraints of the AutomatedSOSUser could have set, alerting the dispatcher node on need.
    
 Upon new data arrival the dispatcher has the task to check if any of it matches filters of subscribed third parties and in such case proceeds to forward said data to the specific Third Party, it also has to handle Third Parties subscription requests, single filters request and emergency notifications, to achieve these tasks it is linked directly with the DBMS and is always listening on a dedicated socket with the router node, for mapping and localization purposes both User's client and the TrackMe system communicate with external cloud services.
    
    
<img src="./ArchitectureDiagrams/Architecture.JPG"/>
