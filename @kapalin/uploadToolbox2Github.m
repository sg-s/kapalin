function uploadToolbox2Github(repo_dir)

original_folder = pwd;

disp('[kaplin::uploadToolbox2Github] starting...')

assert(exist(repo_dir,'dir')==7,'Repo dir not found')

cd(repo_dir)

mt = dir('*.mltbx');
assert(length(mt) == 1,'Wrong number of MATLAB toolboxes')


options = jsondecode(fileread('kapalin.json'));

assert(exist(options.github_token,'file') == 2,'Could not read github_token')

% read github_token
[e,github_token]=system('cat .github_token.json');
assert(e==0,'Error reading token')




assert(exist([fileparts(which(mfilename)) filesep 'config.json'],'file') == 2,'config.json not found. Create this file in your kapalin root folder.')

p = jsondecode(fileread([fileparts(which(mfilename)) filesep 'config.json']));
options.github_release_path = p.github_release_path;
clear p

% check if github-release is on path
[e,o] = system('which github-release');
if e == 1
	p = strsplit(getenv('PATH'),':');
	p = [p options.github_release_path];
	p = strjoin(p,':');
	setenv('PATH',p)
end


desc = ['"Click on the file named ' options.github_binary{1} ' to download a MATLAB toolbox. Drag that file onto your MATLAB workspace to install. This release has been generated using kapalin, an automated testing framework in MATLAB."'];

t = datevec(today);
version_name = ['version ' mat2str(t(1)-2000) '.' mat2str(t(2)) '.' mat2str(3)];

% create a release 
[e,o]=system(['github-release release --user ' options.github_user_name ' --repo ' options.github_repo ' --tag ' datestr(today) ' --name ' version_name ' -s ' github_token ' --description ' desc]);

% upload the binary 
[e,o]=system(['github-release upload --user ' options.github_user_name ' --repo ' options.github_repo ' --tag ' datestr(today) ' --name ' options.github_binary{1} ' -s ' github_token ' --file ' options.github_binary{1}]);


% amend the "latest" to point to this binary 
[e,o]=system(['github-release upload --user ' options.github_user_name ' --repo ' options.github_repo ' --tag "latest" --name ' options.github_binary{1} ' -s ' github_token ' --file ' options.github_binary{1} ' -R']);

