


function init()


try getpref('kapalin','path_to_vm_share');
catch
	str = input('Enter the path to the VM share:  \n','s');
	setpref('kapalin','path_to_vm_share',str)

end

try getpref('kapalin','mode');
catch
	str = input('Is kapalin running within a VM (y/n)?  \n','s');
	switch str 
	case 'y'
		disp('Setting kapalin to VM mode')
		setpref('kapalin','mode','VM')
	otherwise
		disp('Setting kapalin to default mode')
		setpref('kapalin','mode','default')
	end
end


if strcmp(getpref('kapalin','mode'),'default')

	try getpref('kapalin','vm_names');
	catch
		kapalin.addVM()

	end

end