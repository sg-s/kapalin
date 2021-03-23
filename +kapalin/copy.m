function copy(options)


disp('[kapalin] Copying code...')

project_name = options.name;

% copy the entire directory to a new place
temp_folder = ['~/.kapalin/' project_name]; 
copyfile(options.repo_dir,temp_folder);