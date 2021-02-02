% obfuscate code
% for pedagogical or other purposes

function obfuscateCode(options)

arguments
	options struct
end	


project_name = options.name;


% copy the entire directory to a new place
temp_folder = ['~/.kapalin/' project_name]; 
copyfile(options.repo_dir,temp_folder);

% obfuscate all code inplace
pcode(temp_folder,'-inplace')

% obfuscate all toolboxes
toolboxes = dir(fullfile(temp_folder,'+*'));
for i = 1:length(toolboxes)
	pcode(fullfile(temp_folder,toolboxes(i).name),'-inplace')
end

% obfuscate all classes
classes = dir(fullfile(temp_folder,'@*'));
for i = 1:length(classes)
	pcode(fullfile(temp_folder,classes(i).name),'-inplace')
end


% delete the .git folder in the new copy
try
	rmdir([temp_folder '/.git'],'s')
catch
end

% delete .m files from the new copy
allfiles = kapalin.getAllFiles([temp_folder filesep]);

for i = 1:length(allfiles)
	thisfile = allfiles{i};
	if strcmp(thisfile(end-1:end),'.m')
		delete(thisfile)
	end
end