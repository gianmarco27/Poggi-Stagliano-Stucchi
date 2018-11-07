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

sig AutomatedSOSUser{
	data4HelpAccount: one Individual,
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

sig Runner {
	data4HelpAccount: one Individual,
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

fact ExclusivePaternityOfData {all pd1, md1 : Data |  no disj i1, i2 : Individual | (pd1 in i1.bio and pd1 in i2.bio) or (md1 in i1.tracking and md1 in i2.tracking)  }

fact UnicityOfIdentifiers{ all id1 : Identifier | all disj u1, u2 : User | not (id1 in u1.id and id1 in u2.id) }

fact IdentifierConsistency {all i : Individual | (i.id = i.bio.SSN) }

fact PersonalDataUnicity {no disj p1, p2 : PersonalData | (p1.SSN = p2.SSN)}

fact UnicityOfMandatoryField {no mf : MandatoryField | some disj p1, p2 : PersonalData | (mf in p1.mandatoryFields and mf in p2.mandatoryFields)}

fact MonitoredDataBelongToSomeone {no d : MonitoredData | all i : Individual | d not in i.tracking}

fact FiltersBelongToSomeone {no f : Filter | all t : ThirdParty | f not in t.categories}

fact ExclusivePaternityOfFilter { all f : Filter | no disj t1, t2 : ThirdParty | (f in t1.categories and f in t2.categories)}

fact MonitoringConstraintsHaveBounds {all mc : MonitoringConstraint | #mc.upperBound > 0 or #mc.lowerBound > 0}

fact MonitoringConstraintsBelongToSomeone {no mc : MonitoringConstraint | all u : AutomatedSOSUser | mc not in u.constraints}

fact EmergencyDetected {all u : AutomatedSOSUser | all mc : MonitoringConstraint | all md : MonitoredData | all v : MonitoredData.values | all e : Emergency |
						(mc in u.constraints and md in u.data4HelpAccount.tracking and mc.category = md.category and 
								(v > mc.upperBound or v < mc.lowerBound)) iff (e.user = u and e.violatedConstraint=mc)}

fact UnicityOfAutomatesSOSUser {no disj u1, u2 : AutomatedSOSUser | some i : Individual | i in u1.data4HelpAccount and i in u2.data4HelpAccount }

fact  UnicityOfRunner {no disj r1, r2 : Runner | some i : Individual | i in r1.data4HelpAccount  and i in r2.data4HelpAccount }

//-----------------------------------Track4Run--------------------------------

fact UnicityOfTitle {no disj r1, r2 : Run | r1.title = r2.title}

fact SubscriptionMustHappenBeforeStart { all s : Subscription | s.subscriptionTime in s.runEnrolled.startTime.prevs }

fact TimestampsBelongToSomething {all t : Timestamp | all r : Run | all s : Subscription | t in s.subscriptionTime or t in r.startTime}

fact RunnersInRunHaveSubscriptionToIt {all r : Run | all ru : Runner | (ru in r.runners iff (one s : Subscription | (s in ru.subs and s.runEnrolled = r)))}

fact RunnersOnlySubscibeOnce {no disj s1, s2 : Subscription | some r : Runner | s1 in r.subs and s2 in r.subs and s1.runEnrolled = s2.runEnrolled}

fact PaternityOfSubscription{all s : Subscription | all disj r1, r2 : Runner | not (s in r1.subs and s in r2.subs)}

assert pippo {all disj s1, s2 : Subscription | not (s1.subscriptionTime = s2.subscriptionTime and s1.runEnrolled = s2.runEnrolled)}

fact PaternityRuntitle {no r : RunTitle | all runs : Run | r not in runs.title}

fact PaternityIdentifier {no i : Identifier | all u : User | i not in u.id}

fact PaternitySub {no s : Subscription | all r : Runner | s not in r.subs}

fact PaternityTypeofData {no t : TypeOfData | all md : MonitoredData | all mc : MonitoringConstraint | t not in md.category and t not in mc.category}

fact PaternityMandatoryField {no mf : MandatoryField | all p : PersonalData | mf not in p.mandatoryFields}

fact MonitoringConstraintUseDataFromMonitoredData {all t : TypeOfData | all mc : MonitoringConstraint | some md : MonitoredData | t in mc.category implies t in md.category}

fact si {#Runner = 1}
fact {#Runner.subs = 2}
fact {#Run > 1}
//fact si2volte {#MonitoredData= 5}
pred show(){}
//check pippo
run show for 10

//se subscribed true non può esistere un altro filtro della stessa third party
// editare class diagram con relazione direct not extend
////ma un runner può isciriversi a 2 gare che iniziano contemporaneamente/overlapping



