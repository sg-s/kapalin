
% once we have a .git repo cloned,
% this method checks out a branch that
% is the "dev" version. this branch
% may not exist locally, and may need to be
% fetched from the remote 

function checkoutDevBranch(options)

disp('[INFO] Checking out dev branch...')

% first, we need to figure out where it is
[s,m] = system('git branch -a');
assert(s == 0, ['Failed to get all remote branches, error was : ' m])
remote_branches = strsplit(m,'\n');
remote_branch = '';
for i = 1:length(remote_branches)
	try
	if strcmp(remote_branches{i}(end-length(options.dev_branch)+1:end),options.dev_branch)
		remote_branch = remote_branches{i};
	end
	catch
	end
end
assert(~isempty(remote_branch),'Could not determine remote branch corresponding to dev_branch')
[s,m] = system(['git checkout -b ' options.dev_branch ' ' remote_branch]);
assert(s == 0,['[FATAL] Failed to switch to dev branch, error was :' m])


