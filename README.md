# Dev Container Environment

This repository provides a Docker-based Ubuntu development environment with SSH, Python (via pyenv), and Node.js (via nvm) support. 

Able to share the host user directory and permission. 

Configuration is managed via environment variables.

## Features

- Ubuntu 22.04 base image
- SSH server enabled (customizable port)
- User and group created from environment variables
- Passwordless sudo for the created user
- [pyenv](https://github.com/pyenv/pyenv) for Python version management
- [nvm](https://github.com/nvm-sh/nvm) for Node.js version management
- Home directory volume mapping

## Getting Started

### 1. Clone the Repository

```sh
git clone <this-repo-url>
cd remote-dev-container
```

### 2. Configure Environment Variables

Copy `.env.example` to `.env` and edit as needed:

```sh
cp .env.example .env
```

Edit `.env` to set your host username, password, UID, GID, and SSH port.

### 3. Build and Start the Container

```sh
docker-compose up --build -d
```

This will build the image and start the container with your specified settings.

### 4. Connect via SSH

```sh
ssh <USERNAME>@localhost -p <SSHPORT>
```

Replace `<USERNAME>` and `<SSHPORT>` with the values from your `.env` file.

## File Overview

- `Dockerfile`: Defines the Ubuntu-based development environment.
- `docker-compose.yaml`: Orchestrates the container, passing environment variables and mapping volumes/ports.
- `.env.example`: Example environment variable file.
- `.env`: Your actual environment variable file (should not be committed).
- `.gitignore`: Ignores `.env` for safety.

## Customization

- To install additional packages, modify the `RUN apt-get install ...` line in the `Dockerfile`.
- To change the mapped home directory, edit the `volumes` section in `docker-compose.yaml`.

## Stopping the Container

```sh
docker-compose down
```

## License

MIT