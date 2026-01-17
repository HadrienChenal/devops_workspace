#!/bin/bash

# Nom de l'image (doit correspondre à celui de ton script de build)
IMAGE_NAME="sample-app"
TAG="1.0.0"

echo "Arrêt des anciens conteneurs en cours..."
docker stop $IMAGE_NAME 2>/dev/null || true
docker rm $IMAGE_NAME 2>/dev/null || true

echo "Lancement du conteneur $IMAGE_NAME sur http://localhost:8080..."
# -d : lance le conteneur en arrière-plan (detached)
# --name : donne un nom fixe au conteneur au lieu d'un nom aléatoire
# -p : mappe le port 8080
docker run -d --name $IMAGE_NAME -p 8080:8080 $IMAGE_NAME:$TAG

echo "Le conteneur est prêt !"
