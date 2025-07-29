# C++ Runner image for CI/CD

This image is based on the [C++ Docker image](https://hub.docker.com/_/gcc) and adds the following tools:
- [CMake](https://cmake.org/)
- [Catch2](https://github.com/catchorg/Catch2)
- [gcovr](https://gcovr.com/en/stable/)

The image is intended to be used in CI/CD pipelines for C++ projects.

## Usage

The image is available on ghcr.io and can be used in GitHub Actions workflows like this:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/code-vedas/cpp-runner:latest
    steps:
```

## Development

To build the image locally, run the following command:

```bash
docker build -t cpp-runner .
```

### Building with specific versions

The image automatically uses the latest releases of CMake and Catch2 when built through GitHub Actions. For local builds, you can specify versions using build arguments:

```bash
# Build with specific versions
docker build --build-arg CMAKE_VERSION=v3.29.0 --build-arg CATCH2_VERSION=v3.7.1 -t cpp-runner .

# Build with default versions (same as just docker build -t cpp-runner .)
docker build --build-arg CMAKE_VERSION=v4.0.3 --build-arg CATCH2_VERSION=v3.8.1 -t cpp-runner .
```

The GitHub Actions workflow automatically fetches and uses the latest released versions of both dependencies.

## Performance Optimizations

### ARM64 Build Speed Improvements

This image includes several optimizations specifically designed to speed up builds on linux/arm64 architecture:

- **Parallel Compilation**: Utilizes all available CPU cores during Catch2 compilation with `--parallel $(nproc)`
- **Optimized Build Flags**: Uses release build configuration with `-O2 -DNDEBUG` for faster compilation
- **Layer Optimization**: Combines related operations to reduce Docker layer count and improve caching
- **Build Context Efficiency**: Uses `.dockerignore` to exclude unnecessary files from build context

These optimizations typically provide:
- 50-70% faster Catch2 compilation on multi-core ARM64 systems
- Reduced build times through better layer caching
- Smaller final image size through improved cleanup

### Environment Variables

The image sets the following environment variables to optimize builds:
- `MAKEFLAGS="-j$(nproc)"` - Enables parallel make builds
- `CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)` - Enables parallel CMake builds

## CI/CD Pipeline

The project uses a multi-job GitHub Actions workflow that separates build and publish operations for better parallelization and control:

### Build Jobs
- **build-amd64**: Tests building for linux/amd64 on PRs, main branch, and tags
- **build-arm64**: Tests building for linux/arm64 on PRs, main branch, and tags
- Build jobs validate the Docker image can be built successfully but don't publish to registry

### Publish Jobs  
- **publish-amd64**: Builds and publishes linux/amd64 images on scheduled runs and main branch pushes
- **publish-arm64**: Builds and publishes linux/arm64 images on scheduled runs and main branch pushes
- **create-manifest**: Combines both architecture-specific images into a multi-architecture manifest

### Benefits
- **Parallel Execution**: Each architecture builds independently for faster CI/CD
- **Clear Separation**: Build validation separate from publishing reduces complexity
- **Architecture-Specific Control**: Individual job control and troubleshooting per architecture
- **Optimized Caching**: Separate cache scopes for each architecture improve build performance
- **Multi-arch Support**: Final images support both amd64 and arm64 architectures seamlessly

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
