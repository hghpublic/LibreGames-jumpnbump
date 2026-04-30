        
# generate gobs
set(gobs
    font
    rabbit
    numbers
    objects
)

foreach(gob ${gobs})
    add_custom_command(
        OUTPUT ${gob}.gob
        COMMAND gobpack ${gob}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    add_custom_target(generate_${gob} DEPENDS ${gob}.gob)
endforeach()

# generate dat

set(GOBS "font.gob numbers.gob objects.gob rabbit.gob")
set(DATAFILES "bump.mod calib.dat death.smp fly.smp jump.mod \
jump.smp levelmap.txt level.pcx mask.pcx menu.pcx \
menumask.pcx ${GOBS} scores.mod splash.smp spring.smp")
# list(JOIN DATAFILES " " DATAFILES_STR)
# message(STATUS "DATAFILES: ${DATAFILES}")
# message(STATUS "DATAFILES_STR: ${DATAFILES_STR}")


set(PARAMS "jumpbump.dat ${DATAFILES}")
list(JOIN PARAMS " " PARAMS_STR)
add_custom_command(
    OUTPUT jumpbump.dat
    # COMMAND jnbpack -o "jumpbump.dat ${DATAFILES_STR}"
    # COMMAND jnbpack -o ${PARAMS}
    # COMMAND jnbpack -o $<JOIN:${PARAMS}," ">
    # COMMAND jnbpack -o $<JOIN:${PARAMS},>
    COMMAND jnbpack -o jumpbump.dat bump.mod calib.dat death.smp fly.smp jump.mod jump.smp levelmap.txt level.pcx mask.pcx menu.pcx menumask.pcx font.gob numbers.gob objects.gob rabbit.gob scores.mod splash.smp spring.smp
    DEPENDS generate_font generate_numbers generate_objects generate_rabbit
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    # COMMAND_EXPAND_LISTS
    # VERBATIM
)
add_custom_target(generate_dat DEPENDS jumpbump.dat)
