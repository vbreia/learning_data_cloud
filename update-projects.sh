#!/bin/bash

# Script para adicionar automaticamente novos projetos ao docker-compose.yaml

echo "Detectando pastas de projeto..."

projeto_dirs=$(find . -maxdepth 1 -name "projeto_*" -type d | sort -V)

if [ -z "$projeto_dirs" ]; then
    echo "Nenhuma pasta de projeto encontrada!"
    exit 1
fi

echo "Pastas encontradas:"
for dir in $projeto_dirs; do
    echo "  - $dir"
done


cp docker-compose.yaml docker-compose.yaml.bak
echo "Atualizando docker-compose.yaml..."
cat > docker-compose.yaml << EOF
version: '3.8'

services:
    db:
        image: postgres:16
        container_name: projeto1_postgres
        environment:
            POSTGRES_USER: user
            POSTGRES_PASSWORD: password
            POSTGRES_DB: projeto1db
        volumes:
            - ./init.sh:/docker-entrypoint-initdb.d/init.sh
EOF

for projeto_dir in $projeto_dirs; do
    clean_dir=${projeto_dir#./}
    echo "            - ./$clean_dir:/$clean_dir/" >> docker-compose.yaml
done


cat >> docker-compose.yaml << EOF
        ports:
            - "5432:5432"
        restart: unless-stopped
EOF

echo "✓ docker-compose.yaml atualizado!"
echo "✓ Backup salvo como docker-compose.yaml.bak"
echo ""
echo "Para aplicar as mudanças, execute:"
echo "  docker-compose down && docker-compose up -d"
