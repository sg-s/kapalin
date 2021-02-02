

function copyDeps(options)


arguments
	options struct
end	

original_dir = pwd;

project_name = options.name;

% check that we have copied it over to .kapalin
temp_folder = ['~/.kapalin/' project_name]; 
if exist(temp_folder,'dir')
else
	copyfile(options.repo_dir,temp_folder);
end



disp('[kapalin::testing] Checking out master for all deps...')
for i = 1:length(options.deps)
	assert(logical(kapalin.searchPath(options.deps{i})),['Could not locate dependency: ' options.deps{i}])
	[~,go_here] = kapalin.searchPath(options.deps{i});
	cd(go_here)
	[e,o] = system('git checkout master');
	assert(e == 0,'Error checking out master')
end


disp('[kapalin] Copying external code to be co-packaged...')

for i = 1:length(options.external_code)
	[~,fname,ext]=fileparts(options.external_code{i});
	copyfile(options.external_code{i},fullfile(temp_folder,[fname,ext]))
end

cd(original_dir)