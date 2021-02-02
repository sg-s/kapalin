% run kapalin.build in the project
% directory to build the toolbox

function build()


options = jsondecode(fileread('kapalin.json'));


kapalin.new(options.name);

kapalin.obfuscateCode(options);

kapalin.copyDeps(options);

kapalin.package(options);