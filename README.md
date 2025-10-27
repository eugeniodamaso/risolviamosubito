# RisolviAmoSubito.it

🚀 **Marketplace intelligente per servizi professionali**

Piattaforma moderna che connette clienti e professionisti attraverso matching avanzato, garantendo risoluzione rapida dei problemi con soddisfazione garantita.

## ✨ Caratteristiche Principali

- **Registrazione Semplificata**: Account attivo in 30 secondi
- **Matching Intelligente**: Algoritmo di scoring automatico per professionisti  
- **Privacy Compliant**: Gestione cookie GDPR nativa
- **Mobile First**: Design responsive ottimizzato
- **Sicurezza Avanzata**: Protezione XSS, CSRF, SQL Injection

## 🛠️ Tech Stack

- **Backend**: PHP 8.2+ puro, architettura MVC
- **Database**: MySQL 8.0 con spatial extensions
- **Frontend**: Vanilla JavaScript ES6+, CSS Grid/Flexbox
- **Caching**: Redis per sessioni e cache
- **Deployment**: Docker + Docker Compose

## 🚀 Quick Start

### Prerequisiti
- Docker & Docker Compose
- Git

### Installazione

```bash
# Clone repository
git clone https://github.com/eugeniodamaso/risolviamosubito.git
cd risolviamosubito

# Avvia con Docker
chmod +x deploy.sh
./deploy.sh

# Oppure manualmente
docker-compose up -d
```

### Configurazione

1. Copia `.env.example` in `.env`
2. Configura le variabili d'ambiente
3. Il database viene inizializzato automaticamente

### Accesso

- **Website**: https://localhost
- **Database**: localhost:3306
- **Redis**: localhost:6379

## 📁 Struttura Progetto

```
risolviamosubito/
├── public/                 # Web root
├── src/                   # Business logic
├── templates/             # View templates
├── database/              # Schema e migrations
├── docker/                # Docker configuration
└── config/                # App configuration
```

## 🔧 Features Implementate

### Registrazione & Autenticazione
- [x] Registrazione clienti semplificata
- [x] Registrazione professionisti con scoring
- [x] Validazione telefono (no SMS)
- [x] Login/logout sicuro

### Privacy & Cookie
- [x] Banner cookie consent
- [x] Personalizzazione preferenze
- [x] Storage consensi database
- [x] GDPR compliant

### Sistema Qualità
- [x] Scoring automatico professionisti
- [x] Approvazione immediata (80% casi)
- [x] Review manuale per edge cases

## 🚀 Deploy in Produzione

### Hosting Raccomandato
- **VPS**: Almeno 2GB RAM, 20GB SSD
- **CDN**: Cloudflare per performance
- **SSL**: Let's Encrypt automatico
- **Backup**: Database daily backup

### Configurazione Produzione

```bash
# Set environment
export APP_ENV=production
export APP_DEBUG=false
export DB_HOST=your-db-host
export DB_PASS=your-secure-password

# Deploy
./deploy.sh
```

## 📊 Performance Target

- **Page Load**: <2s first paint
- **Database**: <100ms query response
- **Concurrent Users**: 1000+ simultaneous
- **Uptime**: 99.9% SLA

## 🔒 Sicurezza

- Password hashing: Argon2ID
- Session security: httpOnly, secure, sameSite
- CSRF protection: Token validation
- XSS protection: Input sanitization
- SQL Injection: Prepared statements

## 🤝 Contribuire

1. Fork del repository
2. Crea feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push branch (`git push origin feature/AmazingFeature`)
5. Apri Pull Request

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🎯 Roadmap

- [ ] App mobile nativa
- [ ] API REST complete
- [ ] Sistema pagamenti
- [ ] Chat in tempo reale
- [ ] Geolocalizzazione avanzata
- [ ] Sistema recensioni

## 📞 Supporto

- Email: info@risolviamosubito.it
- Issues: [GitHub Issues](https://github.com/eugeniodamaso/risolviamosubito/issues)

---

**Made with ❤️ in Italy**