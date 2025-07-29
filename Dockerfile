FROM gcc:latest

# Build arguments for versions (with defaults for backward compatibility)
ARG CMAKE_VERSION=v4.0.3
ARG CATCH2_VERSION=v3.8.1
ARG TARGETPLATFORM

# Set environment variables for parallel builds
# These will significantly speed up compilation on ARM64
ENV MAKEFLAGS="-j$(nproc)" \
    CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)

# Set the working directory
WORKDIR /app

# Install system dependencies and CMake in one layer for better caching
RUN apt-get update && \
    apt-get install -y wget unzip python3 python3-pip python3-full valgrind && \
    # Install CMake with architecture detection \
    ARCH=$(uname -m) && \
    CMAKE_VER_NO_V=${CMAKE_VERSION#v} && \
    if [ "$ARCH" = "aarch64" ]; then \
        wget -q https://github.com/Kitware/CMake/releases/download/${CMAKE_VERSION}/cmake-${CMAKE_VER_NO_V}-linux-aarch64.sh; \
    else \
        wget -q https://github.com/Kitware/CMake/releases/download/${CMAKE_VERSION}/cmake-${CMAKE_VER_NO_V}-linux-x86_64.sh; \
    fi && \
    chmod +x cmake-${CMAKE_VER_NO_V}-linux-*.sh && \
    ./cmake-${CMAKE_VER_NO_V}-linux-*.sh --skip-license --prefix=/usr/local && \
    ln -s /usr/local/bin/cmake /usr/bin/cmake && \
    rm -f cmake-${CMAKE_VER_NO_V}-linux-*.sh && \
    # Install gcovr in the same layer \
    pip3 install gcovr --break-system-packages && \
    # Clean up apt cache to reduce image size \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Catch2 with optimized parallel build
# This is the main bottleneck for ARM64 builds, so we optimize it heavily
RUN CATCH2_VER_NO_V=${CATCH2_VERSION#v} && \
    wget -q https://github.com/catchorg/Catch2/archive/refs/tags/${CATCH2_VERSION}.zip && \
    unzip ${CATCH2_VERSION}.zip && \
    cd Catch2-${CATCH2_VER_NO_V} && \
    # Configure with optimizations for faster builds and better ARM64 performance \
    cmake -Bbuild -H. \
        -DBUILD_TESTING=OFF \
        -DCATCH_INSTALL_DOCS=OFF \
        -DCATCH_INSTALL_EXTRAS=OFF \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_FLAGS="-O2 -DNDEBUG" && \
    # Use parallel build with all available cores - critical for ARM64 speed \
    cmake --build build/ --target install --parallel $(nproc) && \
    # Clean up build artifacts to reduce image size \
    cd .. && \
    rm -rf Catch2-${CATCH2_VER_NO_V} ${CATCH2_VERSION}.zip
