function fun_check_n_makefolder(fpath)

% a function to check if a (fullpath) folder exist, if no, then create a
% new one.
% by d.adytia (didit@labmath-indonesia.org)
% Version 2015-05-18

% INPUT :
% fpath = full-path name of the folder to be checked
% OUTPUT :

if ~isequal(exist(fpath,'dir'),7) % if not exist, then create it
    mkdir(fpath);
end

end