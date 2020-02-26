function varargout = list()

p = getpref('kapalinenv');

if isempty(p)
	disp('No environments configured.')
	return
end




kapalin_path = (fileparts(which('env.save')));
allfiles = dir([kapalin_path filesep 'env_*.m']);
env_names = {};

current_env = getpref('kapalinenv','current_env');

for i = 1:length(allfiles)

	if nargout == 1 
		 env_names{end+1} = allfiles(i).name(5:end-2);
	end

	if nargout == 2 && strcmp(current_env,allfiles(i).name(5:end-2))
		 varargout{2} = allfiles(i).name(5:end-2);
	end

	if ~nargout
		fprintf('\n ')
		if strcmp(current_env,allfiles(i).name(5:end-2))
			fprintf('*')
		end
		fprintf(allfiles(i).name(5:end-2))
	end
	
end


if nargout == 1
	varargout{1} = env_names;
end

if ~nargout
	fprintf('\n')
end



