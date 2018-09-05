function setUpGitHooks()
	
disp('[INFO] Setting up git hooks...')
if exist([pwd filesep 'git-hooks']) == 7
	disp('git-hooks found!')
else
	disp('No git hooks found. [STOP]')
	return
end
allfiles =  dir([pwd filesep 'git-hooks']);
for i = 1:length(allfiles)
	if strcmp(allfiles(i).name,'.')
		continue
	end
	if strcmp(allfiles(i).name,'..')
		continue
	end
	copyfile([pwd filesep 'git-hooks' filesep allfiles(i).name],'.git/hooks/')
	% make executable 
	disp(['[INFO] Enabling hook::' allfiles(i).name])
	[s,m] = system(['chmod a+x .git/hooks/' allfiles(i).name]);
	assert(s == 0, ['Could not change permissions on git hook, error was :  ' m])

end
