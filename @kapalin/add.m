

function add(repo_url)

if exist([fileparts(which('kapalin')) filesep 'repos.mat'],'file')
	load([fileparts(which('kapalin')) filesep 'repos.mat'],'-mat')
else
	repos = {};
end
repos = [repos; repo_url];
repos = unique(repos);
disp('[INFO] The following repos will be tested...')
disp(repos)
save([fileparts(which('kapalin')) filesep 'repos.mat'],'repos')
