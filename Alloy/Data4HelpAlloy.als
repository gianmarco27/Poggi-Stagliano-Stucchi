open util/boolean
open util/integer


sig Identifier{}

//fact: un gruppo di dati appartiene solo a un individuo.
abstract sig Data{}

sig MonitoredData extends Data{
	values: set Int 
}

sig MandatoryField extends Data{

}

//fact: SSN e id devono coincidere
sig PersonalData extends Data{
 	SSN: one Identifier,
	mandatoryFields: some MandatoryField, //Sex, age, height, weight, home address...
}

//fact: un id è relativo a un solo user.
abstract sig User {
	id: one Identifier,
}

sig Individual extends User{
	bio: one PersonalData,
	tracking: set MonitoredData
}

sig ThirdParty extends User{
	categories: some Filter
}

sig Filter{
	subscribed: one Bool,
	uses: some MandatoryField,
	returns: set MonitoredData
}

// --- AutomatedSOS ---

sig AutomatedSOSUser extends Individual{

	constrainst: some MonitoringConstraint,

}

sig MonitoringConstraint {
	upperBound: lone Int,
	lowerBound: lone Int
}

sig Emergency{
	violatedConstraint: one MonitoringConstraint,
	user: one AutomatedSOSUser,
}

// --- Track4Run ---

sig Runner extends Individual{

	subs: some Subscription,

}

sig Subscription {

	subscriptionTime: one Timestamp,
	runEnrolled: one Run,

}

sig Timestamp{
	prevs: set Timestamp,
	nexts: set Timestamp,
}

sig RunTitle { }
sig Run {
	title: one RunTilte,
	startTime: one Timestamp,
	runners: some Runner
}

// le relazioni tra timestamp valgono anche all'inverso
fact  TimeFlowConnection {all disj t1, t2: Timestamp |  (t2 in t1.nexts implies t1 in t2.prevs) and ( t1 in t2.prevs implies t2 in t1.nexts)}

//nessun timestamp è in relazione con se stesso
fact NoTimestampIsBeforeOrAfterItself {no t1 : Timestamp | ((t1 in t1.nexts) or (t1 in t1.prevs))}

// nessun timestamp è fuori dalla linea temporale (sono tutti in relazione)
fact TimeIsAllOrdered {no disj t1, t2 : Timestamp | ((t2 not in t1.nexts) and (t2 not in t1.prevs))}

//nessun timestamp è sia prima che dopo
fact BeforeIsAnExclusiveRelation {no disj t1, t2 : Timestamp | ((t2 in t1.nexts) and (t2 in t1.prevs))}

// i timestamp sono in ordine sequenziale e vale la proprietà transitiva
fact TimeIsSequential {no disj t1, t2, t3 : Timestamp | ((t2 in t1.nexts) and (t2 in t3.prevs) and (t3 in t1.prevs))}

pred show(){}
run show for 4






