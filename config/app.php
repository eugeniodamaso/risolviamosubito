<?php
/**
 * RisolviAmoSubito Application Configuration
 */

// Application Info
define('APP_NAME', getenv('APP_NAME') ?: 'RisolviAmoSubito');
define('APP_VERSION', '1.0.0');
define('APP_URL', getenv('APP_URL') ?: 'http://localhost');
define('APP_ENV', getenv('APP_ENV') ?: 'production');
define('APP_DEBUG', getenv('APP_DEBUG') === 'true');

// Security
define('APP_SECRET', getenv('APP_SECRET') ?: 'your-secret-key-here');
define('SESSION_LIFETIME', (int)(getenv('SESSION_LIFETIME') ?: 3600 * 24 * 7)); // 1 week
define('CSRF_TOKEN_LIFETIME', (int)(getenv('CSRF_TOKEN_LIFETIME') ?: 3600)); // 1 hour

// Database Configuration
define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_NAME', getenv('DB_NAME') ?: 'risolviamosubito');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASS', getenv('DB_PASS') ?: '');
define('DB_PORT', (int)(getenv('DB_PORT') ?: 3306));
define('DB_CHARSET', getenv('DB_CHARSET') ?: 'utf8mb4');

// Redis Configuration
define('REDIS_HOST', getenv('REDIS_HOST') ?: 'localhost');
define('REDIS_PORT', (int)(getenv('REDIS_PORT') ?: 6379));
define('REDIS_PASSWORD', getenv('REDIS_PASSWORD') ?: '');

// Email Configuration
define('MAIL_HOST', getenv('MAIL_HOST') ?: 'localhost');
define('MAIL_PORT', (int)(getenv('MAIL_PORT') ?: 587));
define('MAIL_USERNAME', getenv('MAIL_USERNAME') ?: '');
define('MAIL_PASSWORD', getenv('MAIL_PASSWORD') ?: '');
define('MAIL_FROM_ADDRESS', getenv('MAIL_FROM_ADDRESS') ?: 'noreply@risolviamosubito.it');
define('MAIL_FROM_NAME', getenv('MAIL_FROM_NAME') ?: 'RisolviAmoSubito');

// Features
define('ENABLE_ANALYTICS', getenv('ENABLE_ANALYTICS') === 'true');
define('ENABLE_MARKETING_COOKIES', getenv('ENABLE_MARKETING_COOKIES') === 'true');
define('ENABLE_DEBUG_TOOLBAR', getenv('ENABLE_DEBUG_TOOLBAR') === 'true' && APP_DEBUG);

// AI Scoring Configuration
define('AI_SCORE_MIN_APPROVAL', (float)(getenv('AI_SCORE_MIN_APPROVAL') ?: 7.0));
define('AI_SCORE_MANUAL_REVIEW', (float)(getenv('AI_SCORE_MANUAL_REVIEW') ?: 5.0));

// Upload Settings
define('UPLOAD_MAX_SIZE', (int)(getenv('UPLOAD_MAX_SIZE') ?: 10485760)); // 10MB
define('UPLOAD_ALLOWED_TYPES', explode(',', getenv('UPLOAD_ALLOWED_TYPES') ?: 'jpg,jpeg,png,pdf'));
define('UPLOAD_PATH', __DIR__ . '/../uploads');

// Paths
define('ROOT_PATH', __DIR__ . '/..');
define('PUBLIC_PATH', ROOT_PATH . '/public');
define('ASSETS_PATH', PUBLIC_PATH . '/assets');
define('TEMPLATES_PATH', ROOT_PATH . '/templates');
define('LOGS_PATH', ROOT_PATH . '/logs');

// Create directories if they don't exist
$dirs = [UPLOAD_PATH, LOGS_PATH];
foreach ($dirs as $dir) {
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }
}

// Locale Settings
define('DEFAULT_LOCALE', 'it_IT');
define('DEFAULT_TIMEZONE', 'Europe/Rome');

// Cache Settings
define('CACHE_ENABLED', getenv('CACHE_ENABLED') !== 'false');
define('CACHE_TTL', (int)(getenv('CACHE_TTL') ?: 3600)); // 1 hour

// Rate Limiting
define('RATE_LIMIT_ENABLED', getenv('RATE_LIMIT_ENABLED') !== 'false');
define('RATE_LIMIT_MAX_REQUESTS', (int)(getenv('RATE_LIMIT_MAX_REQUESTS') ?: 100));
define('RATE_LIMIT_WINDOW', (int)(getenv('RATE_LIMIT_WINDOW') ?: 3600)); // 1 hour

// Business Logic Constants
define('MAX_PROBLEM_TITLE_LENGTH', 200);
define('MAX_PROBLEM_DESCRIPTION_LENGTH', 2000);
define('MAX_PARTNER_DESCRIPTION_LENGTH', 500);
define('MATCH_EXPIRY_HOURS', 2);
define('PARTNER_RESPONSE_TIMEOUT_HOURS', 24);

// Service Categories
define('SERVICE_CATEGORIES', [
    'plumbing' => 'Idraulico',
    'electrical' => 'Elettricista', 
    'cleaning' => 'Pulizie',
    'handyman' => 'Tuttofare',
    'tech' => 'Assistenza Informatica',
    'legal' => 'Servizi Legali',
    'accounting' => 'Commercialista',
    'beauty' => 'Estetica',
    'fitness' => 'Personal Trainer',
    'education' => 'Lezioni Private',
    'gardening' => 'Giardinaggio',
    'moving' => 'Traslochi'
]);

// Italian Cities (Major ones)
define('ITALIAN_CITIES', [
    'Milano', 'Roma', 'Napoli', 'Torino', 'Palermo', 'Genova', 'Bologna', 
    'Firenze', 'Bari', 'Catania', 'Venezia', 'Verona', 'Messina', 'Padova',
    'Trieste', 'Brescia', 'Taranto', 'Prato', 'Parma', 'Modena', 'Reggio Calabria',
    'Reggio Emilia', 'Perugia', 'Livorno', 'Ravenna', 'Cagliari', 'Foggia',
    'Rimini', 'Salerno', 'Ferrara', 'Sassari', 'Latina', 'Giugliano', 'Monza'
]);

// Urgency Levels
define('URGENCY_LEVELS', [
    'low' => 'Bassa',
    'medium' => 'Media',
    'high' => 'Alta', 
    'urgent' => 'Urgente'
]);

// Status Types
define('PROBLEM_STATUSES', [
    'open' => 'Aperto',
    'matched' => 'Abbinato',
    'in_progress' => 'In Corso',
    'completed' => 'Completato',
    'cancelled' => 'Annullato'
]);

define('PARTNER_STATUSES', [
    'pending' => 'In Attesa',
    'approved' => 'Approvato',
    'rejected' => 'Rifiutato',
    'suspended' => 'Sospeso'
]);