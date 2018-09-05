


function is_even = checkIfBranchesAreEven(options)
% compares the dev and master branches

disp('[INFO] Comparing dev and master branches...')

[e,o] = system(['git log --left-right --graph --cherry-pick --oneline ' options.dev_branch '...' options.stable_branch  ' >> log.diff']);
assert(e ==0,'Something went wrong comparing branches')

% now read log.diff

if length(strsplit(fileread('log.diff'),'\n','CollapseDelimiters',false)) == 1
	is_even = true;
else
	is_even = false;
end

delete('log.diff')


