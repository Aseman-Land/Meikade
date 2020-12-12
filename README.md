![Meikade-icon](https://raw.githubusercontent.com/Aseman-Land/Meikade/master/configurations/ios/icons/Icon-Small%402x.png)

Meikade
=======

Meikade is a collection of Persian poetry.
It is avaiable on iOS, Android, Windows, macOS and Linux.

---

## 📥️ Download Meikade

| Platform      | Download | Availability|
| ------------- |:------------------------------------------------------------------------------------:|:---:|
| iOS           | [AppStore](https://apps.apple.com/us/app/meikade-app/id1543587891#?platform=iphone)  | ✔️ |
| Android       | [PlayStore](https://play.google.com/store/apps/details?id=org.nilegroup.Meikade)     | ✔️ |
| Windows       | [exe File]()  | ⏳️ |
| macOS         | [DMG file]()  | ⏳️ |
| Linux         | [Deb Package]()  | ⏳️ |

---

## ⚒️ Build Meikade

### Prepare the Prerequisites
Before you start the build process, you have to install/resolve Meikade's dependencies like any other application.

#### Set up your Build Environment

In order to start the build process, you have to set up the environment for the respective platforms.

- 📱️ **Android**: install Android NDK and Android SDK.
- 🍎️ **iOS & macOS**: install XCode and XCode command-line tools.
- 🐧️ **Linux (esp. Ubuntu & other Debian-based distros)**: install gcc, g++ and make command.

#### Install the Dependencies

##### Git
For all the above mentioned platforms, you need to install "git". So for example if you want to build it for Ubuntu, You need to setup your environment using the below command:

```bash
sudo apt-get install git g++ gcc
```

##### Qt
You can download and install Qt from their website [qt.io](). Also If you want to build Meikade on Ubuntu (or any other Debian-based distro), you could install Qt from the official repositories using the commands below:

```bash
sudo apt-get install qtbase5-dev qt5-default "qml-module-qt*"
```

##### QtAseman

Meikade is dependant on the QtAseman. So you can build it using the commands below:

```bash
git clone https://github.com/Aseman-Land/QtAseman.git
cd QtAseman
mkdir build && cd build
qmake -r ..
make
make install
```

And if you want to use our launchpad repository you can install [QtAseman](https://github.com/Aseman-Land/QtAseman) using the commands below:

```bash
sudo apt-add-repository ppa:aseman/qt-modules
sudo apt-get update
sudo apt-get install qt5aseman qt5aseman-dev
```

### Build Meikade

Now that you have installed/resolved all needed dependencies It should be pretty easy to build Meikade. Just clone this repository and build it with the following command:

```bash
git clone https://github.com/Aseman-Land/Meikade.git
cd Meikade
mkdir build && cd build
qmake -r ..
make
```
and after building it, execute it from the build directory. That's it you did it! :)

*Note* that to disable subscription feature on your build, just pass `CONFIG+=disable-subscription` config to qmake command.

---
Meikade is built using C++ & Qt.

[![GitHub license](https://img.shields.io/github/license/Aseman-Land/Meikade?style=for-the-badge)](https://github.com/Aseman-Land/Meikade/blob/master/LICENSE)
