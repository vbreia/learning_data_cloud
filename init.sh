#!/bin/bash

until psql -U user -d projeto1db -c '\q'; do
  echo "Postgres ainda não está pronto - aguardando..."
  sleep 2
done

echo "PostgreSQL está pronto! Criando banco de dados 'ed'..."

psql -U user -d projeto1db -c "CREATE DATABASE ed;"

echo "Verificando se a database 'ed' está disponível..."
until psql -U user -d ed -c '\q'; do
  echo "Database 'ed' ainda não está disponível - aguardando..."
  sleep 1
done

echo "Database 'ed' está pronta para uso!"

echo "Descobrindo pastas de projetos automaticamente..."

projeto_dirs=$(find /projeto_* -maxdepth 0 -type d 2>/dev/null | sort -V)

if [ -z "$projeto_dirs" ]; then
    echo "Nenhuma pasta de projeto encontrada!"
    exit 1
fi

for projeto_dir in $projeto_dirs; do
    projeto_name=$(basename "$projeto_dir")
    echo "Processando: $projeto_name"
    
    sql_files=$(find "$projeto_dir" -name "*.sql" -type f | sort -V)
    
    if [ -n "$sql_files" ]; then
        echo "Arquivos SQL encontrados em $projeto_name:"
        echo "$sql_files"
        
        for sql_file in $sql_files; do
            echo "Executando: $sql_file"
            psql -U user -d ed -f "$sql_file"
            
            if [ $? -ne 0 ]; then
                echo "ERRO ao executar $sql_file"
            else
                echo "✓ $sql_file executado com sucesso"
            fi
        done
    else
        echo "Nenhum arquivo SQL encontrado em $projeto_name"
    fi
    
    echo "----------------------------------------"
done

echo "Inicialização completa! Todos os projetos foram processados."
