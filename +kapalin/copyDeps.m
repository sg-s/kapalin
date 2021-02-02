

function copyDeps(repo_dir)


arguments
	repo_dir char = pwd
end	

original_dir = pwd;

[~,project_name]=fileparts(repo_dir);

% check that we have copied it over to .kapalin
temp_folder = ['~/.kapalin/' project_name]; 
if exist(temp_folder,'dir')
else
	copyfile(repo_dir,temp_folder);
end

disp('[kapalin::testing] Reading JSON options...')
k_options = jsondecode(fileread([repo_dir filesep 'kapalin.json']));


disp('[kapalin::testing] Checking out master for all deps...')
for i = 1:length(k_options.deps)
	assert(logical(kapalin.searchPath(k_options.deps{i})),['Could not locate dependency: ' k_options.deps{i}])
	[~,go_here] = kapalin.searchPath(k_options.deps{i});
	cd(go_here)
	[e,o] = system('git checkout master');
	assert(e == 0,'Error checking out master')
end


disp('[kapalin] Copying external code to be co-packaged...')

for i = 1:length(k_options.external_code)
	[~,fname,ext]=fileparts(k_options.external_code{i});
	copyfile(k_options.external_code{i},fullfile(temp_folder,[fname,ext]))
end

cd(original_dir)