% start kapalin daemon
function start()
	



kapalin.stop()

disp('[INFO] Starting kapalin daemon...')

daemon_handle = timer('TimerFcn',@kapalin.kapalind,'ExecutionMode','fixedDelay','TasksToExecute',Inf,'Period',1);
start(daemon_handle);