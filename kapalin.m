% kapalin:
% automated build system and tests for MATLAB

classdef kapalin

properties

end % end props

methods

end % end normal methods


methods (Static)
	

	function init()
		cd('~')

		% wipe all kapalin paths from the path
		p = path;
		p = strsplit(p,pathsep);
		for i = 1:length(p)
			if any(strfind(p{i},'.kapalin'))
				rmpath(p{i})
			end
		end

		if ~exist('~/.kapalin','dir')
			mkdir('~/.kapalin')
		else
			rmdir('~/.kapalin','s')
			mkdir('~/.kapalin')
		end

		
	end

	% get git repo from url
	function get(url)
		base_name = url(max(strfind(url,'/'))+1:end);
		assert(length(base_name) > 0,'base_name of repo could not be determined')
		cd('~/.kapalin')
		try
			rmdir(base_name,'s')
		catch
		end
		mkdir(base_name)
		[s,m]=system(['git clone ' url]);
		if s > 0
			% attempt to fix url
			url = ['https://github.com/' url];
			[s,m]=system(['git clone --depth 1 ' url]);
		end
		assert(s == 0,'Failed to get this repo')

		% add all paths to matlab path
		all_paths = strsplit(genpath(['~/.kapalin/' base_name]),pathsep);
		for i = 1:length(all_paths)
			if any(strfind(all_paths{i},'.git'))
				continue
			end
			addpath(all_paths{i})
		end
		savepath
	end

	% test
	function results = test(repo)

		all_repos = dir('~/.kapalin');

		assert(any(strcmp({all_repos.name},'xolotl')),'Unknown repo')

		repo_dir = ['~/.kapalin/' repo];
		all_files = kapalin.getAllFiles(repo_dir);

		n_pass = 0;
		n_fail = 0;

		for i = 1:length(all_files)
			[~,name,ext] = fileparts(all_files{i});
			if isempty(ext)
				continue
			end
			if ~strcmp(ext,'.m')
				continue
			end
			if length(name) < 5
				continue
			end
			if strcmp(name(1:4),'test')
				try
					evalin('base',name)

					n_pass = n_pass + 1;
					disp(['[PASSED] ' name])

				catch
					n_fail = n_fail + 1;
					disp(['[FAILED] ' name])

				end
				evalin('base','clearvars')
				evalin('base','close all')
			end
		
		end
		disp([mat2str(n_fail) ' tests failed'])
		disp([mat2str(n_pass) ' tests passed'])

		if ismac
			[~,m] = system('sw_vers | grep ProductVersion');
			m = strtrim(strrep(m,'ProductVersion:',''));
			os_version = ['macOS_' m];
		else
			% assume GNU/Linux
			os_version = 'GNU_Linux';
		end

		results.matlab_version = version;
		results.os_version = os_version;
		results.n_fail = n_fail;
		results.n_pass = n_pass;
		results.timestamp = datestr(now);

	end


	function fileList = getAllFiles(dirName)
		dirData = dir(dirName);      % Get the data for the current directory
		dirIndex = [dirData.isdir];  % Find the index for directories
		fileList = {dirData(~dirIndex).name}';  

		if ~isempty(fileList)
			fileList = cellfun(@(x) fullfile(dirName,x),fileList,'UniformOutput',false);
		end
		subDirs = {dirData(dirIndex).name};  % Get a list of the subdirectories
		validIndex = ~ismember(subDirs,{'.','..'});  % Find index of subdirectories
		                                             %   that are not '.' or '..'
		for iDir = find(validIndex)                  % Loop over valid subdirectories
			nextDir = fullfile(dirName,subDirs{iDir});    % Get the subdirectory path
			fileList = [fileList; getAllFiles(nextDir)];  % Recursively call getAllFiles
		end


	end


end % end static methods

end % end classdef