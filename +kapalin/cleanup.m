		
% cleanup function

function cleanup(options)

disp('[kapalin] Cleaning up...')


if ~isempty(options.name)
	matlab.addons.toolbox.uninstallToolbox(options.name);
end
cd(options.repo_dir)
env.activate(options.original_env)
