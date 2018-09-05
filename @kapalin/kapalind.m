function kapalind(~,~)

t = datevec(now); t(1:3) = 0;

% kapalin should only run after office hours
t_start = [0 0 0 20 0 0]; % 8 PM
t_stop = [0 0 0 8 0 0]; % 8 AM

if ~(etime(t,t_start)>0 | etime(t_stop,t)>0)
	return
end

disp('kapalin is in allowed timezone, initiating...')
disp(datestr(now))

% figure out all the repos to test
load([fileparts(which(mfilename)) filesep 'repos.mat'])
for i = 1:length(repos)
	kapalin.test(repos{i});
end


