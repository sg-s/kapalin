
% test a toolbox in a clen environment
% assumes that you already have the toolbox packaged
% using kapalin.package

function ok = testToolbox(options)


arguments
	options struct
end


ok = false;


repo_dir = options.repo_dir;



original_dir = pwd;

% verify that we are currently in an environment 
assert(~isempty(env.list),'You need to first save your current environment (use env.save(''something'')')
[~,options.original_env] = env.list;
assert(~ispc,'kapalin.test() cannot run on Windows')


% configure what to do if something goes wrong
finishup = onCleanup(@() kapalin.cleanup(options));



disp('[kapalin] Switching to a new environment.')
env.create('kapalin_testing_env')


disp('[kapalin] Installing the binary...')
cd('~/.kapalin/')
options.toolbox_info = matlab.addons.toolbox.installToolbox([options.name '.mltbx']);



disp('[kapalin] Testing the binary...')
f = str2func([options.name '.run_all_tests']);
[passed,total]=f();


if passed < total
	disp('Some tests failed; aborting.')
	kapalin.cleanup(options)
	return

end


disp('[kapalin::testing] Updating binary...')
movefile(['~/.kapalin/' options.name '.mltbx'],repo_dir)


if total == passed 
	ok = true;
end


disp('[kapalin::testing] All done. Returning to original state.')
kapalin.cleanup(options)


end


