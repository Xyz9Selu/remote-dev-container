# Dev Container Environment

This repository provides a Docker-based Ubuntu development environment with SSH, Python (via pyenv), Node.js (via nvm), and Docker CLI support.

It supports sharing the host user's home directory and permissions, and allows direct access to the host's Docker environment from inside the container (by mounting the Docker socket).

Configuration is managed via environment variables.

## Features

- Ubuntu 22.04 base image
- SSH server enabled (customizable port)
- User and group created from environment variables
- Passwordless sudo for the created user
- [pyenv](https://github.com/pyenv/pyenv) for Python version management
- [nvm](https://github.com/nvm-sh/nvm) for Node.js version management
- Home directory volume mapping
- [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/) installed from the official Docker repository
- Directly use the `docker` command inside the container to control the host Docker (via `/var/run/docker.sock` mount)

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

Edit `.env` to set your desired username, password, UID, GID, and SSH port.

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

### 5. Use Docker in the Container

You can run Docker commands (such as `docker ps`, `docker build`, etc.) directly inside the container. These commands operate on the host's Docker environment.

> Note: The container user is automatically added to the `docker` group, so no extra configuration is needed.

## File Overview

- `Dockerfile`: Defines the Ubuntu-based development environment and installs Docker CLI from the official Docker repository.
- `docker-compose.yaml`: Orchestrates the container, passes environment variables, maps volumes/ports, and mounts the host's `/var/run/docker.sock`.
- `.env.example`: Example environment variable file.
- `.env`: Your actual environment variable file (should not be committed).

## Customization

- To install additional packages, modify the `RUN apt-get install ...` line in the `Dockerfile`.
- To change the mapped home directory, edit the `volumes` section in `docker-compose.yaml`.
- To customize the Docker version or components, modify the relevant installation commands in the `Dockerfile`.

## Stopping the Container

```sh
docker-compose down
```

## List latest installed apps

```sh
docker compose exec ubuntu bash -c 'grep "Commandline" /var/log/apt/history.log'
```

## License

MIT