# 🚀 Scripts de Deploy Automatizados

Este projeto inclui scripts para facilitar o deploy em servidor Linux.

## 📦 Setup Inicial (Primeira vez)

Execute no servidor Linux:

```bash
# Clonar o repositório
git clone https://github.com/code-bynary/marmitaria-pimenta-doce.git
cd marmitaria-pimenta-doce

# Dar permissão de execução
chmod +x setup.sh

# Executar setup (instala tudo automaticamente)
sudo ./setup.sh
```

O script `setup.sh` faz:
- ✅ Instala Node.js 18
- ✅ Instala PostgreSQL
- ✅ Instala PM2
- ✅ Cria banco de dados
- ✅ Instala dependências do projeto
- ✅ Executa migrações
- ✅ Faz build da aplicação
- ✅ Inicia a aplicação

**Acesse**: http://SEU-IP:3000 (exemplo: http://192.168.1.175:3000)

---

## 🔄 Atualizações (Deploy)

Para atualizar a aplicação depois de mudanças:

```bash
cd marmitaria-pimenta-doce

# Dar permissão (apenas primeira vez)
chmod +x deploy.sh

# Executar deploy
./deploy.sh
```

O script `deploy.sh` faz:
- ✅ Puxa alterações do GitHub
- ✅ Instala novas dependências
- ✅ Executa migrações
- ✅ Faz rebuild
- ✅ Reinicia a aplicação

---

## ⚙️ Configuração PM2

O arquivo `ecosystem.config.js` configura:
- Nome da aplicação: `marmitaria`
- Porta: `3000`
- Host: `0.0.0.0` (aceita conexões da rede)
- Logs em `./logs/`
- Auto-restart em caso de crash
- Limite de memória: 1GB

---

## 🔍 Comandos Úteis

```bash
# Ver logs em tempo real
pm2 logs marmitaria

# Status da aplicação
pm2 status

# Reiniciar manualmente
pm2 restart marmitaria

# Parar aplicação
pm2 stop marmitaria

# Remover aplicação
pm2 delete marmitaria

# Monitoramento de recursos
pm2 monit

# Ver logs salvos
tail -f logs/combined.log
```

---

## 🔧 Configurações Personalizadas

### Mudar Porta

Edite `ecosystem.config.js`:
```javascript
env: {
  PORT: 8080,  // Mude para a porta desejada
  ...
}
```

Depois reinicie:
```bash
pm2 restart marmitaria
```

### Mudar Senha do Banco

1. Edite `setup.sh` (antes de executar) ou mude manualmente:
```bash
sudo -u postgres psql
ALTER USER marmitaria_user WITH PASSWORD 'nova_senha';
\q
```

2. Atualize `.env`:
```
DATABASE_URL="postgresql://marmitaria_user:nova_senha@localhost:5432/marmitaria"
```

3. Reinicie:
```bash
pm2 restart marmitaria
```

---

## 💾 Backup do Banco

```bash
# Criar backup
pg_dump -U marmitaria_user marmitaria > backup_$(date +%Y%m%d).sql

# Restaurar backup
psql -U marmitaria_user marmitaria < backup_20241201.sql
```

---

## 🆘 Troubleshooting

### Porta 3000 já em uso
```bash
sudo lsof -i :3000
sudo kill -9 <PID>
```

### PostgreSQL não conecta
```bash
sudo systemctl status postgresql
sudo systemctl restart postgresql
```

### Aplicação não inicia
```bash
pm2 logs marmitaria --lines 50
```

### Resetar tudo
```bash
pm2 delete marmitaria
rm -rf node_modules .next
sudo -u postgres dropdb marmitaria
sudo ./setup.sh
```

---

## 📊 Monitoramento

Instale PM2 Plus para monitoramento web (opcional):
```bash
pm2 link <SECRET_KEY> <PUBLIC_KEY>
```

Ou use o monitoramento local:
```bash
pm2 monit
```

---

Pronto! Seu sistema está configurado para deploy automatizado. 🎉
