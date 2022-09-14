cmake_minimum_required(VERSION 3.10)

project(app)

add_executable(app main.c)

target_include_directories(app PUBLIC
    "${UNIMRCP_DIR}/platforms/libunimrcp-client/include"
    "${UNIMRCP_DIR}/libs/mrcp-client/include"
    "${UNIMRCP_DIR}/libs/mrcp-signaling/include"
    "${UNIMRCP_DIR}/libs/mrcp/include"
    "${UNIMRCP_DIR}/libs/apr-toolkit/include"
    "${UNIMRCP_DIR}/libs/mrcpv2-transport/include"
    "/usr/local/apr/include/apr-1"
    )

target_link_libraries(app PUBLIC
   "${UNIMRCP_DIR}/libs/apr-toolkit/.libs/libaprtoolkit.a"
   "/usr/local/apr/lib/libaprutil-1.so"
   "/usr/local/apr/lib/libapr-1.so"
   )
