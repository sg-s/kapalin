% run kapalin.build in the project
% directory to build the toolbox

function build()


disp('[kapalin] Build script starting...')

options = jsondecode(fileread('kapalin.json'));
options.repo_dir = pwd;



[e,o] = system('git rev-parse HEAD');

load([options.repo_dir filesep 'last_build.kapalin'],'-mat')

if strcmp(o,last_build)
	% hashes match, don't build or test
	last_build = o;
	ok = true;

else
	% hashes don't match

	kapalin.new(options);

	kapalin.copy(options);

	kapalin.obfuscateCode(options);

	kapalin.copyExternalCode(options);

	kapalin.package(options);

	% test the toolbox in a clean environment
	ok = kapalin.testToolbox(options);

end

if ok

	save([options.repo_dir filesep 'last_build.kapalin'],'last_build')

	disp('All OK, proceeding to upload...')
	kapalin.upload(options)
end

