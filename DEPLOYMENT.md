# RisolviAmoSubito.it - Guida al Deployment

## 🚀 Deploy in 5 Minuti

### Prerequisiti
- Server con Docker e Docker Compose installati
- Dominio puntato al server (per SSL)
- Porte 80, 443, 3306, 6379 disponibili

### Quick Start

```bash
# Clone il repository
git clone https://github.com/eugeniodamaso/risolviamosubito.git
cd risolviamosubito

# Configura environment
cp .env.example .env
# Modifica .env con le tue impostazioni

# Deploy completo
chmod +x deploy.sh
./deploy.sh
```

### Configurazione .env Produzione

```env
# Essenziale per produzione
APP_URL=https://tuodominio.it
APP_ENV=production
APP_DEBUG=false
APP_SECRET=genera-chiave-sicura-qui

# Database (cambia passwords!)
DB_HOST=database
DB_NAME=risolviamosubito
DB_USER=risolviamosubito_user
DB_PASS=password-sicura-database

# Email per invio notifiche
MAIL_HOST=smtp.tuoprovider.com
MAIL_USERNAME=noreply@tuodominio.it
MAIL_PASSWORD=password-email
```

## 🏗️ Architettura del Sistema

### Servizi Docker
- **web**: PHP 8.2 + Apache + SSL
- **database**: MySQL 8.0 con dati sample
- **redis**: Cache e sessioni
- **phpmyadmin**: Admin database (porta 8080)

### Directory Structure
```
risolviamosubito/
├── public/           # Web root
│   ├── index.php     # Entry point
│   ├── .htaccess     # URL rewriting
│   └── assets/       # CSS, JS, immagini
├── src/              # Business logic
├── templates/        # View templates  
├── database/         # Schema e seed
├── config/           # Configurazioni
├── docker/           # Docker setup
└── logs/             # Application logs
```

## 🔧 Comandi Utili

### Docker Management
```bash
# Visualizza logs
docker-compose logs -f

# Riavvia servizi
docker-compose restart

# Stop completo
docker-compose down

# Rebuild containers
docker-compose build --no-cache
docker-compose up -d

# Accesso container web
docker-compose exec web bash

# Backup database
docker-compose exec database mysqldump -u root -p risolviamosubito > backup.sql
```

### Database Management
```bash
# Accesso MySQL
docker-compose exec database mysql -u root -p risolviamosubito

# Reimporta schema
docker-compose exec database mysql -u root -p risolviamosubito < database/schema.sql

# Aggiungi dati demo
docker-compose exec database mysql -u root -p risolviamosubito < database/seed.sql
```

## 🔒 SSL e Sicurezza

### SSL Automatico (Let's Encrypt)
Il deploy script configura automaticamente SSL se:
- APP_ENV=production in .env
- Dominio valido in APP_URL
- DNS punta al server

### SSL Manuale
```bash
# Entra nel container web
docker-compose exec web bash

# Installa certbot
apt-get update && apt-get install -y certbot python3-certbot-apache

# Ottieni certificato
certbot --apache -d tuodominio.it
```

### Sicurezza Implementata
- Headers di sicurezza (HSTS, CSP, XSS Protection)
- Blocco file sensibili (.env, .git, logs)
- Session security (httpOnly, secure, sameSite)
- Rate limiting basic
- Password hashing con PHP password_hash()
- CSRF protection nei form

## 📊 Monitoraggio

### Health Check
```bash
curl http://localhost/health
# Risposta: {"status":"ok","timestamp":"..."}
```

### Log Files
```bash
# Application logs
tail -f logs/app.log

# Apache logs
tail -f logs/apache_access.log
tail -f logs/apache_error.log

# PHP errors
tail -f logs/php_errors.log
```

### Database Status
- **phpMyAdmin**: http://server:8080
- **Credenziali**: risolviamosubito_user / (password da .env)

## 🚨 Troubleshooting

### Problemi Comuni

#### Errore "Port already in use"
```bash
# Verifica porte occupate
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :3306

# Stop servizi conflittuali
sudo systemctl stop apache2
sudo systemctl stop mysql
```

#### Database non si connette
```bash
# Verifica status MySQL
docker-compose logs database

# Reset completo database
docker-compose down
docker volume rm risolviamosubito_mysql_data
docker-compose up -d
```

#### SSL non funziona
```bash
# Verifica configurazione dominio
nslookup tuodominio.it

# Log SSL Apache
tail -f logs/apache_ssl_error.log

# Test certificato
openssl s_client -connect tuodominio.it:443
```

#### Permessi file
```bash
# Fix permessi
docker-compose exec web chown -R www-data:www-data /var/www/html
docker-compose exec web chmod -R 755 /var/www/html/public
docker-compose exec web chmod -R 777 /var/www/html/logs
docker-compose exec web chmod -R 777 /var/www/html/uploads
```

## 🌟 Features Attive

### Registrazione
- ✅ Clienti: registrazione semplificata
- ✅ Partner: con scoring automatico AI
- ✅ Telefono: validazione senza SMS
- ✅ Email: verifica opzionale

### Privacy & Cookie
- ✅ Banner GDPR compliant
- ✅ Gestione consensi granulare
- ✅ Storage consensi database
- ✅ Privacy Policy / Terms / Cookie Policy

### Sistema AI
- ✅ Scoring automatico partner (>7.0 = approvazione)
- ✅ Matching intelligente problemi-professionisti
- ✅ Validazione input con pattern recognition

### Sicurezza
- ✅ HTTPS redirect automatico
- ✅ Security headers completi
- ✅ Protezione XSS, CSRF, SQL Injection
- ✅ File upload sicuri
- ✅ Rate limiting basic

## 📈 Performance

### Obiettivi
- **Page Load**: <2s first paint
- **Database**: <100ms query response
- **Concurrent Users**: 1000+ simultanei
- **Uptime**: 99.9% SLA

### Ottimizzazioni Attive
- OpCache PHP abilitato
- Compressione GZIP
- Browser caching
- Redis per sessioni
- CDN ready (headers corretti)

## 🤝 Supporto

- **Repository**: https://github.com/eugeniodamaso/risolviamosubito
- **Issues**: [GitHub Issues](https://github.com/eugeniodamaso/risolviamosubito/issues)
- **Email**: info@risolviamosubito.it

---

**Deploy completato!** 🎉 Il tuo RisolviAmoSubito.it è ora live e pronto per conquistare il mercato italiano!