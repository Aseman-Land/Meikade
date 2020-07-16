Meikade
=======

Meikade is a poetry application for mobile and desktop devices and supports iOS, Android, Linux, Windows and macOS. It's open-source and released under the GPLv3 license.

## How to Build

### Dependencies

Before start building process you must install Meikade's dependencies like any other application.

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

#### QtAseman

Meikade is depended on the QtAseman. So you could build it using below commands:

```bash
git clone https://github.com/Aseman-Land/QtAseman.git
cd QtAseman
mkdir build && cd build
qmake -r ..
make
make install
```

And if you want to use our launchpad repository you can install [QtAseman](https://github.com/Aseman-Land/QtAseman) using below commands:

```bash
sudo apt-add-repository ppa:aseman/qt-modules
sudo apt-get update
sudo apt-get install qt5aseman qt5aseman-dev
```

### Build Meikade

It's easy to build meikade. Just clone it and build it:

```bash
git clone https://github.com/Aseman-Land/Meikade.git
cd Meikade
mkdir build && cd build
qmake -r ..
make
```

and after build it, run it from build directory :)
