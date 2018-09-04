function list()

kapalin_path = fileparts(fileparts(which('env')));


load([kapalin_path, filesep, 'current_env.mat'],'name')

allfiles = dir([kapalin_path filesep 'env_*.m']);
for i = 1:length(allfiles)

	fprintf('\n ')
	if strcmp(name,allfiles(i).name(5:end-2))
		fprintf('*')
	end
	fprintf(allfiles(i).name(5:end-2))
	
end
fprintf('\n')