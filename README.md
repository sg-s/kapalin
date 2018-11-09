# kapalin

automated build system and testing framework for MATLAB, with a envvironment manager


## Using the environment manager

This package contains a class called `env`, which is a fully-featured environment manager for MATLAB (like `conda`, or `virtualenv`)

### Save your current environment for use later

```matlab
env.save('default')
```

### Create a new, empty environment 

```matlab
env.create('name','testing')
% You can now install whatever you want
% here without affecting your primary
% environment
```

### Switch to that environment 

```matlab
env.activate('testing')
```

### List all available environments

```matlab
env.list
```

which will show

```matlab
*testing
default
```

Note that the asterix indicates the currently active environment. 


## Using kapalin

`kapalin` assumes the following things:

1. Your code is hosted on github
2. You are writing MATLAB code, and your ultimately want to distribute a MATLAB toolbox
3. You will host the toolbox files (`*.mltbx`) on Github as a release.
4. You have installed [github-release](https://github.com/aktau/github-release) on the computer you are testing on

