open util/boolean

sig Identifier{}

//fact: un gruppo di dati appartiene solo a un individuo.
abstract sig Data{}

sig MonitoredData extends Data{

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

}
//aggiungere a UML entità MandatoryField e freccia di associazione tra filtro e questa entità (ricordarsi molteplicità). Aggiungere molteplicità tra FIlter e Third Party
sig Filter{
	subsciption: one Bool;
	uses: some MandatoryField;
}




