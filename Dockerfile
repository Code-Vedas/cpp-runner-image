FROM gcc:latest

# Set the working directory
WORKDIR /app

# Install CMake
RUN apt-get update && apt-get install -y wget && \
  ARCH=$(uname -m) && \
  if [ "$ARCH" = "aarch64" ]; then \
  wget -q https://github.com/Kitware/CMake/releases/download/v4.0.3/cmake-4.0.3-linux-aarch64.sh; \
  else \
  wget -q https://github.com/Kitware/CMake/releases/download/v4.0.3/cmake-4.0.3-linux-x86_64.sh; \
  fi && \
  chmod +x cmake-4.0.3-linux-*.sh && \
  ./cmake-4.0.3-linux-*.sh --skip-license --prefix=/usr/local && \
  ln -s /usr/local/bin/cmake /usr/bin/cmake

# Install Catch2
RUN wget -q https://github.com/catchorg/Catch2/archive/refs/tags/v3.8.1.zip && \
  unzip v3.8.1.zip && \
  cd Catch2-3.8.1 && \
  cmake -Bbuild -H. -DBUILD_TESTING=OFF && \
  cmake --build build/ --target install

# Install python3
RUN apt-get install -y python3 python3-pip python3-full valgrind

# Install gcovr
RUN pip3 install gcovr --break-system-packages
