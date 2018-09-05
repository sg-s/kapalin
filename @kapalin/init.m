



% initialize kapalin session
% clears all folders in .kapalin
% nukes all kapalin files from the path 

function init()

assert(~ispc,'kapalin cannot run on a windows computer')

cd('~')


% save user's custom path, and reset
% everything to MATLAB factory default
% + kapalin

kapalin_path = fileparts(which(mfilename));

s = savepath([kapalin_path filesep 'kapalin_user_path.m']);

assert(s==0,'Error saving path, will not continue');

restoredefaultpath
addpath(kapalin_path)
savepath;

% make the kapalin folders if need be
if ~exist('~/.kapalin','dir')
	mkdir('~/.kapalin')
else
	rmdir('~/.kapalin','s')
	mkdir('~/.kapalin')
end
fprintf(' [DONE] \n')

