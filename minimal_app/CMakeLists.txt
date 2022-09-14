cmake_minimum_required(VERSION 3.10)

project(app)

add_executable(app main.c)

target_include_directories(app PUBLIC
    "../platforms/libunimrcp-client/include"
    "../libs/mrcp-client/include"
    "../libs/mrcp-signaling/include"
    "../libs/mrcp/include"
    "../libs/apr-toolkit/include"
    "../libs/mrcpv2-transport/include"
    "/usr/local/apr/include/apr-1"
    )

target_link_libraries(app PUBLIC
   "/home/takeshi/work/src/git/unimrcp/libs/apr-toolkit/.libs/libaprtoolkit.a"
   "/usr/local/apr/lib/libaprutil-1.so"
   "/usr/local/apr/lib/libapr-1.so"
   )
