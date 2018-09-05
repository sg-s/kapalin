% kapalin:
% automated build system and tests for MATLAB

classdef kapalin

methods





end % end normal methods


methods (Static)
	
	add(url);
	test(url);
	[base_name, options] = get(url);
	kapalind(~,~);
	badge_url = makeTestBadge(results);

	function self = kapalin()
		% check if there are any timers

		t = timerfind;
		for i = 1:length(t)
			if any(strfind(func2str(t(i).TimerFcn),'kapalin'))
				disp('[INFO] kapalin is running in the background')
			end
		end

		% which repos are we supposed to test? 
		load([fileparts(which(mfilename)) filesep 'repos.mat'])
		if length(repos) > 0
			disp('[INFO] kapalin will test the following repos:')
			disp('-------------------------------------')
			for i = 1:length(repos)
				disp(repos{i})
			end
		else
			disp('[INFO] kapalin has no repo to test')
		end

	end



end % end static methods

end % end classdef