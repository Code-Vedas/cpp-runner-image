FROM gcc:latest

# Build arguments for versions (with defaults for backward compatibility)
ARG CMAKE_VERSION=v4.0.3
ARG CATCH2_VERSION=v3.8.1

# Set the working directory
WORKDIR /app

# Install CMake
RUN apt-get update && apt-get install -y wget && \
  ARCH=$(uname -m) && \
  CMAKE_VER_NO_V=${CMAKE_VERSION#v} && \
  if [ "$ARCH" = "aarch64" ]; then \
  wget -q https://github.com/Kitware/CMake/releases/download/${CMAKE_VERSION}/cmake-${CMAKE_VER_NO_V}-linux-aarch64.sh; \
  else \
  wget -q https://github.com/Kitware/CMake/releases/download/${CMAKE_VERSION}/cmake-${CMAKE_VER_NO_V}-linux-x86_64.sh; \
  fi && \
  chmod +x cmake-${CMAKE_VER_NO_V}-linux-*.sh && \
  ./cmake-${CMAKE_VER_NO_V}-linux-*.sh --skip-license --prefix=/usr/local && \
  ln -s /usr/local/bin/cmake /usr/bin/cmake

# Install Catch2
RUN CATCH2_VER_NO_V=${CATCH2_VERSION#v} && \
  wget -q https://github.com/catchorg/Catch2/archive/refs/tags/${CATCH2_VERSION}.zip && \
  unzip ${CATCH2_VERSION}.zip && \
  cd Catch2-${CATCH2_VER_NO_V} && \
  cmake -Bbuild -H. -DBUILD_TESTING=OFF && \
  cmake --build build/ --target install

# Install python3
RUN apt-get install -y python3 python3-pip python3-full valgrind

# Install gcovr
RUN pip3 install gcovr --break-system-packages
