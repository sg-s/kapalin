% static method of the env method
function create(varargin)

% options and defaults
options.name = '';
options.url = '';
options.file = '';

if nargout && ~nargin 
	varargout{1} = options;
    return
end

% validate and accept options
for ii = 1:2:length(varargin)-1
    temp = varargin{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options.(temp) = varargin{ii+1};
    	end
    end
end

assert(~isempty(options.name),'No name specified')

% in any case, start from a brand new factory install
kapalin_path = fileparts(fileparts(which('env')));
restoredefaultpath
addpath(kapalin_path)
savepath;

% save this path to the env file 
env.save(options.name)