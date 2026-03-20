cmake_minimum_required(VERSION 3.10)
project(TalkWithTLS C)

set(CMAKE_C_STANDARD 99)

# Configuration variables
set(DEPENDENCY_DIR "${CMAKE_SOURCE_DIR}/dependency")
set(OSSL_3_0_X_TARBALL "openssl-3.0.19.tar.gz")
# Download URL for OpenSSL 3.0.19
string(CONCAT OSSL_3_0_X_URL
    "https://github.com/openssl/openssl/releases/download/openssl-3.0.19/"
    "openssl-3.0.19.tar.gz"
)
# SHA256 checksum for openssl-3.0.19.tar.gz
set(OSSL_3_0_X_SHA256
    "fa5a4143b8aae18be53ef2f3caf29a2e0747430b8bc74d32d88335b94ab63072"
)
set(OSSL_3_0_X_DIR "${DEPENDENCY_DIR}/openssl-3.0.19")
set(OSSL_3_0_X_VERSION "3.0.19")
set(OSSL_3_0_X_TARGET_SUFFIX "3019")

set(OSSL_3_5_X_TARBALL "openssl-3.5.5.tar.gz")
# Download URL for OpenSSL 3.5.5
string(CONCAT OSSL_3_5_X_URL
    "https://github.com/openssl/openssl/releases/download/openssl-3.5.5/"
    "openssl-3.5.5.tar.gz"
)
# SHA256 checksum for openssl-3.5.5.tar.gz (verified during download)
set(OSSL_3_5_X_SHA256
    "b28c91532a8b65a1f983b4c28b7488174e4a01008e29ce8e69bd789f28bc2a89"
)
set(OSSL_3_5_X_DIR "${DEPENDENCY_DIR}/openssl-3.5.5")
set(OSSL_3_5_X_VERSION "3.5.5")
set(OSSL_3_5_X_TARGET_SUFFIX "355")

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
    set(CMAKE_EXE_LINKER_FLAGS_DEBUG
        "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -fsanitize=address"
    )
endif()

# Parallel build configuration
if(NOT DEFINED ENV{CMAKE_BUILD_PARALLEL_LEVEL})
    set(PARALLEL_JOBS 8)
else()
    set(PARALLEL_JOBS $ENV{CMAKE_BUILD_PARALLEL_LEVEL})
endif()
message(STATUS "Parallel build jobs: ${PARALLEL_JOBS}")

# Log files for OpenSSL builds
set(BUILD_LOG_DIR "${CMAKE_BINARY_DIR}/logs")
file(MAKE_DIRECTORY "${BUILD_LOG_DIR}")
set(OSSL_3_0_X_BUILD_LOG "${BUILD_LOG_DIR}/openssl_3_0_x_build.log")
set(OSSL_3_5_X_BUILD_LOG "${BUILD_LOG_DIR}/openssl_3_5_x_build.log")

# Source directories
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")
set(COMMON_DIR "${SRC_DIR}/common")
set(TEST_COMMON_DIR "${SRC_DIR}/test/common")
set(TEST_OPENSSL_DIR "${SRC_DIR}/test/openssl")

# Check if OpenSSL 3.0.x is already built
set(OSSL_3_0_X_LIBSSL "${OSSL_3_0_X_DIR}/libssl.a")
set(OSSL_3_0_X_LIBCRYPTO "${OSSL_3_0_X_DIR}/libcrypto.a")
set(OSSL_3_0_X_TARGET "test_openssl_${OSSL_3_0_X_TARGET_SUFFIX}")
set(OSSL_3_0_X_CONFIG_FLAGS "")

# Custom target to build OpenSSL 3.0.x
if(NOT EXISTS ${OSSL_3_0_X_LIBSSL})
    message(STATUS
        "OpenSSL ${OSSL_3_0_X_VERSION} not found, will build from source"
    )

    file(WRITE ${OSSL_3_0_X_BUILD_LOG} "")
    message(STATUS
        "Logging OpenSSL ${OSSL_3_0_X_VERSION} build to "
        "${OSSL_3_0_X_BUILD_LOG}"
    )

    # Download tarball if it doesn't exist
    set(OSSL_3_0_X_TARBALL_PATH "${DEPENDENCY_DIR}/${OSSL_3_0_X_TARBALL}")
    if(NOT EXISTS ${OSSL_3_0_X_TARBALL_PATH})
        message(STATUS "Downloading ${OSSL_3_0_X_TARBALL}...")
        file(DOWNLOAD
            ${OSSL_3_0_X_URL}
            ${OSSL_3_0_X_TARBALL_PATH}
            EXPECTED_HASH SHA256=${OSSL_3_0_X_SHA256}
            SHOW_PROGRESS
            STATUS DOWNLOAD_STATUS
        )
        list(GET DOWNLOAD_STATUS 0 DOWNLOAD_RESULT)
        if(NOT DOWNLOAD_RESULT EQUAL 0)
            list(GET DOWNLOAD_STATUS 1 DOWNLOAD_ERROR)
            message(FATAL_ERROR
                "Failed to download ${OSSL_3_0_X_TARBALL}: ${DOWNLOAD_ERROR}"
            )
        endif()
        message(STATUS
            "Download completed and SHA256 verified successfully"
        )
    else()
        message(STATUS "Using existing tarball: ${OSSL_3_0_X_TARBALL}")
        message(STATUS "Verifying SHA256 checksum...")
        file(SHA256 ${OSSL_3_0_X_TARBALL_PATH} ACTUAL_SHA256)
        if(NOT "${ACTUAL_SHA256}" STREQUAL "${OSSL_3_0_X_SHA256}")
            message(FATAL_ERROR
                "SHA256 mismatch for ${OSSL_3_0_X_TARBALL}\n"
                "  Expected: ${OSSL_3_0_X_SHA256}\n"
                "  Actual:   ${ACTUAL_SHA256}\n"
                "Please delete the file and re-run CMake to download again."
            )
        endif()
        message(STATUS "SHA256 checksum verified successfully")
    endif()

    # Extract tarball if directory doesn't exist
    if(NOT EXISTS ${OSSL_3_0_X_DIR})
        message(STATUS "Extracting ${OSSL_3_0_X_TARBALL}...")
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xzf ${OSSL_3_0_X_TARBALL}
            WORKING_DIRECTORY ${DEPENDENCY_DIR}
            RESULT_VARIABLE EXTRACT_RESULT
        )
        if(NOT EXTRACT_RESULT EQUAL 0)
            message(FATAL_ERROR "Failed to extract ${OSSL_3_0_X_TARBALL}")
        endif()
    endif()

    # Configure and build OpenSSL 3.0.x
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(OSSL_3_0_X_CONFIG_FLAGS -d)
        if(NOT NOSAN)
            list(APPEND OSSL_3_0_X_CONFIG_FLAGS enable-asan)
        endif()
    else()
        set(OSSL_3_0_X_CONFIG_FLAGS "")
    endif()

    string(REPLACE ";" " " OSSL_3_0_X_CONFIG_FLAGS_STR
        "${OSSL_3_0_X_CONFIG_FLAGS}"
    )
    message(STATUS
        "Configuring OpenSSL ${OSSL_3_0_X_VERSION} with config flags: "
        "${OSSL_3_0_X_CONFIG_FLAGS}..."
    )
    string(CONCAT OSSL_3_0_X_CONFIG_CMD
        "./config ${OSSL_3_0_X_CONFIG_FLAGS_STR} >> "
        "\"${OSSL_3_0_X_BUILD_LOG}\" 2>&1"
    )
    execute_process(
        COMMAND /bin/sh -c ${OSSL_3_0_X_CONFIG_CMD}
        WORKING_DIRECTORY ${OSSL_3_0_X_DIR}
        RESULT_VARIABLE CONFIG_RESULT
    )
    if(NOT CONFIG_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to configure OpenSSL ${OSSL_3_0_X_VERSION}")
    endif()

    message(STATUS
        "Building OpenSSL ${OSSL_3_0_X_VERSION} (this may take a while)..."
    )
    string(CONCAT OSSL_3_0_X_BUILD_CMD
        "make -j${PARALLEL_JOBS} >> "
        "\"${OSSL_3_0_X_BUILD_LOG}\" 2>&1"
    )
    execute_process(
        COMMAND /bin/sh -c ${OSSL_3_0_X_BUILD_CMD}
        WORKING_DIRECTORY ${OSSL_3_0_X_DIR}
        RESULT_VARIABLE BUILD_RESULT
    )
    if(NOT BUILD_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to build OpenSSL ${OSSL_3_0_X_VERSION}")
    endif()

    message(STATUS "OpenSSL ${OSSL_3_0_X_VERSION} built successfully")
else()
    message(STATUS
        "Using existing OpenSSL ${OSSL_3_0_X_VERSION} at ${OSSL_3_0_X_DIR}"
    )
endif()

# Check if OpenSSL 3.5.x is already built
set(OSSL_3_5_X_LIBSSL "${OSSL_3_5_X_DIR}/libssl.a")
set(OSSL_3_5_X_LIBCRYPTO "${OSSL_3_5_X_DIR}/libcrypto.a")
set(OSSL_3_5_X_TARGET "test_openssl_${OSSL_3_5_X_TARGET_SUFFIX}")
set(OSSL_3_5_X_CONFIG_FLAGS "")

# Custom target to build OpenSSL 3.5.x
if(NOT EXISTS ${OSSL_3_5_X_LIBSSL})
    message(STATUS
        "OpenSSL ${OSSL_3_5_X_VERSION} not found, will build from source"
    )

    file(WRITE ${OSSL_3_5_X_BUILD_LOG} "")
    message(STATUS
        "Logging OpenSSL ${OSSL_3_5_X_VERSION} build to "
        "${OSSL_3_5_X_BUILD_LOG}"
    )

    # Download tarball if it doesn't exist
    set(OSSL_3_5_X_TARBALL_PATH "${DEPENDENCY_DIR}/${OSSL_3_5_X_TARBALL}")
    if(NOT EXISTS ${OSSL_3_5_X_TARBALL_PATH})
        message(STATUS "Downloading ${OSSL_3_5_X_TARBALL}...")
        if(OSSL_3_5_X_SHA256 STREQUAL "")
            # Download without hash verification
            file(DOWNLOAD
                ${OSSL_3_5_X_URL}
                ${OSSL_3_5_X_TARBALL_PATH}
                SHOW_PROGRESS
                STATUS DOWNLOAD_STATUS
            )
        else()
            # Download with hash verification
            file(DOWNLOAD
                ${OSSL_3_5_X_URL}
                ${OSSL_3_5_X_TARBALL_PATH}
                EXPECTED_HASH SHA256=${OSSL_3_5_X_SHA256}
                SHOW_PROGRESS
                STATUS DOWNLOAD_STATUS
            )
        endif()
        list(GET DOWNLOAD_STATUS 0 DOWNLOAD_RESULT)
        if(NOT DOWNLOAD_RESULT EQUAL 0)
            list(GET DOWNLOAD_STATUS 1 DOWNLOAD_ERROR)
            message(FATAL_ERROR
                "Failed to download ${OSSL_3_5_X_TARBALL}: ${DOWNLOAD_ERROR}"
            )
        endif()
        message(STATUS "Download completed successfully")
    else()
        message(STATUS "Using existing tarball: ${OSSL_3_5_X_TARBALL}")
        if(NOT OSSL_3_5_X_SHA256 STREQUAL "")
            message(STATUS "Verifying SHA256 checksum...")
            file(SHA256 ${OSSL_3_5_X_TARBALL_PATH} ACTUAL_SHA256)
            if(NOT "${ACTUAL_SHA256}" STREQUAL "${OSSL_3_5_X_SHA256}")
                message(FATAL_ERROR
                    "SHA256 mismatch for ${OSSL_3_5_X_TARBALL}\n"
                    "  Expected: ${OSSL_3_5_X_SHA256}\n"
                    "  Actual:   ${ACTUAL_SHA256}\n"
                    "Please delete the file and re-run CMake to download again."
                )
            endif()
            message(STATUS "SHA256 checksum verified successfully")
        endif()
    endif()

    # Extract tarball if directory doesn't exist
    if(NOT EXISTS ${OSSL_3_5_X_DIR})
        message(STATUS "Extracting ${OSSL_3_5_X_TARBALL}...")
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xzf ${OSSL_3_5_X_TARBALL}
            WORKING_DIRECTORY ${DEPENDENCY_DIR}
            RESULT_VARIABLE EXTRACT_RESULT
        )
        if(NOT EXTRACT_RESULT EQUAL 0)
            message(FATAL_ERROR "Failed to extract ${OSSL_3_5_X_TARBALL}")
        endif()
    endif()

    # Configure and build OpenSSL 3.5.x
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(OSSL_3_5_X_CONFIG_FLAGS -d)
        if(NOT NOSAN)
            list(APPEND OSSL_3_5_X_CONFIG_FLAGS enable-asan)
        endif()
    else()
        set(OSSL_3_5_X_CONFIG_FLAGS "")
    endif()

    message(STATUS
        "Configuring OpenSSL ${OSSL_3_5_X_VERSION} config flags: "
        "${OSSL_3_5_X_CONFIG_FLAGS}..."
    )
    string(REPLACE ";" " " OSSL_3_5_X_CONFIG_FLAGS_STR
        "${OSSL_3_5_X_CONFIG_FLAGS}"
    )
    string(CONCAT OSSL_3_5_X_CONFIG_CMD
        "./config ${OSSL_3_5_X_CONFIG_FLAGS_STR} >> "
        "\"${OSSL_3_5_X_BUILD_LOG}\" 2>&1"
    )
    execute_process(
        COMMAND /bin/sh -c ${OSSL_3_5_X_CONFIG_CMD}
        WORKING_DIRECTORY ${OSSL_3_5_X_DIR}
        RESULT_VARIABLE CONFIG_RESULT
    )
    if(NOT CONFIG_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to configure OpenSSL ${OSSL_3_5_X_VERSION}")
    endif()

    message(STATUS
        "Building OpenSSL ${OSSL_3_5_X_VERSION} (this may take a while)..."
    )
    string(CONCAT OSSL_3_5_X_BUILD_CMD
        "make -j${PARALLEL_JOBS} >> "
        "\"${OSSL_3_5_X_BUILD_LOG}\" 2>&1"
    )
    execute_process(
        COMMAND /bin/sh -c ${OSSL_3_5_X_BUILD_CMD}
        WORKING_DIRECTORY ${OSSL_3_5_X_DIR}
        RESULT_VARIABLE BUILD_RESULT
    )
    if(NOT BUILD_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to build OpenSSL ${OSSL_3_5_X_VERSION}")
    endif()

    message(STATUS "OpenSSL ${OSSL_3_5_X_VERSION} built successfully")
else()
    message(STATUS
        "Using existing OpenSSL ${OSSL_3_5_X_VERSION} at ${OSSL_3_5_X_DIR}"
    )
endif()

# Include directories
include_directories(
    ${COMMON_DIR}
    ${TEST_COMMON_DIR}
    ${TEST_OPENSSL_DIR}
    ${OSSL_3_0_X_DIR}/include
)

# Compile definitions
add_definitions(-DWITH_OSSL -DWITH_OSSL_300)

# Collect source files
file(GLOB COMMON_SRC_FILES "${COMMON_DIR}/*.c")
file(GLOB TEST_COMMON_SRC_FILES "${TEST_COMMON_DIR}/*.c")
file(GLOB TEST_OPENSSL_SRC_FILES "${TEST_OPENSSL_DIR}/*.c")

# Create test_common library
add_library(test_common STATIC
    ${TEST_COMMON_SRC_FILES}
    ${COMMON_SRC_FILES}
)

# Create test_openssl_${OSSL_3_0_X_TARGET_SUFFIX} executable
add_executable(${OSSL_3_0_X_TARGET} ${TEST_OPENSSL_SRC_FILES})

# Link libraries
target_link_libraries(${OSSL_3_0_X_TARGET}
    test_common
    ${OSSL_3_0_X_LIBSSL}
    ${OSSL_3_0_X_LIBCRYPTO}
    pthread
    dl
)

# Set output directory
set_target_properties(${OSSL_3_0_X_TARGET} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin"
)

# Create test_openssl_${OSSL_3_5_X_TARGET_SUFFIX} executable
add_executable(${OSSL_3_5_X_TARGET} ${TEST_OPENSSL_SRC_FILES})

# Link libraries for test_openssl_${OSSL_3_5_X_TARGET_SUFFIX}
target_link_libraries(${OSSL_3_5_X_TARGET}
    test_common
    ${OSSL_3_5_X_LIBSSL}
    ${OSSL_3_5_X_LIBCRYPTO}
    pthread
    dl
)

# Include OpenSSL ${OSSL_3_5_X_VERSION} headers for
# test_openssl_${OSSL_3_5_X_TARGET_SUFFIX}
target_include_directories(${OSSL_3_5_X_TARGET} PRIVATE
    ${OSSL_3_5_X_DIR}/include
)

# Set output directory for test_openssl_${OSSL_3_5_X_TARGET_SUFFIX}
set_target_properties(${OSSL_3_5_X_TARGET} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin"
)

# Print build configuration
message(STATUS "")
message(STATUS "Build configuration:")
message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "  OpenSSL ${OSSL_3_0_X_VERSION} dir: ${OSSL_3_0_X_DIR}")
message(STATUS "  OpenSSL ${OSSL_3_5_X_VERSION} dir: ${OSSL_3_5_X_DIR}")
message(STATUS "  Output binaries:")
message(STATUS "    - bin/${OSSL_3_0_X_TARGET}")
message(STATUS "    - bin/${OSSL_3_5_X_TARGET}")
message(STATUS "")
