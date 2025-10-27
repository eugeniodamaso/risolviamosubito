<?php
/**
 * RisolviAmoSubito.it - Entry Point
 * La piattaforma che risolve qualsiasi problema. SUBITO!
 */

require_once __DIR__ . '/../bootstrap.php';

use RisolviAmoSubito\Core\Router;
use RisolviAmoSubito\Core\Request;
use RisolviAmoSubito\Core\Response;
use RisolviAmoSubito\Utils\Session;

try {
    // Start session with security settings
    Session::start();
    
    // Create request object
    $request = Request::createFromGlobals();
    
    // Initialize router
    $router = new Router();
    
    // Load application routes
    require_once __DIR__ . '/../config/routes.php';
    
    // Handle the request and get response
    $response = $router->handle($request);
    
    // Send response to client
    $response->send();
    
} catch (Throwable $e) {
    // Log error for debugging
    error_log("RisolviAmoSubito Application Error: " . $e->getMessage());
    error_log("Stack trace: " . $e->getTraceAsString());
    
    // Show appropriate error based on environment
    if (getenv('APP_ENV') === 'development') {
        // Show detailed error in development
        echo '<div style="background: #f8d7da; color: #721c24; padding: 20px; margin: 20px; border: 1px solid #f5c6cb; border-radius: 5px;">';
        echo '<h3>Application Error</h3>';
        echo '<p><strong>Message:</strong> ' . htmlspecialchars($e->getMessage()) . '</p>';
        echo '<p><strong>File:</strong> ' . htmlspecialchars($e->getFile()) . ':' . $e->getLine() . '</p>';
        echo '<details><summary>Stack Trace</summary><pre>' . htmlspecialchars($e->getTraceAsString()) . '</pre></details>';
        echo '</div>';
    } else {
        // Show generic error in production
        http_response_code(500);
        echo '<!DOCTYPE html>';
        echo '<html><head><title>Errore - RisolviAmoSubito</title></head><body>';
        echo '<h1>Errore del Server</h1>';
        echo '<p>Si è verificato un errore interno. Riprova più tardi.</p>';
        echo '<a href="/">Torna alla Homepage</a>';
        echo '</body></html>';
    }
}