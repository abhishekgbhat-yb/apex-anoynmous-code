// Query all Opportunity Contact Roles
List<OpportunityContactRole> allOpportunityContactRoles = [SELECT Id, ContactId, OpportunityId FROM OpportunityContactRole];
System.debug('Total Opportunity Contact Roles: ' + allOpportunityContactRoles.size());

// Create a map to store Contact Ids associated with each Opportunity
Map<Id, Set<Id>> opportunityContactMap = new Map<Id, Set<Id>>();

// Populate the map with Contact Ids for each Opportunity
for (OpportunityContactRole ocr : allOpportunityContactRoles) {
    if (!opportunityContactMap.containsKey(ocr.OpportunityId)) {
        opportunityContactMap.put(ocr.OpportunityId, new Set<Id>());
    }
    opportunityContactMap.get(ocr.OpportunityId).add(ocr.ContactId);
}
System.debug('Total Opportunities with associated Contacts: ' + opportunityContactMap.size());

// Create a set to store unique Task IDs
Set<Id> uniqueTaskIds = new Set<Id>();

// Create a list to store updated tasks
List<Task> updatedTasks = new List<Task>();

// Iterate through the map and update the tasks
for (Id opportunityId : opportunityContactMap.keySet()) {
    Set<Id> contactIds = opportunityContactMap.get(opportunityId);

    // Query tasks related to the Contacts
    List<Task> contactTasks = [SELECT Id, WhatId, WhoId FROM Task WHERE WhoId IN :contactIds];

    // Iterate through the tasks and update the WhatId to the Opportunity Id
    for (Task task : contactTasks) {
        // Check if the task ID is already in the set to avoid duplicates
        if (!uniqueTaskIds.contains(task.Id)) {
            task.WhatId = opportunityId;
            updatedTasks.add(task);
            uniqueTaskIds.add(task.Id);
        }
    }
}

// Update the tasks
if (!updatedTasks.isEmpty()) {
    update updatedTasks;
    System.debug('Tasks moved successfully!');
} else {
    System.debug('No tasks to update.');
}
