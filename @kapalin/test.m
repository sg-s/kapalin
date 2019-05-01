
% test a repo from a url
function results = test(varargin)

kapalin.init()


% options and defaults
options.repo_dir = '';
options.upload_binary = false;
options.force_test = false;
options.test_vms = false;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

% validate and accept options
if (length(varargin))/2 == floor((length(varargin))/2) % even
	for ii = 1:2:length(varargin)-1
	temp = varargin{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options.(temp) = varargin{ii+1};
    	end
    end
end
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end

repo_dir = options.repo_dir;
force_test = options.force_test;

toolbox_name = '';
original_dir = pwd;
t = '';

% verify that we are currently in an environment 
assert(~isempty(env.list),'You need to first save your current environment (use env.save(''something'')')
[~,original_env] = env.list;
assert(~ispc,'kapalin.test() cannot run on Windows')

finishup = onCleanup(@() myCleanupFun(t, original_dir, original_env));


cd('~')
home_dir = pwd;
if exist('~/.kapalin','dir') == 7
	rmdir('~/.kapalin','s')
end
mkdir('~/.kapalin')

disp(['[kapalin::testing] Starting build on ' repo_dir])
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
[e,git_hash] = system('git rev-parse HEAD');
git_hash = strtrim(git_hash);
if exist('last_build.kapalin','file')
	load('last_build.kapalin','-mat')
	last_build = strtrim(last_build);

	assert(e == 0,'Error reading git hash')
	if strcmp(git_hash,last_build) && ~force_test
		disp('[kapalin::testing] Nothing to do as most recent built is from latest commit')


		prj_name = dir([repo_dir filesep '*.prj']);
		toolbox_name = strrep(prj_name.name,'prj','mltbx');
		if options.test_vms
			kapalin.testUsingVM([repo_dir filesep toolbox_name]);
		end

		if options.upload_binary
			kapalin.uploadToolbox2Github(repo_dir);
		end

		return
	else
		disp('[kapalin::testing] last_build does not match current hash')
		disp(['last_build:' last_build])
		disp(['current_hash:' git_hash])
	end
else
	disp('[kapalin::testing] last_build.kapalin not found, assuming that we need to test.')
end



disp('[kapalin::testing] Reading JSON options...')
k_options = jsondecode(fileread('kapalin.json'));

disp('[kapalin::testing] Checking out master for all deps...')
for i = 1:length(k_options.deps)
	assert(logical(searchPath(k_options.deps{i})),['Could not locate dependency: ' k_options.deps{i}])
	[~,go_here] = searchPath(k_options.deps{i});
	cd(go_here)
	[e,o] = system('git checkout master');
	assert(e == 0,'Error checking out master')
end

disp('[kapalin::testing] Making the binary...')
cd(repo_dir)

prj_name = dir('*.prj');
assert(length(prj_name) == 1, 'Could not determine project name')


toolbox_name = strrep(prj_name.name,'prj','mltbx');


disp('[kapalin] Making toolbox in ~/.kapalin/')
matlab.addons.toolbox.packageToolbox(prj_name.name,[home_dir '/.kapalin/' toolbox_name])


disp('[kapalin::testing] Switching to a new environment.')
env.create('kapalin_testing_env')


disp('[kapalin::testing] Installing the binary...')
cd('~/.kapalin/')
t = matlab.addons.toolbox.installToolbox(toolbox_name);


disp('[kapalin::testing] Testing the binary...')


eval(['[passed, total] = ' t.Name '.run_all_tests;'])


if passed < total
	disp('Some tests failed; aborting.')
	myCleanupFun(t, original_dir, original_env)
	return

end

% make a note of this git commit and link to this build
last_build = git_hash;
save([repo_dir filesep 'last_build.kapalin'],'last_build')

disp('[kapalin::testing] Updating binary...')
movefile(['~/.kapalin/' toolbox_name],repo_dir)


% ask the VMs to test this too
if options.test_vms
	kapalin.testUsingVM(toolbox_name);
end





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


if options.upload_binary
	kapalin.uploadToolbox2Github(repo_dir);
else
	disp('Not uploading binaries to github...')
end




disp('[kapalin::testing] All done. Returning to original state.')
myCleanupFun(t, original_dir, original_env)


end


		
function myCleanupFun(toolbox_name, original_dir, original_env)
	disp('Cleaning up...')

	if ~isempty(toolbox_name)
		matlab.addons.toolbox.uninstallToolbox(toolbox_name);
	end
	cd(original_dir)
	env.activate(original_env)


end

