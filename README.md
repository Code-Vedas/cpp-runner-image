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

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
