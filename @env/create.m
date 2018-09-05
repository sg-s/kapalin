% static method of the env method
function create(name)


assert(~isempty(name),'No name specified')

% in any case, start from a brand new factory install
kapalin_path = fileparts(fileparts(which('env')));
restoredefaultpath
addpath(kapalin_path)
savepath;

% save this path to the env file 
env.save(name)