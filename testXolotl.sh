#! /bin/bash

# Tests xolotl on several different virtual machines. Each machine needs matlab,
# xolotl, and its dependencies installed.
# also needs gh-badges
# sudo npm install -g gh-badges

# create badges
mkdir -p ~/.badges;
badge ubuntu passed :green .png > ~/.badges/ubuntuPassed.png;
badge ubuntu failed :red .png > ~/.badges/ubuntuFailed.png;
badge macOS passed :green .png > ~/.badges/macOSPassed.png;
badge macOS failed :red .png > ~/.badges/macOSFailed.png;
badge debian passed :green .png > ~/.badges/debianPassed.png;
badge debian failed :red .png > ~/.badges/debianFailed.png;
badge windows passed :green .png > ~/.badges/windowsPassed.png;
badge windows failed :red .png > ~/.badges/windowsFailed.png;

# start VirtualBox: macOS
VBoxManage startvm "xolotl macOS" --type headless;
# start matlab & test xolotl
matlab -nojvm -nodisplay -nosplash -r "testXolotl.m; exit;";

# stop VirtualBox: Ubuntu
VBoxManage controlvm "xolotl Ubuntu" poweroff --type headless;
# start VirtualBox: Ubuntu
VBoxManage startvm "xolotl Ubuntu" --type headless;

# start matlab & test xolotl
matlab -nojvm -nodisplay -nosplash -r "testXolotl.m; exit;";
# stop VirtualBox: Ubuntu
VBoxManage controlvm "xolotl Ubuntu" poweroff --type headless;

# start VirtualBox: Debian
VBoxManage startvm "xolotl Debian" --type headless;
# start matlab & test xolotl
matlab -nojvm -nodisplay -nosplash -r "testXolotl.m; exit;";
# stop VirtualBox: Debian
VBoxManage controlvm "xolotl Debian" poweroff --type headless;


# start VirtualBox: Windows
VBoxManage startvm "xolotl Windows" --type headless;

# start matlab & test xolotl
# cd($MATLAB_ROOT)
matlab -nojvm -nodisplay -nosplash -r "testXolotl.m; exit;";
# stop VirtualBox: Windows
VBoxManage controlvm "xolotl Windows" poweroff --type headless;
