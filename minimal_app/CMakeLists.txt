cmake_minimum_required(VERSION 3.10)

project(app)

add_executable(app main.c)

target_include_directories(app PUBLIC
    "/root/tmp/unimrcp/platforms/libunimrcp-client/include"
    "/root/tmp/unimrcp/libs/mrcp-client/include"
    "/root/tmp/unimrcp/libs/mrcp-signaling/include"
    "/root/tmp/unimrcp/libs/mrcp/include"
    "/root/tmp/unimrcp/libs/apr-toolkit/include"
    "/root/tmp/unimrcp/libs/mrcpv2-transport/include"
    "/usr/local/apr/include/apr-1"
    "/usr/git/local/apr/include/apr-1"
    "/root/tmp/unimrcp/include"
    )

# strangely, "~/src" fails in targeet_link_library so we must pass the USER

target_link_libraries(app PUBLIC
   "/home/${USER}/src/git/unimrcp/libs/apr-toolkit/.libs/libaprtoolkit.a"
   "/usr/local/apr/lib/libaprutil-1.so"
   "/usr/local/apr/lib/libapr-1.so"
   )
