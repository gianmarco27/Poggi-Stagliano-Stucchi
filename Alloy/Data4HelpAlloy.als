open util/boolean
open util/integer
open util/string

sig Identifier{}

//fact: un gruppo di dati appartiene solo a un individuo.
abstract sig Data{}

//Inserire values in UML class diagram.
sig MonitoredData extends Data{
	values: set Integer;
}

sig MandatoryField extends Data{

}

//fact: SSN e id devono coincidere
sig PersonalData extends Data{
 	SSN: one Identifier;
	mandatoryFields: 5 MandatoryField;  //Sex, age, height, weight, home address.
}

//fact: un id è relativo a un solo user.
abstract sig User {
	id: one Identifier;
}

sig Individual extends User{
	bio: one PersonalData;
	tracking: set MonitoredData;
}

sig ThirdParty extends User{
	categories: some Filter;
}
//eliminare attributo mandatoryFields da PersonalData
sig Filter{
	subscribed: one Bool;
	uses: some MandatoryField;
	//se utilizziamo set ricordare di inserire molteplicità 0 nella relazione tra filtri e monitored data. Lasciare uguale se si utilizza some.
	returns: set MonitoredData;
}

// --- AutomatedSOS ---

sig AutomatedSOSUser extends Individual{

	constrainst: some MonitoringConstraint;

}

//UML class diagram: modificare MonitoringConstraint con i due attributi.
sig MonitoringConstraint {
	upperBound: lone Int;
	lowerBound: lone Int;
}

sig Emergency{
	violatedConstraint: one MonitoringConstraint;
	user: one AutomatedSOSUser;
}

// --- Track4Run ---

sig Runner extends Individual{

	subs: some Subscription;

}

sig Subscription {

	subscriptionTime: one Timestamp;
	runEnrolled: one Run;

}

sig Timestamp{

	minute: one Int;
}

sig Run {
	
	title: one String;
	startTime: one Timestamp;
	runners: some Runner;

}








