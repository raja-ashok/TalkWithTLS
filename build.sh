#!/bin/bash

# Build script for test_openssl_3016 using CMake

# Set default build type
BUILD_TYPE=${1:-Debug}

# Create build directory
BUILD_DIR="build"
mkdir -p ${BUILD_DIR}

# Configure and build
cd ${BUILD_DIR}

echo "Configuring project with CMake..."
cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} ..

if [ $? -ne 0 ]; then
    echo "CMake configuration failed!"
    exit 1
fi

echo ""
echo "Building project..."
make -j$(nproc)

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo ""
echo "Build completed successfully!"
echo "Binary location: bin/test_openssl_3018"
echo ""
echo "To run the test:"
echo "  ./bin/test_openssl_3018 -serv -ver 13"
echo "  ./bin/test_openssl_3018 -ver 13"
