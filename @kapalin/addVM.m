function addVM(vm_name)

if nargin == 0
	vm_name = input('Enter the name of a VM: \n','s');


end


try getpref('kapalin','vm_names');
	vm_names = getpref('kapalin','vm_names');
	vm_names = [vm_names; vm_name];
	setpref('kapalin','vm_names',vm_names);

catch
	setpref('kapalin','vm_names',{vm_name});
end