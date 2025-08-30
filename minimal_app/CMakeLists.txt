cmake_minimum_required(VERSION 3.10)

project(app)

add_executable(app main.c)

target_include_directories(app PUBLIC
    "/usr/local/src/git/unimrcp/platforms/libunimrcp-client/include"
    "/usr/local/src/git/unimrcp/libs/mrcp-client/include"
    "/usr/local/src/git/unimrcp/libs/mrcp-signaling/include"
    "/usr/lcoal/src/git/unimrcp/libs/mrcp/include"
    "/usr/local/src/git/unimrcp/libs/apr-toolkit/include"
    "/usr/local/src/git/unimrcp/libs/mrcpv2-transport/include"
    "/usr/local/apr/include/apr-1"
    "/usr/git/local/apr/include/apr-1"
    "/usr/lcoal/src/git/unimrcp/include"
    )

# strangely, "~/src" fails in targeet_link_library so we must pass the USER

target_link_libraries(app PUBLIC
   "/home/${USER}/src/git/unimrcp/libs/apr-toolkit/.libs/libaprtoolkit.a"
   "/usr/local/apr/lib/libaprutil-1.so"
   "/usr/local/apr/lib/libapr-1.so"
   )
