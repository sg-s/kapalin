% this function calls
% a VM and gets it to run the tests

function testUsingVM(toolbox_name,k_options)

path_to_share = getpref('kapalin','path_to_vm_share');

for i = 1:length(k_options.vm_names)

	this_vm = k_options.vm_names{i};


	% spin up the VM
	[e,o]= system(['vboxmanage startvm "' this_vm '"']);


	% copy the toolbox into the share folder
	copyfile(['~/.kapalin/' toolbox_name],path_to_share)

	keyboard



	% shut down  the VM
	[e,o]= system(['vboxmanage controlvm "' this_vm '" savestate']);
end


vboxmanage controlvm "ubuntu" suspend


% wait for the kapalin daemon inside the VM to start