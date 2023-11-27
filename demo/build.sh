#!/bin/bash

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--version)
            VERSION="$2"
            shift
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
    shift
done

# Check if the version is provided
if [ -z "$VERSION" ]; then
    echo "Please provide a version using -v or --version."
    exit 1
fi

# Run Gradle build
./gradlew build

# Build and push Docker image with the dynamic version
docker buildx build --platform linux/amd64 --push -t springsandbox/demo:v$VERSION .
