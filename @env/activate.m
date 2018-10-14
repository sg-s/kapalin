% activates a given environment 
function activate(name)

warning('off','MATLAB:mpath:nameNonexistentOrNotADirectory')


kapalin_path = fileparts(fileparts(which('env')));
restoredefaultpath
addpath(kapalin_path)

name = ['env_' name];

assert(exist(name)==2,'Environment not found')

eval(['p = ' name ';'])
addpath(p);

name = name(5:end);
save([kapalin_path, filesep, 'current_env.mat'],'name')

warning('on','MATLAB:mpath:nameNonexistentOrNotADirectory')