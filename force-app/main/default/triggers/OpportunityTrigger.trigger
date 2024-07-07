trigger OpportunityTrigger on Opportunity (before update, before delete) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : Trigger.new) {
            if (opp.Amount < 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }
            accountIds.add(opp.AccountId);
        }
        Set<Contact> contactsToUpdate = new Set <Contact>([SELECT Id, AccountId FROM Contact WHERE Title = 'CEO' AND AccountId IN :accountIds]);
        for(Contact con : contactsToUpdate){
            for(Opportunity opp : Trigger.new){
                if(opp.Primary_Contact__c == null){
                    opp.Primary_Contact__c = con.Id;
                }
            }
        }

    }

    if (Trigger.isBefore && Trigger.isDelete) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : Trigger.old) {
            accountIds.add(opp.AccountId);
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :accountIds]);

        for (Opportunity opp : Trigger.old) {
            Account relatedAccount = accountMap.get(opp.AccountId);
            if (relatedAccount != null && relatedAccount.Industry == 'Banking' && opp.StageName == 'Closed Won') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
}
