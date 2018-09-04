function save(name)

assert(ischar(name),'Env name should be a string')
name = strrep(name,'.','');
name = strrep(name,'/','');
name = strrep(name,'\','');

kapalin_path = fileparts(fileparts(which('env')));
s = savepath([kapalin_path filesep 'env_' name '.m']);

assert(s==0,'Error saving path, will not continue');