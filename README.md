# LearningNetworkNotes

Supposedly, you are working on Ubuntu 12.04 or newer version!

Firstly, to download estuary with following commands:

$mkdir -p ~/bin; sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get install -y wget git
$wget -c http://download.open-estuary.org/AllDownloads/DownloadsEstuary/utils/repo -O ~/bin/repo
$chmod a+x ~/bin/repo; echo 'export PATH=~/bin:$PATH' >> ~/.bashrc; export PATH=~/bin:$PATH; mkdir -p ~/open-estuary; cd ~/open-estuary
$repo abandon master
$repo forall -c git reset --hard
$repo init -u "https://github.com/open-estuary/estuary.git" -b refs/tags/v2.3-rc1 --no-repo-verify --repo-url=git://android.git.linaro.org/tools/repo 
$false; while [ $? -ne 0 ]; do repo sync; done
Secondly, you can build the whole project with the default config file as following command:

$sudo ./estuary/build.sh --file=./estuary/estuarycfg.json --builddir=./workspace
or build specified platform and distribution such as:

$sudo ./estuary/build.sh -p QEMU -d Ubuntu
 To try more different platform or distributions based on estuary, please get help information about build.sh as follow:

 $./estuary/build.sh -h
 More detail user guide about this project, please refer to Estuary User Manual.

 If you just want to quickly try it with binaries, please refer to our binary Download Page to get the latest binaries and documentations for each corresponding boards.

 Accessing from China: ftp://117.78.41.188

 Accessing from outside-China: http://download.open-estuary.org/
