# Developer Environment Docker Image

This Docker image provides a comprehensive development environment with support for multiple programming languages and tools. It's designed to be a versatile base for various development projects.

## Features

- Base: Debian Bookworm (slim)

- Languages:
    - Java 21 (Oracle JDK)
    - Node.js (Latest LTS)
    - Python 3.12.1
    - .NET Core 6.0 (Runtime and SDK)

- Tools Included:
    - Development: git, cmake, wget, curl
    - Build: make, build-essential
    - Utilities: zip, unzip, tar

## Usage

```bash
docker pull bocon778/bash
docker run -it bocon778/bash
```
