<?php
/**
 * RisolviAmoSubito Bootstrap
 * Initialize the application environment
 */

// PHP version check
if (version_compare(PHP_VERSION, '8.0', '<')) {
    die('RisolviAmoSubito requires PHP 8.0 or higher. Current version: ' . PHP_VERSION);
}

// Class autoloader
spl_autoload_register(function ($class) {
    $prefix = 'RisolviAmoSubito\\';
    $base_dir = __DIR__ . '/src/';
    
    // Check if class uses the namespace prefix
    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0) {
        return;
    }
    
    // Get the relative class name
    $relative_class = substr($class, $len);
    
    // Replace namespace separator with directory separator
    $file = $base_dir . str_replace('\\', '/', $relative_class) . '.php';
    
    // Load the file if it exists
    if (file_exists($file)) {
        require $file;
    }
});

// Load environment configuration
if (file_exists(__DIR__ . '/.env')) {
    $lines = file(__DIR__ . '/.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) {
            continue; // Skip comments
        }
        
        list($name, $value) = explode('=', $line, 2);
        $name = trim($name);
        $value = trim($value);
        
        // Remove quotes if present
        if (($value[0] === '"' && $value[-1] === '"') || ($value[0] === "'" && $value[-1] === "'")) {
            $value = substr($value, 1, -1);
        }
        
        putenv(sprintf('%s=%s', $name, $value));
        $_ENV[$name] = $value;
        $_SERVER[$name] = $value;
    }
}

// Load configuration constants
require_once __DIR__ . '/config/app.php';

// Set timezone for Italy
date_default_timezone_set('Europe/Rome');

// PHP configuration
ini_set('display_errors', getenv('APP_DEBUG') === 'true' ? 1 : 0);
ini_set('display_startup_errors', getenv('APP_DEBUG') === 'true' ? 1 : 0);
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING);

// Session configuration
ini_set('session.cookie_httponly', 1);
ini_set('session.cookie_secure', isset($_SERVER['HTTPS']) ? 1 : 0);
ini_set('session.cookie_samesite', 'Strict');
ini_set('session.use_strict_mode', 1);

// Security headers
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');
header('Referrer-Policy: strict-origin-when-cross-origin');

// HTTPS redirect in production
if (getenv('APP_ENV') === 'production' && !isset($_SERVER['HTTPS'])) {
    $redirect_url = 'https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
    header('HTTP/1.1 301 Moved Permanently');
    header('Location: ' . $redirect_url);
    exit();
}

// Charset
header('Content-Type: text/html; charset=UTF-8');

// Application ready
define('RISOLVIAMOSUBITO_LOADED', true);