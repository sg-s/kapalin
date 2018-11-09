% kapalin:
% automated build system and tests for MATLAB

classdef kapalin

methods





end % end normal methods


methods (Static)
	
	add(url);
	results = test(varargin);
	kapalind(~,~);

	uploadToolbox2Github(repo_dir);

	testUsingVM(toolbox_name,k_options)

	init()

	addVM(vm_name);

	start()
	stop()


	function self = kapalin()



		kapalin.init()

		options = getpref('kapalin');
		disp(['kapalin running in mode: ' options.mode])
		disp(['path_to_vm_share: ' options.path_to_vm_share])

		if strcmp(options.mode,'VM')
			return
		end
		disp('The following VMs are configured:')
		for i = 1:length(options.vm_names)
			disp(options.vm_names{i})
		end

	end





end % end static methods

end % end classdef