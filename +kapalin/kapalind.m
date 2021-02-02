% what the daemon does is simple:
% if it's running a VM
% it looks at the vm_share folder,
% and tests and toolbox in it
% and spits out a report 

function kapalind(~,~)

if strcmp(getpref('kapalin','mode'),'VM')
else
	return
end

path_to_share = getpref('kapalin','path_to_vm_share');

try
	allfiles = dir([path_to_share filesep '*.mltbx']);
catch
	% this probably means there are no toolboxes
	return
end

if length(allfiles) < 1
	return
end

assert(length(allfiles) == 1,'Expected exactly one toolbox')


disp('[kapalin::testing] Switching to a new environment.')
env.create('kapalin_testing_env')

t = matlab.addons.toolbox.installToolbox([allfiles.folder filesep allfiles.name]);

if ismac
	[~,m] = system('sw_vers | grep ProductVersion');
	m = strtrim(strrep(m,'ProductVersion:',''));
	os_version = ['macOS_' m];
else
	% assume GNU/Linux
	os_version = 'GNU_Linux';
end



disp('[kapalin::testing] Testing the binary...')

eval(['[passed, total] = ' t.Name '.run_all_tests;'])



results.matlab_version = version;
results.os_version = os_version;
results.n_total = total;
results.n_pass = passed;
results.timestamp = datestr(now);
save([allfiles.folder filesep 'vm_test_results.mat'],'results')

% uninstall the toolbox
matlab.addons.toolbox.uninstallToolbox(t);

% delete the toolbox
delete([allfiles.folder filesep allfiles.name])