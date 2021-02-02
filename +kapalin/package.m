function package(repo_dir)


original_dir = pwd;


[~,project_name]=fileparts(repo_dir);
temp_folder = ['~/.kapalin/' project_name]; 

prj_name = dir([temp_folder filesep '*.prj']);

assert(length(prj_name) == 1, 'Could not determine project name')


% modify the prj file to reflect today's date
prj_text = fileread(fullfile(prj_name.folder,prj_name.name));
old_str = prj_text(strfind(prj_text,'<param.version>'):strfind(prj_text,'</param.version>'));
N = datevec(now);
N = [mat2str(N(1)-2000) '.' mat2str(N(2)) '.' mat2str(N(3))];
new_str = ['<param.version>' N '<'];
prj_text = strrep(prj_text,old_str,new_str);

f = fopen([prj_name.folder filesep prj_name.name],'w');
fprintf(f,prj_text);
fclose(f)




toolbox_name = strrep(prj_name.name,'prj','mltbx');


cd('~')
home_dir = pwd;

disp('[kapalin] Making toolbox in ~/.kapalin/')

cd(prj_name.folder)

matlab.addons.toolbox.packageToolbox(prj_name.name,[home_dir '/.kapalin/' toolbox_name])

% copy the package back to the repo_dir
copyfile([home_dir '/.kapalin/' toolbox_name],[repo_dir filesep toolbox_name])


cd(original_dir)