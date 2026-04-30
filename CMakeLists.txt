cmake_minimum_required(VERSION 4.3)

project(jumpnbump
    VERSION 1.8.0
    HOMEPAGE_URL https://gitlab.com/LibreGames/jumpnbump
    DESCRIPTION "Jump 'n Bump, play cute bunnies jumping on each other's heads."
    LANGUAGES C
)

# build options

option(BUILD_JUMPNBUMP "Build jumpnbump app." ON)
# if using valgrind, set BUILD_WITH_ASAN to OFF
option(BUILD_WITH_ASAN "Build with ASAN" OFF)

# packing tools
add_subdirectory(modify)

# pack data files
add_subdirectory(data)

# library jnb_sdl
add_subdirectory(sdl)

# jumpnbump target

set(target jumpnbump)

add_executable(${target})
target_compile_features(${target} PRIVATE cxx_std_26)
target_sources(${target} PRIVATE
    main.c

    filter.c
    menu.c
    network.c
)
target_compile_options(${target} PUBLIC
    -Dstricmp=strcasecmp
    -Dstrnicmp=strncasecmp
    -DNDEBUG
    -DUSE_SDL
    -DUSE_NET
    -DZLIB_SUPPORT
    -DBZLIB_SUPPORT
)
target_link_libraries(${target} PRIVATE jnb_sdl)
# add_dependencies(${target} generate_dat)
# add_dependencies(${target} jumpbump.dat)

# dependencies

# find_package(SDL2 CONFIG REQUIRED)
# target_link_libraries(${target} PRIVATE SDL2::SDL2)


find_package(SDL2 CONFIG REQUIRED)
target_link_libraries(${target} 
    PRIVATE
    $<TARGET_NAME_IF_EXISTS:SDL2::SDL2main>
    $<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static>
)

find_package(SDL2_mixer CONFIG REQUIRED)
target_link_libraries(${target} PRIVATE $<IF:$<TARGET_EXISTS:SDL2_mixer::SDL2_mixer>,SDL2_mixer::SDL2_mixer,SDL2_mixer::SDL2_mixer-static>)

find_package(SDL2_net CONFIG REQUIRED)
target_link_libraries(${target} PRIVATE $<IF:$<TARGET_EXISTS:SDL2_net::SDL2_net>,SDL2_net::SDL2_net,SDL2_net::SDL2_net-static>)

find_package(BZip2 REQUIRED)
target_link_libraries(${target} PRIVATE BZip2::BZip2)

find_package(ZLIB REQUIRED)
target_link_libraries(${target} PRIVATE ZLIB::ZLIB)

# find_package(PkgConfig REQUIRED)
# pkg_check_modules(GTK REQUIRED IMPORTED_TARGET gtk+-3.0)
# target_link_libraries(${target} PRIVATE PkgConfig::GTK)
# pkg_check_modules(GLIB REQUIRED IMPORTED_TARGET glib-2.0)
# target_link_libraries(${target} PRIVATE PkgConfig::GLIB)


add_custom_command(TARGET ${target} PRE_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_CURRENT_SOURCE_DIR}/data"
        "$<TARGET_FILE_DIR:${target}>/data/")

# sanitizer or valgrind

if(BUILD_WITH_ASAN)
target_compile_options(${target} PRIVATE -fsanitize=address)
target_link_options(${target} PRIVATE -fsanitize=address)
endif()

set(VALGRIND_DIR "$ENV{WORKSPACE_ROOT}/dev/valgrind")
add_custom_target(valgrind
    COMMAND valgrind
        --leak-check=full
        --show-leak-kinds=all
        --track-origins=yes
        -s --suppressions=${VALGRIND_DIR}/jumpnbump.valgrind.supp
        --gen-suppressions=all
        --log-file=${VALGRIND_DIR}/logs/memcheck.log
        $<TARGET_FILE:${target}>
    DEPENDS ${target}
    WORKING_DIRECTORY $<TARGET_FILE_DIR:${target}>
    COMMENT "Running jumpnbump with valgrind"
)
