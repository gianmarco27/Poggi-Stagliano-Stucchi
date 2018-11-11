open util/boolean
open util/integer


sig Identifier{}

sig TypeOfData{}

abstract sig Data{}

sig MonitoredData extends Data{
	values: some Int,
	category: one TypeOfData,
}

sig MandatoryField extends Data{

}


sig PersonalData extends Data{
 	SSN: one Identifier,
	mandatoryFields: some MandatoryField, //Sex, age, height, weight, home address...
}//{#mandatoryFields = 5}


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
	returns: some MonitoredData, 
// If the filters gets created it means it had valid mandatoryFields and respects privacy constraints, else exception in use cases
// As specified in the use cases filters cannot be created if privacy constraints are not met
}



// --- AutomatedSOS ---

sig AutomatedSOSUser in Individual {
	constraints: some MonitoringConstraint,
	emergencies: set Emergency
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

sig Runner in Individual {
	subs: some Subscription,
}

sig Subscription {
	subscriptionTime: one Timestamp,
	runEnrolled: one Run,
}

sig Timestamp {
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


fact ExclusivePaternityOfPersonalData {all pd : PersonalData |  no disj i1, i2 : Individual | (pd in i1.bio <=> pd in i2.bio) }

fact  ExclusivePaternityOfMonitoredData {all md : MonitoredData |  no disj i1, i2 : Individual | (md in i1.tracking <=> md in i2.tracking)  }

fact IdentifierConsistency {all i : Individual | (i.id = i.bio.SSN) }

fact ThirdPartyHaveOtherIdentifiers {no i : Identifier | some u : Individual | some t : ThirdParty | i in u.id and i in t.id}

fact UnicityOfThirdPartyIdentifier {no i : Identifier | some disj t1 , t2 : ThirdParty | i in t1.id and i in t2.id}

fact UnicityOfData4HelpAccount {no disj i1 , i2 : Individual |   i1.id = i2.id}

fact PersonalDataUnicity {no disj p1, p2 : PersonalData | (p1.SSN = p2.SSN)}

fact UnicityOfMandatoryField {no mf : MandatoryField | some disj p1, p2 : PersonalData | (mf in p1.mandatoryFields and mf in p2.mandatoryFields)}

fact MonitoredDataBelongToSomeone {no d : MonitoredData | all i : Individual | d not in i.tracking}

fact FiltersBelongToSomeone {no f : Filter | all t : ThirdParty | f not in t.categories}

fact ExclusivePaternityOfFilter { all f : Filter | no disj t1, t2 : ThirdParty | (f in t1.categories and f in t2.categories)}

fact MonitoringConstraintsHaveBounds {all mc : MonitoringConstraint | #mc.upperBound > 0 or #mc.lowerBound > 0}

fact MonitoringConstraintsBelongToSomeone {no mc : MonitoringConstraint | all u : AutomatedSOSUser | mc not in u.constraints}

fact UnicityOfMonitoringConstraint {no disj mc1, mc2 : MonitoringConstraint | some u : AutomatedSOSUser | mc1 in u.constraints and mc2 in u.constraints and mc1.category = mc2.category}

fact ExclusivityOfMonitoringConstraint {no disj u1 , u2 : AutomatedSOSUser | some mc : MonitoringConstraint | mc in u1.constraints and mc in u2.constraints}

//-----------------------------------Track4Run--------------------------------

fact UnicityOfTitle {no disj r1, r2 : Run | r1.title = r2.title}

fact SubscriptionMustHappenBeforeStart { all s : Subscription | s.subscriptionTime in s.runEnrolled.startTime.prevs }

fact TimestampsBelongToSomething {no t : Timestamp | all r : Run | all s : Subscription | not (t in s.subscriptionTime or t in r.startTime)}

fact RunnersInRunHaveSubscriptionToIt {all r : Run | all ru : Runner | (ru in r.runners iff (one s : Subscription | (s in ru.subs and s.runEnrolled = r)))}

fact RunnersOnlySubscibeOnce {no disj s1, s2 : Subscription | some r : Runner | s1 in r.subs and s2 in r.subs and s1.runEnrolled = s2.runEnrolled}

fact PaternityOfSubscription{all s : Subscription | all disj r1, r2 : Runner | not (s in r1.subs and s in r2.subs)}

fact PaternityRuntitle {no r : RunTitle | all runs : Run | r not in runs.title}

fact PaternityIdentifier {no i : Identifier | all u : User | i not in u.id}

fact PaternitySub {no s : Subscription | all r : Runner | s not in r.subs}

fact PaternityTypeofData {no t : TypeOfData | all md : MonitoredData | all mc : MonitoringConstraint | t not in md.category and t not in mc.category}

fact PaternityMandatoryField {no mf : MandatoryField | all p : PersonalData | mf not in p.mandatoryFields}

fact PaternityOfEmergency {no e : Emergency | all u : AutomatedSOSUser | e not in u.emergencies}

fact ExclusivePaternityOfEmergency {no e : Emergency | all disj u1 , u2 : AutomatedSOSUser | e in u1.emergencies and e in u2.emergencies}

fact MonitoringConstraintUseDataFromMonitoredData {all t : TypeOfData | all mc : MonitoringConstraint | some md : MonitoredData | t in mc.category implies t in md.category}

fact ExclusivityOfSubscribedFilter {all disj f1, f2 : Filter | some t : ThirdParty | not (f1 in t.categories and f2 in t.categories and (f1.subscribed = True and f2.subscribed = True) and f1.uses = f2.uses)}

fact FiltersAcceptedReturnData{all f :Filter | all i : Individual | some mf : i.bio.mandatoryFields | mf in f.uses iff (all md : i.tracking | md in f.returns)}

fact EmergencyRelationIsBijective{all e : Emergency | all u : AutomatedSOSUser | e in u.emergencies iff e.user = u}

fact UnicityOfEmergency {all disj e1, e2 : Emergency | all u : AutomatedSOSUser | (e1 in u.emergencies and e2 in u.emergencies and e1.violatedConstraint=e2.violatedConstraint) implies
															(some disj md1 , md2 : u.tracking | md1.category = md2.category and md1.category = e1.violatedConstraint.category)}

fact EmergencyTriggersOnConstraintBelongingToUser {all e : Emergency | all u : AutomatedSOSUser | e in u.emergencies iff e.violatedConstraint in u.constraints}

fact EmergencyOnlyOnConstraintViolation {all e : Emergency | all u : AutomatedSOSUser | e in u.emergencies iff
									 (some md : u.tracking |  e.violatedConstraint.category = md.category and 
									  (all v1 , v2 : md.values | ((v1 > e.violatedConstraint.upperBound and #e.violatedConstraint.upperBound = 1) or
																	(v1 < e.violatedConstraint.lowerBound and #e.violatedConstraint.lowerBound = 1) or
																		(v2 < e.violatedConstraint.lowerBound and #e.violatedConstraint.lowerBound = 1) or
																			(v2 < e.violatedConstraint.lowerBound and #e.violatedConstraint.lowerBound = 1))))}


pred RunEnrollment [ru : Runner, r : Run, s : Subscription, p : PersonalData, t1 , t2 : Timestamp] {
	s.runEnrolled = r
	r.runners = ru
	s in ru.subs
	r.startTime = t1
	s.subscriptionTime = t2 
	ru.bio = p 
}

pred EmergencyTrigger [u : AutomatedSOSUser, e : Emergency, md : MonitoredData, t : TypeOfData, v1 , v2 : Int] {
	e in u.emergencies
	e.user = u
	e.violatedConstraint in u.constraints 
	e.violatedConstraint.category = t
	md.category = t
	md.category = t
	v1 in md.values
	e.violatedConstraint.upperBound = v2
	v1 > v2
}

pred ThirdPartyFilterRequest [t : ThirdParty, f : Filter, md : MonitoredData , i : Individual, mf : MandatoryField] {
	f in t.categories
	mf in f.uses
	mf in i.bio.mandatoryFields
	md in i.tracking
	md in f.returns
}
fact {#Emergency=0}
fact {#Run = 0}
fact {#Filter > 5}
fact {#MonitoredData > 5}
fact {#ThirdParty = 2}

//run RunEnrollment
//run EmergencyTrigger
//run ThirdPartyFilterRequest
pred show(){}

run show for 10

// editare class diagram con relazione direct not extend
////ma un runner può isciriversi a 2 gare che iniziano contemporaneamente/overlapping   per noi si, scemo lui



