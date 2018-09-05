function varargout = list()

kapalin_path = fileparts(fileparts(which('env')));


if exist([kapalin_path, filesep, 'current_env.mat'],'file') ~= 2
	disp('No environments saved')
	if nargout == 1
		varargout{1} = false;
	end
	return
end
load([kapalin_path, filesep, 'current_env.mat'],'name')


if nargout == 1
	varargout{1} = true;
	return
end


allfiles = dir([kapalin_path filesep 'env_*.m']);
for i = 1:length(allfiles)

	if nargout == 2 & strcmp(name,allfiles(i).name(5:end-2))
		varargout{2} = allfiles(i).name(5:end-2);
	end

	if ~nargout
		fprintf('\n ')
		if strcmp(name,allfiles(i).name(5:end-2))
			fprintf('*')
		end
		fprintf(allfiles(i).name(5:end-2))
	end
	
end
fprintf('\n')


