% get git repo from url

function [base_name, options] = get(url)

fprintf('\n')
disp(url)
base_name = url(max(strfind(url,'/'))+1:end);
assert(length(base_name) > 0,'base_name of repo could not be determined')
cd('~/.kapalin')
try
	rmdir(base_name,'s')
catch
end
mkdir(base_name)
disp('[INFO] Attempting to download repo...')
[s,m]=system(['git clone ' url]);
if s > 0
	disp('FAILED. Will try Github...')
	% attempt to fix url
	url = ['git@github.com:' url '.git'];
	[s,m] = system(['git clone ' url]);
end
assert(s == 0,['[FATAL] Failed to get this repo. The error was: ' m])

% add all paths to matlab path
disp('[INFO] Adding repo to path...')
all_paths = strsplit(genpath(['~/.kapalin/' base_name]),pathsep);
for i = 1:length(all_paths)
	if any(strfind(all_paths{i},'.git'))
		continue
	end
	addpath(all_paths{i})
end
savepath

disp('DONE!')
disp('[INFO] Inspecting repo...')

if exist(['~/.kapalin/' base_name '/kapalin.json'])~=2
	disp('No kapalin.json found, assuming that this is a dependency')
	return
end

options = jsondecode(fileread(['~/.kapalin/' base_name '/kapalin.json']));

disp('[INFO] Installing dependencies...')

for i = 1:length(options.deps)
	kapalin.get(options.deps{i});
end
