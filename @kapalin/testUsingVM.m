% this function calls
% a VM and gets it to run the tests

function testUsingVM(toolbox_path)

k_options = getpref('kapalin');

path_to_share = k_options.path_to_vm_share;

for i = 1:length(k_options.vm_names)

	this_vm = k_options.vm_names{i};


	% copy the toolbox into the share folder
	copyfile(toolbox_path,path_to_share)

	

	% spin up the VM
	disp(['Spinning up VM: ' this_vm])
	[e,o]= system([k_options.vboxmanage_path ' startvm "' this_vm '"']);


	% wait for the kapalin daemon inside the VM to start
	keyboard
	



	disp(['Shutting down VM: ' this_vm])
	[e,o]= system([k_options.vboxmanage_path ' controlvm "' this_vm '" savestate']);
end



