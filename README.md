Meikade
=======

Meikade is a persian poem application.

## How to Build

### Dependencies

First thing you must install before the build an application, is dependecies. So for Meikade it's like another applications. Meikade depended on the Qt >= 5.9, QtAseman and AsemanFalcon.

#### Prepare

Before Start building you must setup your Environment.

- If you want to build it for Android, You need to install android-ndk and android-sdk.
- If you want to build it for iOS, You need to install XCode and XCode commandline tools.
- If you want to build it for Ubuntu and Other Linux, You need  to install gcc, g++ and make command.

And for all above choice you need to install git on the platform. So for example if you want to build in on the ubuntu, You need to setup your environment using below command:

```bash
sudo apt-get install git g++ gcc
```

#### Qt
You could download and install Qt from their website [qt.io](). Also If you want to build meikade on the ubuntu, you could install Qt from the official reposetories using below commands:

```bash
sudo apt-get install qtbase5-dev qt5-default "qml-module-qt*"
```

####QtAseman

QtAseman is many tools that Aseman team uses on their project. So It's contains many stable and great tools that developed and used on the hug number of projects. Meikade is depended on the QtAseman and you could build it using below commands:

```bash
git clone https://github.com/Aseman-Land/QtAseman.git
cd QtAseman
mkdir build && cd build
qmake -r ..
make
make install
```

And if you want to use our launchpad repository you can install QtAseman using below commands:

```bash
sudo apt-add-repository ppa:aseman/qt-modules
sudo apt-get update
sudo apt-get install qt5aseman qt5aseman-dev
```

#### Falcon

Falcon helps meikade to connect to the server and repository. So you can build it using below commands:

```bash
git clone https://github.com/Aseman-Land/Falcon.git
cd Falcon
mkdir build && cd build
qmake -r ..
make
make install
```

### Build Meikade

Now after build all dependecies, It's easy to build meikade. Just clone it and build it:

```bash
git clone https://github.com/Aseman-Land/Meikade.git
cd Meikade
mkdir build && cd build
qmake -r ..
make
```

and after build it, run it from build directory :)