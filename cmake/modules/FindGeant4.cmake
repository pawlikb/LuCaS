# - Try to find GEANT4
#
# Geant4_DIR if needed must be set before use of this macro
#
# Once done this will define
#
#  GEANT4_FOUND - system has GEANT4
#  GEANT4_INCLUDE_DIR - the GEANT4 include directory
#  GEANT4_LIBRARIES - The libraries needed to use GEANT4
#  GEANT4_DEFINITIONS - Compiler switches required for using GEANT4
#
MESSAGE(STATUS "Looking for GEANT4...")

	IF( NOT GEANT4_DIR )
           FIND_PROGRAM( GEANT4_CONFIG_EXECUTABLE geant4-config )
	ELSE()
	   SET( GEANT4_CONFIG_EXECUTABLE ${GEANT4_DIR}/bin/geant4-config )
	ENDIF()

IF ( GEANT4_CONFIG_EXECUTABLE-NOTFOUND )
       FIND_PROGRAM(GEANT4_CONFIG_EXECUTABLE geant4-config PATHS ${GEANT4_DIR}/bin NO_DEFAULT_PATH )
ENDIF()

IF( GEANT4_CONFIG_EXECUTABLE )
    # get GEANT4 prefix from geant4-config output
    EXECUTE_PROCESS( COMMAND "${GEANT4_CONFIG_EXECUTABLE}" --prefix 
        OUTPUT_VARIABLE GEANT4_DIR
        RESULT_VARIABLE _exit_code
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

# come more work on .. at the end of prefix
#
    EXECUTE_PROCESS( COMMAND dirname ${GEANT4_DIR}
                     OUTPUT_VARIABLE _geant_dir
                     OUTPUT_STRIP_TRAILING_WHITESPACE
)
    EXECUTE_PROCESS( COMMAND dirname ${_geant_dir}
                     OUTPUT_VARIABLE GEANT4_DIR
                     OUTPUT_STRIP_TRAILING_WHITESPACE
)


    EXECUTE_PROCESS( COMMAND "${GEANT4_CONFIG_EXECUTABLE}" --version
        OUTPUT_VARIABLE GEANT4_VERSION
        RESULT_VARIABLE _exit_code
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    # set includes/libs
    #+
    SET( Geant4_VERSION ${GEANT4_VERSION})
    SET( GEANT4_INCLUDE_DIR ${GEANT4_DIR}/include )
    SET( GEANT4_LIB_DIR ${GEANT4_DIR}/lib64 )
    if (  GEANT4_INCLUDE_DIR AND  GEANT4_LIB_DIR )
    INCLUDE( ${GEANT4_LIB_DIR}/Geant4-${GEANT4_VERSION}/Geant4Config.cmake )
#+
# work around strange Geant4 naming convention
     SET( GEANT4_INCLUDE_DIRS ${Geant4_INCLUDE_DIRS} )
     SET( GEANT4_LIBRARIES ${Geant4_LIBRARIES} )
    endif()	
ENDIF()

IF (GEANT4_LIB_DIR)
  SET(GEANT4_LIBRARY_DIR ${GEANT4_LIB_DIR})
ENDIF (GEANT4_LIB_DIR)

if (GEANT4_INCLUDE_DIR AND GEANT4_LIBRARY_DIR)
   set(GEANT4_FOUND TRUE)
endif (GEANT4_INCLUDE_DIR AND GEANT4_LIBRARY_DIR)

if (GEANT4_FOUND)
  MESSAGE(STATUS "... - found version ${GEANT4_VERSION} in ${GEANT4_DIR}")
  SET(LD_LIBRARY_PATH ${LD_LIBRARY_PATH} ${GEANT4_LIBRARY_DIR})
else (GEANT4_FOUND)
  if (GEANT4_FIND_REQUIRED)
    message(FATAL_ERROR "Geant4... - Not found")
  endif (GEANT4_FIND_REQUIRED)
endif (GEANT4_FOUND)

if( GEANT4_FOUND )
	foreach( _dir ${Geant4_THIRD_PARTY_INCLUDE_DIRS} )
	 list( APPEND CLHEP_ROOT_DIR ${_dir}/.. )
	endforeach()

	find_package(CLHEP 2.1.1.0 REQUIRED )

	if( Geant4_gdml_FOUND )
          set( XERCESC_ROOT_DIR ${CLHEP_ROOT_DIR} )
          find_package( XercesC REQUIRED )
	endif()

endif()
	if ( GEANT4_CONFIG_DEBUG )
	 message(STATUS " CLHEP_ROOT_DIR = ${CLHEP_ROOT_DIR}")
	endif()


