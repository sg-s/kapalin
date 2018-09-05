
function startAsHost()

kapalin.stop()

disp('[INFO] Starting kapalin daemon')

daemon_handle = timer('TimerFcn',@kapalin.kapalind,'ExecutionMode','fixedDelay','TasksToExecute',Inf,'Period',600);
start(daemon_handle);

