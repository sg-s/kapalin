% makes a new project in ~/.kapalin
% nukes old files and folders if they are there

function new(name)

arguments
	name char 
end

% nuke old
dir_name = ['~/.kapalin/' name];

if exist(dir_name,'file') == 7
	rmdir(dir_name,'s')
end

mkdir(dir_name)