#!/bin/bash
# Script de Setup Inicial - Marmitaria Pimenta Doce
# Execute: chmod +x setup.sh && sudo ./setup.sh

set -e

echo "🚀 Instalando Marmitaria Pimenta Doce..."

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar se é root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Por favor, execute como root (sudo)${NC}"
    exit 1
fi

echo -e "${GREEN}1. Instalando Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

echo -e "${GREEN}2. Instalando PostgreSQL...${NC}"
apt-get install -y postgresql postgresql-contrib

echo -e "${GREEN}3. Instalando PM2...${NC}"
npm install -g pm2

echo -e "${GREEN}4. Configurando PostgreSQL...${NC}"
sudo -u postgres psql << EOF
CREATE DATABASE marmitaria;
CREATE USER marmitaria_user WITH PASSWORD 'senha123';
GRANT ALL PRIVILEGES ON DATABASE marmitaria TO marmitaria_user;
ALTER DATABASE marmitaria OWNER TO marmitaria_user;
EOF

echo -e "${GREEN}5. Instalando dependências do projeto...${NC}"
npm install

echo -e "${GREEN}6. Configurando variáveis de ambiente...${NC}"
cat > .env << EOF
DATABASE_URL="postgresql://marmitaria_user:senha123@localhost:5432/marmitaria"
EOF

echo -e "${GREEN}7. Gerando Prisma Client...${NC}"
npx prisma generate

echo -e "${GREEN}8. Executando migrações do banco...${NC}"
npx prisma migrate deploy

echo -e "${GREEN}9. Fazendo build da aplicação...${NC}"
npm run build

echo -e "${GREEN}10. Iniciando aplicação com PM2...${NC}"
pm2 start ecosystem.config.js
pm2 save
pm2 startup systemd

echo ""
echo -e "${GREEN}✅ Instalação concluída!${NC}"
echo ""
echo -e "${YELLOW}Aplicação rodando em:${NC}"
echo -e "  - Local: http://localhost:3000"
echo -e "  - Rede:  http://$(hostname -I | awk '{print $1}'):3000"
echo ""
echo -e "${YELLOW}Comandos úteis:${NC}"
echo -e "  pm2 logs marmitaria    - Ver logs"
echo -e "  pm2 restart marmitaria - Reiniciar"
echo -e "  pm2 status             - Status"
echo ""
