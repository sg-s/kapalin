

function copyExternalCode(options)


arguments
	options struct
end	

if ~isfield(options,'external_code')
	return
end

disp('[kapalin] Copying external code:')


original_dir = pwd;

project_name = options.name;

% check that we have copied it over to .kapalin
temp_folder = ['~/.kapalin/' project_name]; 
if exist(temp_folder,'dir')
else
	copyfile(options.repo_dir,temp_folder);
end


for i = 1:length(options.external_code)


	this_code = options.external_code{i};

	disp(['         ' this_code])

	% get the folder name
	foldername = pathlib.lowestFolder(this_code);


	% check out master
	if isdir(this_code)
		cd(this_code)
	else
		cd(fileparts(this_code))
	end
	[e,o] = system('git checkout master');
	assert(e == 0,'Error checking out master')


	% copy

	if any(strfind(this_code,'*'))
		% wild card
		allfiles = dir(this_code);
		for j = 1:length(allfiles)
			copyfile([allfiles(j).folder filesep allfiles(j).name],fullfile(temp_folder,allfiles(j).name))
		end
	else
		% simple copy
		copyfile(this_code,fullfile(temp_folder,foldername))
	end


	
end


cd(original_dir)