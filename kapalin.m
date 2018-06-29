% kapalin:
% automated build system and tests for MATLAB

classdef kapalin

properties

end % end props

methods

end % end normal methods


methods (Static)
	

	function init()

		assert(~ispc,'kapalin cannot run on a windows computer')

		cd('~')

		% wipe all kapalin paths from the path
		disp('Cleaning up path...')
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
		disp('kapalin folder clean, ready to proceed.')

		
	end

	% get git repo from url
	function [base_name, options] = get(url)
		fprintf('\n')
		disp(url)
		base_name = url(max(strfind(url,'/'))+1:end);
		assert(length(base_name) > 0,'base_name of repo could not be determined')
		cd('~/.kapalin')
		try
			rmdir(base_name,'s')
		catch
		end
		mkdir(base_name)
		disp('Attempting to download repo...')
		[s,m]=system(['git clone ' url]);
		if s > 0
			disp('FAILED. Will try Github...')
			% attempt to fix url
			url = ['https://github.com/' url];
			[s,m]=system(['git clone --depth 1 ' url]);
		end
		assert(s == 0,'Failed to get this repo')

		% add all paths to matlab path
		disp('Adding repo to path...')
		all_paths = strsplit(genpath(['~/.kapalin/' base_name]),pathsep);
		for i = 1:length(all_paths)
			if any(strfind(all_paths{i},'.git'))
				continue
			end
			addpath(all_paths{i})
		end
		savepath

		disp('DONE!')
		disp('Inspecting repo...')

		if exist(['~/.kapalin/' base_name '/kapalin.json'])~=2
			disp('No kapalin.json found, assuming that this is a dependency')
			return
		end

		options = jsondecode(fileread(['~/.kapalin/' base_name '/kapalin.json']));

		disp('Installing dependencies...')

		for i = 1:length(options.deps)
			kapalin.get(options.deps{i});
		end


		disp('Switching to dev branch...')
		cd(['~/.kapalin/' base_name])

		[s,m]=system(['git checkout ' options.dev_branch]);
		assert(s==0,'[FATAL] Error in switching to dev branch.')

	end

	% test a repo from a url
	function results = test(repo_url)

		kapalin.init();
		[base_name, options] = kapalin.get(repo_url);

		repo_dir = ['~/.kapalin/' base_name];
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

		if n_fail > 0 
			disp('At least one test failed. [ABORT]')
			return

		end

		disp('All tests passed.')

		disp('Updating test badge...')
		badge_url = kapalin.makeTestBadge(results);


		lines = strsplit(fileread(['~/.kapalin/' base_name '/README.md']),'\n','CollapseDelimiters',false);
		lines = kapalin.wipeAllBadges(lines);

		% Will merge into stable branch')
		[s,m]=system(['git checkout ' options.stable_branch]);
		[s,m]=system(['git merge ' options.dev_branch]);
		keyboard
		assert(s==0,'[FATAL] Error merging into stable branch.')

		
		

	end


	function lines = wipeAllBadges(lines)

		keyboard


	end


	function badge_url = makeTestBadge(results)

		badge_url_pass = 'https://img.shields.io/badge/OS-n_pass / n_total-brightgreen.svg';
		badge_url_fail = 'https://img.shields.io/badge/OS-n_pass / n_total-red.svg';

		if results.n_fail > 0
			badge_url = badge_url_fail;
		else
			badge_url = badge_url_pass;
		end

		badge_url = strrep(badge_url,'OS',results.os_version);
		badge_url = strrep(badge_url,'n_pass',mat2str(results.n_pass));
		badge_url = strrep(badge_url,'n_total',mat2str(results.n_fail+results.n_pass));


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