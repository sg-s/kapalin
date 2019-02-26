function configureVBoxManagePath()


vboxmanage_path = input('Enter the full path to vboxmanage: \n','s');

[e,o] = system(vboxmanage_path);

if e == 0
	setpref('kapalin','vboxmanage_path',vboxmanage_path);
else
	error('The path you entered did not resolve correctly.')
end