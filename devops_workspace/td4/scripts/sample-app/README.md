# Node.js and NPM Example

This folder contains:

* `app.js`: A Node.js "Hello, World" app that listens on port 8080.
* `package.json`: An NPM build configuration for the Node.js app.
* `Dockerfile`: Instructions on how to package the Node.js app as a Docker image.

## Guide d'utilisation (Docker)

Ce projet est entièrement conteneurisé. Voici comment le construire et le lancer :

### 1. Construction de l'image
Exécutez le script suivant pour créer l'image Docker avec la version spécifique de Node.js :
```bash
./build-docker-image.sh
