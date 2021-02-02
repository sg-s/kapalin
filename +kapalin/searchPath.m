


function [inpath,full_path] = searchPath(name)


arguments
	name char
end


full_path = '';

p = strsplit(path,pathsep);


rm_this1 = cellfun(@(x) any(strfind(x,userpath)),p);
rm_this2 = cellfun(@(x) any(strfind(x,matlabroot)),p);

p(rm_this1 | rm_this2) = [];

this = cellfun(@(x) any(strfind(x,name)),p);

if ~any(this)
	inpath = false;
	return
end

inpath = true;
full_path = p{find(this,1,'first')};