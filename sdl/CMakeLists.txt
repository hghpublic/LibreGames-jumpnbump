set(target jnb_sdl)
add_library(${target} STATIC)
target_compile_features(${target} PRIVATE cxx_std_26)
target_compile_options(${target} PUBLIC
    -Dstricmp=strcasecmp
    -Dstrnicmp=strncasecmp
    -DNDEBUG
    -DUSE_SDL
    -DUSE_NET
    -DZLIB_SUPPORT
    -DBZLIB_SUPPORT
)
target_sources(${target} PRIVATE
    gfx.c
    input.c
    interrpt.c
    sound.c
    # ${PROJECT_SOURCE_DIR}/filter.c
)
target_include_directories(${target} PRIVATE ${PROJECT_SOURCE_DIR})
# dependencies

# find_package(SDL2 CONFIG REQUIRED)
# target_link_libraries(${target} PRIVATE SDL2::SDL2)


find_package(SDL2 CONFIG REQUIRED)
target_link_libraries(${target} 
    PRIVATE
    $<TARGET_NAME_IF_EXISTS:SDL2::SDL2main>
    $<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static>
)
