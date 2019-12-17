% activates a given environment 
% usage:
% env.activate('env_name')
%
function activate(name)

warning('off','MATLAB:mpath:nameNonexistentOrNotADirectory')


kapalin_path = fileparts(fileparts(which('env.save')));
restoredefaultpath
addpath(kapalin_path)

name = ['env_' name];

assert(exist([kapalin_path filesep '+env' filesep name '.m'],'file')==2,'Environment not found')


addpath(env.(name));

name = name(5:end);

setpref('kapalinenv','current_env',name)

warning('on','MATLAB:mpath:nameNonexistentOrNotADirectory')