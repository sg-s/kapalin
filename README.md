# kapalin

automated build system and testing framework for MATLAB

## Assumptions

1. Your codebase is in MATLAB
2. Your code is hosted on git repositories online 
3. Your testing machine runs MATLAB
4. Your testing machine can connect to the internet, and can read and write to the .git repository that it is testing 
5. The repo being tested has a "master" branch and a "dev" branch (but they can be called whatever they want)
6. Your repo has a readme file called "README.md" on the root 
7. That the 2nd line of your README is blank/can be overwritten by status badges