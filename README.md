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

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
