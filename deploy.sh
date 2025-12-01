#!/bin/bash
# Script de Deploy/Atualização - Marmitaria Pimenta Doce
# Execute: ./deploy.sh

set -e

echo "🔄 Atualizando Marmitaria Pimenta Doce..."

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}1. Puxando últimas alterações do GitHub...${NC}"
git pull origin main

echo -e "${GREEN}2. Instalando/atualizando dependências...${NC}"
npm install

echo -e "${GREEN}3. Gerando Prisma Client...${NC}"
npx prisma generate

echo -e "${GREEN}4. Executando migrações do banco...${NC}"
npx prisma migrate deploy

echo -e "${GREEN}5. Fazendo build da aplicação...${NC}"
npm run build

echo -e "${GREEN}6. Reiniciando aplicação...${NC}"
pm2 restart marmitaria

echo ""
echo -e "${GREEN}✅ Deploy concluído!${NC}"
echo ""
echo -e "${YELLOW}Status da aplicação:${NC}"
pm2 status marmitaria
echo ""
