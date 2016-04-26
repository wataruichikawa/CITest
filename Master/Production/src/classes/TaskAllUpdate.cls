global class TaskAllUpdate implements Database.Batchable<sObject>{
	global String query;

	global Database.querylocator start(Database.BatchableContext BC){

		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){

		List<Task> updTaskList = new List<Task>();
		for(sObject s : scope){
			Task task = (Task)s;
			task.DataUpdFlgForTrigger__c = true;
			updTaskList.add(task);
		}

		if (updTaskList.size() > 0) {
			System.debug('updTaskList.size()) ***********************************');
			System.debug(updTaskList.size());
			System.debug(updTaskList);
			System.debug('******************************************************');
			update updTaskList;
		}

	}

	global void finish(Database.BatchableContext BC){
	}
}