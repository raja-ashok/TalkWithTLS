cmake_minimum_required(VERSION 3.10)
project(TalkWithTLS C)

set(CMAKE_C_STANDARD 99)

# Configuration variables
set(DEPENDENCY_DIR "${CMAKE_SOURCE_DIR}/dependency")
set(OSSL_3_0_18_TARBALL "openssl-3.0.18.tar.gz")
# Download URL for OpenSSL 3.0.18
set(OSSL_3_0_18_URL "https://github.com/openssl/openssl/releases/download/openssl-3.0.18/openssl-3.0.18.tar.gz")
# SHA256 checksum for openssl-3.0.18.tar.gz
set(OSSL_3_0_18_SHA256 "d80c34f5cf902dccf1f1b5df5ebb86d0392e37049e5d73df1b3abae72e4ffe8b")
set(OSSL_3_0_18_DIR "${DEPENDENCY_DIR}/openssl-3.0.18")

set(OSSL_3_5_4_TARBALL "openssl-3.5.4.tar.gz")
# Download URL for OpenSSL 3.5.4
set(OSSL_3_5_4_URL "https://github.com/openssl/openssl/releases/download/openssl-3.5.4/openssl-3.5.4.tar.gz")
# SHA256 checksum for openssl-3.5.4.tar.gz (will be verified during download)
set(OSSL_3_5_4_SHA256 "")  # Empty means skip verification
set(OSSL_3_5_4_DIR "${DEPENDENCY_DIR}/openssl-3.5.4")

# Create dependency directory if it doesn't exist
if(NOT EXISTS ${DEPENDENCY_DIR})
    message(STATUS "Creating dependency directory: ${DEPENDENCY_DIR}")
    file(MAKE_DIRECTORY ${DEPENDENCY_DIR})
endif()

# Build type configuration
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Compiler flags
set(CMAKE_C_FLAGS_DEBUG "-g -ggdb -O0 -Wall -Werror -fstack-protector-all")
set(CMAKE_C_FLAGS_RELEASE "-O3 -Wall -Werror")

# Option to disable address sanitizer
option(NOSAN "Disable address sanitizer in debug builds" OFF)
if(NOT NOSAN)
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fsanitize=address")
    set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -fsanitize=address")
endif()

# Parallel build configuration
if(NOT DEFINED ENV{CMAKE_BUILD_PARALLEL_LEVEL})
    set(PARALLEL_JOBS 8)
else()
    set(PARALLEL_JOBS $ENV{CMAKE_BUILD_PARALLEL_LEVEL})
endif()
message(STATUS "Parallel build jobs: ${PARALLEL_JOBS}")

# Source directories
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")
set(COMMON_DIR "${SRC_DIR}/common")
set(TEST_COMMON_DIR "${SRC_DIR}/test/common")
set(TEST_OPENSSL_DIR "${SRC_DIR}/test/openssl")

# Check if OpenSSL 3.0.18 is already built
set(OSSL_3_0_18_LIBSSL "${OSSL_3_0_18_DIR}/libssl.a")
set(OSSL_3_0_18_LIBCRYPTO "${OSSL_3_0_18_DIR}/libcrypto.a")

# Custom target to build OpenSSL 3.0.18
if(NOT EXISTS ${OSSL_3_0_18_LIBSSL})
    message(STATUS "OpenSSL 3.0.18 not found, will build from source")

    # Download tarball if it doesn't exist
    set(OSSL_3_0_18_TARBALL_PATH "${DEPENDENCY_DIR}/${OSSL_3_0_18_TARBALL}")
    if(NOT EXISTS ${OSSL_3_0_18_TARBALL_PATH})
        message(STATUS "Downloading ${OSSL_3_0_18_TARBALL}...")
        file(DOWNLOAD
            ${OSSL_3_0_18_URL}
            ${OSSL_3_0_18_TARBALL_PATH}
            EXPECTED_HASH SHA256=${OSSL_3_0_18_SHA256}
            SHOW_PROGRESS
            STATUS DOWNLOAD_STATUS
        )
        list(GET DOWNLOAD_STATUS 0 DOWNLOAD_RESULT)
        if(NOT DOWNLOAD_RESULT EQUAL 0)
            list(GET DOWNLOAD_STATUS 1 DOWNLOAD_ERROR)
            message(FATAL_ERROR "Failed to download ${OSSL_3_0_18_TARBALL}: ${DOWNLOAD_ERROR}")
        endif()
        message(STATUS "Download completed and SHA256 verified successfully")
    else()
        message(STATUS "Using existing tarball: ${OSSL_3_0_18_TARBALL}")
        message(STATUS "Verifying SHA256 checksum...")
        file(SHA256 ${OSSL_3_0_18_TARBALL_PATH} ACTUAL_SHA256)
        if(NOT "${ACTUAL_SHA256}" STREQUAL "${OSSL_3_0_18_SHA256}")
            message(FATAL_ERROR "SHA256 mismatch for ${OSSL_3_0_18_TARBALL}\n"
                               "  Expected: ${OSSL_3_0_18_SHA256}\n"
                               "  Actual:   ${ACTUAL_SHA256}\n"
                               "Please delete the file and re-run CMake to download again.")
        endif()
        message(STATUS "SHA256 checksum verified successfully")
    endif()

    # Extract tarball if directory doesn't exist
    if(NOT EXISTS ${OSSL_3_0_18_DIR})
        message(STATUS "Extracting ${OSSL_3_0_18_TARBALL}...")
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xzf ${OSSL_3_0_18_TARBALL}
            WORKING_DIRECTORY ${DEPENDENCY_DIR}
            RESULT_VARIABLE EXTRACT_RESULT
        )
        if(NOT EXTRACT_RESULT EQUAL 0)
            message(FATAL_ERROR "Failed to extract ${OSSL_3_0_18_TARBALL}")
        endif()
    endif()

    # Configure and build OpenSSL 3.0.16
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(OSSL_CONFIG_FLAGS -d)
        if(NOT NOSAN)
            list(APPEND OSSL_CONFIG_FLAGS enable-asan)
        endif()
    else()
        set(OSSL_CONFIG_FLAGS "")
    endif()

    message(STATUS "Configuring OpenSSL 3.0.18...")
    execute_process(
        COMMAND ./config ${OSSL_CONFIG_FLAGS}
        WORKING_DIRECTORY ${OSSL_3_0_18_DIR}
        RESULT_VARIABLE CONFIG_RESULT
    )
    if(NOT CONFIG_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to configure OpenSSL 3.0.18")
    endif()

    message(STATUS "Building OpenSSL 3.0.18 (this may take a while)...")
    execute_process(
        COMMAND make -j${PARALLEL_JOBS}
        WORKING_DIRECTORY ${OSSL_3_0_18_DIR}
        RESULT_VARIABLE BUILD_RESULT
    )
    if(NOT BUILD_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to build OpenSSL 3.0.18")
    endif()

    message(STATUS "OpenSSL 3.0.18 built successfully")
else()
    message(STATUS "Using existing OpenSSL 3.0.18 at ${OSSL_3_0_18_DIR}")
endif()

# Check if OpenSSL 3.5.4 is already built
set(OSSL_3_5_4_LIBSSL "${OSSL_3_5_4_DIR}/libssl.a")
set(OSSL_3_5_4_LIBCRYPTO "${OSSL_3_5_4_DIR}/libcrypto.a")

# Custom target to build OpenSSL 3.5.4
if(NOT EXISTS ${OSSL_3_5_4_LIBSSL})
    message(STATUS "OpenSSL 3.5.4 not found, will build from source")

    # Download tarball if it doesn't exist
    set(OSSL_3_5_4_TARBALL_PATH "${DEPENDENCY_DIR}/${OSSL_3_5_4_TARBALL}")
    if(NOT EXISTS ${OSSL_3_5_4_TARBALL_PATH})
        message(STATUS "Downloading ${OSSL_3_5_4_TARBALL}...")
        if(OSSL_3_5_4_SHA256 STREQUAL "")
            # Download without hash verification
            file(DOWNLOAD
                ${OSSL_3_5_4_URL}
                ${OSSL_3_5_4_TARBALL_PATH}
                SHOW_PROGRESS
                STATUS DOWNLOAD_STATUS
            )
        else()
            # Download with hash verification
            file(DOWNLOAD
                ${OSSL_3_5_4_URL}
                ${OSSL_3_5_4_TARBALL_PATH}
                EXPECTED_HASH SHA256=${OSSL_3_5_4_SHA256}
                SHOW_PROGRESS
                STATUS DOWNLOAD_STATUS
            )
        endif()
        list(GET DOWNLOAD_STATUS 0 DOWNLOAD_RESULT)
        if(NOT DOWNLOAD_RESULT EQUAL 0)
            list(GET DOWNLOAD_STATUS 1 DOWNLOAD_ERROR)
            message(FATAL_ERROR "Failed to download ${OSSL_3_5_4_TARBALL}: ${DOWNLOAD_ERROR}")
        endif()
        message(STATUS "Download completed successfully")
    else()
        message(STATUS "Using existing tarball: ${OSSL_3_5_4_TARBALL}")
        if(NOT OSSL_3_5_4_SHA256 STREQUAL "")
            message(STATUS "Verifying SHA256 checksum...")
            file(SHA256 ${OSSL_3_5_4_TARBALL_PATH} ACTUAL_SHA256)
            if(NOT "${ACTUAL_SHA256}" STREQUAL "${OSSL_3_5_4_SHA256}")
                message(FATAL_ERROR "SHA256 mismatch for ${OSSL_3_5_4_TARBALL}\n"
                                   "  Expected: ${OSSL_3_5_4_SHA256}\n"
                                   "  Actual:   ${ACTUAL_SHA256}\n"
                                   "Please delete the file and re-run CMake to download again.")
            endif()
            message(STATUS "SHA256 checksum verified successfully")
        endif()
    endif()

    # Extract tarball if directory doesn't exist
    if(NOT EXISTS ${OSSL_3_5_4_DIR})
        message(STATUS "Extracting ${OSSL_3_5_4_TARBALL}...")
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xzf ${OSSL_3_5_4_TARBALL}
            WORKING_DIRECTORY ${DEPENDENCY_DIR}
            RESULT_VARIABLE EXTRACT_RESULT
        )
        if(NOT EXTRACT_RESULT EQUAL 0)
            message(FATAL_ERROR "Failed to extract ${OSSL_3_5_4_TARBALL}")
        endif()
    endif()

    # Configure and build OpenSSL 3.5.4
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(OSSL_354_CONFIG_FLAGS -d)
        if(NOT NOSAN)
            list(APPEND OSSL_354_CONFIG_FLAGS enable-asan)
        endif()
    else()
        set(OSSL_354_CONFIG_FLAGS "")
    endif()

    message(STATUS "Configuring OpenSSL 3.5.4...")
    execute_process(
        COMMAND ./config ${OSSL_354_CONFIG_FLAGS}
        WORKING_DIRECTORY ${OSSL_3_5_4_DIR}
        RESULT_VARIABLE CONFIG_RESULT
    )
    if(NOT CONFIG_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to configure OpenSSL 3.5.4")
    endif()

    message(STATUS "Building OpenSSL 3.5.4 (this may take a while)...")
    execute_process(
        COMMAND make -j${PARALLEL_JOBS}
        WORKING_DIRECTORY ${OSSL_3_5_4_DIR}
        RESULT_VARIABLE BUILD_RESULT
    )
    if(NOT BUILD_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to build OpenSSL 3.5.4")
    endif()

    message(STATUS "OpenSSL 3.5.4 built successfully")
else()
    message(STATUS "Using existing OpenSSL 3.5.4 at ${OSSL_3_5_4_DIR}")
endif()

# Include directories
include_directories(
    ${COMMON_DIR}
    ${TEST_COMMON_DIR}
    ${TEST_OPENSSL_DIR}
    ${OSSL_3_0_18_DIR}/include
)

# Compile definitions
add_definitions(-DWITH_OSSL -DWITH_OSSL_300)

# Collect source files
file(GLOB COMMON_SRC_FILES "${COMMON_DIR}/*.c")
file(GLOB TEST_COMMON_SRC_FILES "${TEST_COMMON_DIR}/*.c")
file(GLOB TEST_OPENSSL_SRC_FILES "${TEST_OPENSSL_DIR}/*.c")

# Create test_common library
add_library(test_common STATIC ${TEST_COMMON_SRC_FILES} ${COMMON_SRC_FILES})

# Create test_openssl_3018 executable
add_executable(test_openssl_3018 ${TEST_OPENSSL_SRC_FILES})

# Link libraries
target_link_libraries(test_openssl_3018
    test_common
    ${OSSL_3_0_18_LIBSSL}
    ${OSSL_3_0_18_LIBCRYPTO}
    pthread
    dl
)

# Set output directory
set_target_properties(test_openssl_3018 PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin"
)

# Create test_openssl_354 executable
add_executable(test_openssl_354 ${TEST_OPENSSL_SRC_FILES})

# Link libraries for test_openssl_354
target_link_libraries(test_openssl_354
    test_common
    ${OSSL_3_5_4_LIBSSL}
    ${OSSL_3_5_4_LIBCRYPTO}
    pthread
    dl
)

# Include OpenSSL 3.5.4 headers for test_openssl_354
target_include_directories(test_openssl_354 PRIVATE
    ${OSSL_3_5_4_DIR}/include
)

# Set output directory for test_openssl_354
set_target_properties(test_openssl_354 PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin"
)

# Print build configuration
message(STATUS "")
message(STATUS "Build configuration:")
message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "  OpenSSL 3.0.18 dir: ${OSSL_3_0_18_DIR}")
message(STATUS "  OpenSSL 3.5.4 dir: ${OSSL_3_5_4_DIR}")
message(STATUS "  Output binaries:")
message(STATUS "    - bin/test_openssl_3018")
message(STATUS "    - bin/test_openssl_354")
message(STATUS "")
