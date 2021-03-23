% makes a new project in ~/.kapalin
% nukes old files and folders if they are there

function new(options)

arguments
	options struct 
end


disp('[kapalin] Making new directory in ~/.kapalin...')

% nuke old
dir_name = ['~/.kapalin/' options.name];

if exist(dir_name,'file') == 7
	rmdir(dir_name,'s')
end

mkdir(dir_name)