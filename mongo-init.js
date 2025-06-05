// Arquivo de inicialização do MongoDB
// filepath: /home/breia/lab/estudos/datacloud/mongo-init.js

// Criar um usuário para o banco de dados projeto1db
db = db.getSiblingDB('projeto1db');

// Criar um usuário com permissões de leitura e escrita
db.createUser({
    user: "user",
    pwd: "password",
    roles: [
        {
            role: "readWrite",
            db: "projeto1db"
        }
    ]
});

// Criar uma coleção de exemplo
db.createCollection("exemplo");

// Inserir um documento de teste
db.exemplo.insertOne({
    mensagem: "MongoDB inicializado com sucesso!",
    timestamp: new Date(),
    projeto: "datacloud"
});

print("Inicialização do MongoDB concluída!");
