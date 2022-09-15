# unimrcp_experiments

Here we have a Dockerfile to create a container with unimrcp and swig-wrapper.

You will need to have docker and jq installed:
```
apt install docker jq
```

To build the container image:
```
./build_image.sh
```

To start the container do:
```
./start_container.sh
```

Then inside the container you can build the minimal_app by doing:

```
root@b55078f31983:/# cd ~/src/host/minimal_app

root@b55078f31983:~/src/host/minimal_app# rm CMakeCache.txt CMakeFiles/ cmake_install.cmake -fr

root@b55078f31983:~/src/host/minimal_app# cmake -D UNIMRCP_DIR=/root/src/git/unimrcp .
-- The C compiler identification is GNU 8.3.0
-- The CXX compiler identification is GNU 8.3.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /root/src/host/minimal_app

root@b55078f31983:~/src/host/minimal_app# make
Scanning dependencies of target app
[ 50%] Building C object CMakeFiles/app.dir/main.c.o
[100%] Linking C executable app
[100%] Built target app

```

And then you can run the app by doing:
```
root@b55078f31983:~/src/host/minimal_app# ./app 
OK
root@b55078f31983:~/src/host/minimal_app# 
```
