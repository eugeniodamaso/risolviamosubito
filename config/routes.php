<?php
/**
 * RisolviAmoSubito Routes Configuration
 * Define all application routes here
 */

use RisolviAmoSubito\Controllers\HomeController;
use RisolviAmoSubito\Controllers\AuthController;
use RisolviAmoSubito\Controllers\ProblemController;
use RisolviAmoSubito\Controllers\PartnerController;
use RisolviAmoSubito\Controllers\ApiController;
use RisolviAmoSubito\Controllers\LegalController;

// Homepage and public pages
$router->get('/', HomeController::class . '@index');
$router->get('/home', HomeController::class . '@index');
$router->get('/come-funziona', HomeController::class . '@howItWorks');
$router->get('/per-professionisti', HomeController::class . '@forProfessionals');
$router->get('/chi-siamo', HomeController::class . '@about');
$router->get('/contatti', HomeController::class . '@contact');
$router->post('/contatti', HomeController::class . '@submitContact');

// Legal pages (GDPR compliance)
$router->get('/privacy', LegalController::class . '@privacy');
$router->get('/terms', LegalController::class . '@terms');
$router->get('/cookie-policy', LegalController::class . '@cookiePolicy');
$router->get('/gdpr', LegalController::class . '@gdpr');

// Authentication routes
$router->get('/login', AuthController::class . '@showLogin');
$router->post('/login', AuthController::class . '@login');
$router->get('/register', AuthController::class . '@showRegister');
$router->post('/register', AuthController::class . '@register');
$router->get('/logout', AuthController::class . '@logout');
$router->post('/logout', AuthController::class . '@logout');

// Password reset
$router->get('/password/reset', AuthController::class . '@showForgotPassword');
$router->post('/password/reset', AuthController::class . '@sendResetLink');
$router->get('/password/reset/{token}', AuthController::class . '@showResetForm');
$router->post('/password/reset/{token}', AuthController::class . '@resetPassword');

// Customer dashboard
$router->get('/dashboard', AuthController::class . '@dashboard');
$router->get('/profile', AuthController::class . '@showProfile');
$router->post('/profile', AuthController::class . '@updateProfile');

// Partner routes
$router->get('/partner/register', PartnerController::class . '@showRegister');
$router->post('/partner/register', PartnerController::class . '@register');
$router->get('/partner/dashboard', PartnerController::class . '@dashboard');
$router->get('/partner/profile', PartnerController::class . '@showProfile');
$router->post('/partner/profile', PartnerController::class . '@updateProfile');
$router->get('/partner/jobs', PartnerController::class . '@jobs');
$router->get('/partner/reviews', PartnerController::class . '@reviews');
$router->get('/partner/settings', PartnerController::class . '@settings');
$router->post('/partner/settings', PartnerController::class . '@updateSettings');

// Problem routes
$router->get('/problem/create', ProblemController::class . '@showCreate');
$router->post('/problem/create', ProblemController::class . '@create');
$router->get('/problem/{uuid}', ProblemController::class . '@show');
$router->post('/problem/{uuid}/cancel', ProblemController::class . '@cancel');
$router->get('/problems', ProblemController::class . '@index'); // Customer's problems

// Matching routes
$router->get('/problem/{uuid}/matches', ProblemController::class . '@showMatches');
$router->post('/problem/{uuid}/select-partner', ProblemController::class . '@selectPartner');

// Reviews
$router->get('/review/{problemId}', ProblemController::class . '@showReview');
$router->post('/review/{problemId}', ProblemController::class . '@submitReview');

// Search and browse
$router->get('/search', HomeController::class . '@search');
$router->get('/browse/{category}', HomeController::class . '@browseCategory');
$router->get('/professionals', HomeController::class . '@browseProfessionals');
$router->get('/professional/{uuid}', HomeController::class . '@showProfessional');

// API Routes for AJAX requests
$router->post('/api/register/customer', ApiController::class . '@registerCustomer');
$router->post('/api/register/partner', ApiController::class . '@registerPartner');
$router->post('/api/login', ApiController::class . '@login');
$router->post('/api/problem/create', ApiController::class . '@createProblem');
$router->get('/api/problem/{uuid}/matches', ApiController::class . '@getProblemMatches');
$router->post('/api/problem/{uuid}/select-partner', ApiController::class . '@selectPartner');
$router->post('/api/partner/{uuid}/respond', ApiController::class . '@partnerRespond');
$router->get('/api/cities/search', ApiController::class . '@searchCities');
$router->get('/api/categories', ApiController::class . '@getCategories');

// Cookie consent API
$router->post('/api/cookie-consent', ApiController::class . '@saveCookieConsent');
$router->get('/api/cookie-consent', ApiController::class . '@getCookieConsent');

// Real-time updates (polling endpoints)
$router->get('/api/notifications', ApiController::class . '@getNotifications');
$router->get('/api/problem/{uuid}/status', ApiController::class . '@getProblemStatus');
$router->get('/api/partner/jobs/pending', ApiController::class . '@getPendingJobs');

// File upload endpoints
$router->post('/api/upload/avatar', ApiController::class . '@uploadAvatar');
$router->post('/api/upload/problem-attachment', ApiController::class . '@uploadProblemAttachment');
$router->post('/api/upload/portfolio', ApiController::class . '@uploadPortfolioImage');

// Admin routes (protected)
$router->get('/admin', AuthController::class . '@adminDashboard');
$router->get('/admin/partners', AuthController::class . '@adminPartners');
$router->post('/admin/partner/{id}/approve', AuthController::class . '@approvePartner');
$router->post('/admin/partner/{id}/reject', AuthController::class . '@rejectPartner');
$router->get('/admin/problems', AuthController::class . '@adminProblems');
$router->get('/admin/reviews', AuthController::class . '@adminReviews');
$router->get('/admin/stats', AuthController::class . '@adminStats');

// Health check and monitoring
$router->get('/health', ApiController::class . '@healthCheck');
$router->get('/status', ApiController::class . '@systemStatus');

// Sitemap and SEO
$router->get('/sitemap.xml', HomeController::class . '@sitemap');
$router->get('/robots.txt', HomeController::class . '@robots');

// Webhooks (for external integrations)
$router->post('/webhook/payment', ApiController::class . '@paymentWebhook');
$router->post('/webhook/email', ApiController::class . '@emailWebhook');

// Error pages
$router->get('/404', HomeController::class . '@notFound');
$router->get('/500', HomeController::class . '@serverError');
$router->get('/maintenance', HomeController::class . '@maintenance');