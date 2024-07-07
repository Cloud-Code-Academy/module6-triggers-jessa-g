trigger AccountTrigger on Account (before insert, after insert ) {
    if(Trigger.isBefore && Trigger.isInsert){
        for(Account acc : Trigger.new){
            if(acc.Type == null){
                acc.Type = 'Prospect';
            }
            if(acc.ShippingStreet != null){
                acc.BillingStreet = acc.ShippingStreet;
            }
            if(acc.ShippingCity != null){
                acc.BillingCity = acc.ShippingCity;
            }
            if(acc.ShippingState != null){
                acc.BillingState = acc.ShippingState;
            }
            if(acc.ShippingPostalCode != null){
                acc.BillingPostalCode = acc.ShippingPostalCode;
            }
            if(acc.ShippingCountry != null){
                acc.BillingCountry = acc.ShippingCountry;
            }
            if(acc.Phone != null && acc.Website != null && acc.Fax != null){
                acc.Rating = 'Hot';
            }
        }
    }
    List<Contact> defaultContacts = new List<Contact>();
    if(Trigger.isAfter && Trigger.isInsert){
        System.debug('This is the after trigger.');
        for(Account acc : Trigger.new){
            Contact con = new Contact();
            con.AccountId = acc.Id;
            con.LastName = 'DefaultContact';
            con.Email = 'default@email.com';
            defaultContacts.add(con);
            System.debug('This is default contacts' + defaultContacts);
        }
        Database.insert(defaultContacts, AccessLevel.SYSTEM_MODE);
    }
    
}