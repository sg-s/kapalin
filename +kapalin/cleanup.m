		
% cleanup function

function cleanup(options)

disp('[kapalin] Cleaning up...')


if ~isempty(options.name)

	toolboxes = matlab.addons.toolbox.installedToolboxes;

	% go somewhere safe
	cd(userpath)

	% remove all toolboxes with "toolbox_name" in it
	for i = 1:length(toolboxes)
		if strcmp(toolboxes(i).Name,options.name)
			matlab.addons.toolbox.uninstallToolbox(toolboxes(i));
		end
	end

end
cd(options.repo_dir)
env.activate(options.original_env)
