// Anonymous Apex script to move tasks from related Account to Opportunity based on Opportunity Contact Roles

// Define the Opportunity Id
String opportunityId = '006Hp0000175gxaIAA'; // Replace with the actual Opportunity Id

// Query Opportunity Contact Roles related to the Opportunity
List<OpportunityContactRole> opportunityContactRoles = [SELECT Id, ContactId FROM OpportunityContactRole WHERE OpportunityId = :opportunityId];
System.debug(opportunityContactRoles.size());
// Create a set to store Contact Ids associated with the Opportunity
Set<Id> contactIds = new Set<Id>();

// Populate the set with Contact Ids
for (OpportunityContactRole ocr : opportunityContactRoles) {
    contactIds.add(ocr.ContactId);
}
System.debug(contactIds.size());
// Query tasks related to the Contacts
List<Task> contactTasks = [SELECT Id, WhatId, WhoId FROM Task WHERE WhoId IN :contactIds];
System.debug(contactTasks.size());
// Create a list to store updated tasks
List<Task> updatedTasks = new List<Task>();

// Iterate through the tasks and update the WhatId to the Opportunity Id
for (Task task : contactTasks) {
    task.WhatId = opportunityId;
    updatedTasks.add(task);
}
System.debug(updatedTasks.size());
// Update the tasks
update updatedTasks;

System.debug('Tasks moved successfully!');
