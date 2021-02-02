% stop all timers 
function stop()
	
disp('[INFO] Stopping all kapalin timers...')
% find all timers and wipe kapalin timers
t = timerfind;
for i = 1:length(t)
	if any(strfind(func2str(t(i).TimerFcn),'kapalin'))
		stop(t(i))
		delete(t(i))
	end
end

