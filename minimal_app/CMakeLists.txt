cmake_minimum_required(VERSION 3.10)

project(app)

add_executable(app main.c)

target_include_directories(app PUBLIC
    "~/src/unimrcp-deps-1.6.0/libs/apr/include"
    "~/src/git/unimrcp/platforms/libunimrcp-client/include"
    "~/src/git/unimrcp/libs/mrcp-client/include"
    "~/src/git/unimrcp/libs/mrcp-signaling/include"
    "~/src/git/unimrcp/libs/mrcp/include"
    "~/src/git/unimrcp/libs/apr-toolkit/include"
    "~/src/git/unimrcp/libs/mrcpv2-transport/include"
    "/usr/git/local/apr/include/apr-1"
    "/usr/git/local/unimrcp/include"
    )

# strangely, "~/src" fails in targeet_link_library so we must pass the USER

target_link_libraries(app PUBLIC
   "/home/${USER}/src/git/unimrcp/libs/apr-toolkit/.libs/libaprtoolkit.a"
   "/usr/local/apr/lib/libaprutil-1.so"
   "/usr/local/apr/lib/libapr-1.so"
   )
