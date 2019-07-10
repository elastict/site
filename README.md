# Elast ICT website

This repository contains the code for the [Elast ICT website](https://elastict.nl).

Tech:
- Rust server with [Rocket](https://rocket.rs/)
- SCSS compiled with [Sass](https://sass-lang.com/)
- [Tera](https://github.com/Keats/tera) HTML templates
- Packaged with Docker

### Development

**Requirements**

- [Rust toolchain](https://rustup.rs/)
- [Sass compiler](https://sass-lang.com/install)

**Running it**

- Clone the repo
- Keep CSS updated by running `./compile-scss.sh --watch`
- Run server with `cargo run`
- Site is now available on `localhost:9000`

## Deploying

**Requirements**

- Docker
- Docker Compose (optional, but easier)

**Building**

Build the Docker image with `docker-compose build`. 
Test the production version with `docker-compose up` and visit `localhost:8000`.
The live site is deployed behind an Nginx instance that handles SSL and proxies to the actual site
container, this is not included in this project.
