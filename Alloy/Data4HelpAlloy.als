open util/boolean
open util/integer


sig Identifier{}

sig TypeOfData{}

abstract sig Data{}

sig MonitoredData extends Data{
	values: set Int,
	category: one TypeOfData,
}

sig MandatoryField extends Data{

}


sig PersonalData extends Data{
 	SSN: one Identifier,
	mandatoryFields: some MandatoryField, //Sex, age, height, weight, home address...
}


abstract sig User {
	id: one Identifier,
}

sig Individual extends User{
	bio: one PersonalData,
	tracking: set MonitoredData,
}

sig ThirdParty extends User{
	categories: some Filter,
}

sig Filter{
	subscribed: one Bool,
	uses: some MandatoryField,
	returns: set MonitoredData,
}

// --- AutomatedSOS ---

sig AutomatedSOSUser extends Individual{

	constraints: some MonitoringConstraint,

}

sig MonitoringConstraint {
	category: one TypeOfData,
	upperBound: lone Int,
	lowerBound: lone Int
}{upperBound > lowerBound}

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
	title: one RunTitle,
	startTime: one Timestamp,
	runners: some Runner,
}

//---------------------- Fact to define temporal order of timestamps---------------------------
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


//---------------------------------------------------------------------------------------------------

fact ExclusivePaternityOfData {all pd1, md1 : Data |  no disj i1, i2 : Individual | (pd1 in i1.bio and pd1 in i2.bio) or (md1 in i1.tracking and md1 in i2.tracking) }

fact UnicityOfIdentifiers {all id1 : Identifier |no disj u1, u2 : User | (id1 in u1.id and id1 in u2.id)}

fact IdentifierConsistency {all i : Individual | (i.id = i.bio.SSN) }

fact PersonalDataUnicity {no disj p1, p2 : PersonalData | (p1.SSN = p2.SSN)}

fact UnicityOfMandatoryField {no mf : MandatoryField | all p1, p2 : PersonalData | (mf in p1.mandatoryFields and mf in p2.mandatoryFields)}

fact MonitoredDataBelongToSomeone {no d : MonitoredData | all i : Individual | d not in i.tracking}

fact FiltersBelongToSomeone {no f : Filter | all t : ThirdParty | f not in t.categories}

fact ExclusivePaternityOfFilter { all f : Filter | no disj t1, t2 : ThirdParty | (f in t1.categories and f in t2.categories)}

fact MonitoringConstraintsHaveBounds {all mc : MonitoringConstraint | #mc.upperBound > 0 or #mc.lowerBound > 0}

fact MonitoringConstraintsBelongToSomeone {no mc : MonitoringConstraint | all u : AutomatedSOSUser | mc not in u.constraints}

fact EmergencyDetected {all u : AutomatedSOSUser | all mc : MonitoringConstraint | all md : MonitoredData | all v : MonitoredData.values | all e : Emergency |
						(mc in u.constraints and md in u.tracking and mc.category = md.category and 
								(v > mc.upperBound or v < mc.lowerBound)) iff (e.user = u and e.violatedConstraint=mc)}






fact si {#Individual = 3}
fact si2volte {#MonitoredData= 5}
pred show(){}
run show for 10






