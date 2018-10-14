
% test a repo from a url
function results = test(repo_dir)

toolbox_name = '';
original_dir = pwd;



% verify that we are currently in an environment 
assert(env.list,'You need to first save your current environment (use env.save(''something'')')
[~,original_env] = env.list;
assert(~ispc,'kapalin.test() cannot run on Windows')
cd('~')
home_dir = pwd;
if exist('~/.kapalin','dir') == 7
	rmdir('~/.kapalin','s')
end
mkdir('~/.kapalin')

[~,dir_name] = fileparts(repo_dir);

disp(['[kapalin::testing] Starting build on ' dir_name])
cd(repo_dir)

disp('[kapalin::testing] Checking out master...')
[e,o] = system('git checkout master');
assert(e == 0,'Error checking out master')


% check that repo is clean
[~,m] = system('git status | grep "modified" | wc -l');
if str2double(m) > 0 
	error('You have unmodified files that have not been committed to your git repo. Cowardly refusing to proceed till you commit all files.')
end


% first -- check if we actually have to do anything, 
% or if the binary is already OK

if exist('last_build.kapalin','file')
	load('last_build.kapalin','-mat')
	[e,git_hash] = system('git rev-parse HEAD');

	assert(e == 0,'Error reading git hash')
	if strcmp(strtrim(git_hash),last_build)
		disp('[kapalin::testing] Nothing to do as most recent built is from latest commit')
		return
	end
else
	disp('[kapalin::testing] last_build.kapalin not found, assuming that we need to test.')
end



disp('[kapalin::testing] Reading JSON options...')
options = jsondecode(fileread('kapalin.json'));

disp('[kapalin::testing] Checking out master for all deps...')
for i = 1:length(options.deps)
	assert(logical(searchPath(options.deps{i})),'Could not locate dependency')
	[~,go_here] = searchPath(options.deps{i});
	cd(go_here)
	[e,o] = system('git checkout master');
	assert(e == 0,'Error checking out master')
end

disp('[kapalin::testing] Making the binary...')
cd(repo_dir)

prj_name = dir('*.prj');
assert(length(prj_name) == 1, 'Could not determine project name')


load('build_number','build_number'); 


matlab.addons.toolbox.toolboxVersion(prj_name.name,['1.0.0.' mat2str(build_number)]); 

toolbox_name = strrep(prj_name.name,'prj','mltbx');


disp('[kapalin] Making toolbox in ~/.kapalin/')
matlab.addons.toolbox.packageToolbox(prj_name.name,[home_dir '/.kapalin/' toolbox_name])




disp('[kapalin::testing] Switching to a new environment.')
env.create('kapalin_testing_env')


disp('[kapalin::testing] Installing the binary...')
cd('~/.kapalin/')
t = matlab.addons.toolbox.installToolbox(toolbox_name);


finishup = onCleanup(@() myCleanupFun(t, original_dir, original_env));


disp('[kapalin::testing] Testing the binary...')
eval(['[passed, total] = ' t.Name '.run_all_tests;'])
try
	assert(passed == total,'Some tests failed; aborting')
catch
	myCleanupFun(t, original_dir, original_env)
	return
end


disp('[kapalin::testing] Updating binary...')
movefile(['~/.kapalin/' toolbox_name],repo_dir)


disp('[kapalin::testing] Updating README with test results...')

if ismac
	[~,m] = system('sw_vers | grep ProductVersion');
	m = strtrim(strrep(m,'ProductVersion:',''));
	os_version = ['macOS_' m];
else
	% assume GNU/Linux
	os_version = 'GNU_Linux';
end

results.matlab_version = version;
results.os_version = os_version;
results.n_total = total;
results.n_pass = passed;
results.timestamp = datestr(now);


badge_url = kapalin.makeTestBadge(results);
cd(repo_dir)
lines = strsplit(fileread('README.md'),'\n','CollapseDelimiters',false);
% find where we should insert lines for test results badge
a = []; z = [];
for i = 1:length(lines)
	if any(strfind(lines{i},'<!--kapalin_test_result_start-->'))
		a = i;
	end
	if any(strfind(lines{i},'<!--kapalin_test_result_stop-->'))
		z = i;
	end
end
assert(~isempty(a) & ~isempty(z),'Error reading README.md')
lines = {lines{1:a} lines{z:end}};
lines = {lines{1:a} ['![](' badge_url ') '] lines{a+1:end}};

fileID = fopen('README.md','w');	
for i = 1:length(lines)
	this_line = strrep(lines{i},'%','%%');
	this_line = strrep(this_line,'\','\\');
	fprintf(fileID, [this_line '\n']);
end
fclose(fileID);


% now add this and commit
disp('[kapalin::testing] Making commit and pushing...')
system('git add README.md')
system('git commit -m "kapalin::tests passed"')
system('git push')

% make a note of this git commit and link to this build
[e,git_hash] = system('git rev-parse HEAD');
last_build = strtrim(git_hash);
save('last_build.kapalin','last_build')

disp('[kapalin::testing] All done. Returning to original state.')
myCleanupFun(t, original_dir, original_env)


return






% check if we are within the preferred test time
ptt = datevec(options.preferred_test_time);


ptt(1:3) = 0;
t_start = ptt;
t_stop = ptt;
t_start(4) = t_start(4) - options.test_time_margin/60;
t_stop(4) = t_stop(4) + options.test_time_margin/60;

t = datevec(now); t(1:3) = 0;

if nargin < 2
	force = false;
end

if ~force

	if (etime(t,t_start)>0 & etime(t_stop,t)>0)
		disp('[INFO] Within allowed time window. Will proceed with test...')

	else
		disp('[ABORT] Outside the requested time window to test, so doing nothing')
		cd('/')
		kapalin.init()
		return
	end
end



disp('Will push to remote...')

[s,m] = system('git push');
assert(s == 0,['[FATAL] Error pushing . Error was: ' m])


end
		
function myCleanupFun(toolbox_name, original_dir, original_env)
	disp('Cleaning up...')
	matlab.addons.toolbox.uninstallToolbox(toolbox_name);
	cd(original_dir)
	env.activate(original_env)


end



