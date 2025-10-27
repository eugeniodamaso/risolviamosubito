-- RisolviAmoSubito Database Schema
-- MySQL 8.0+ with spatial extensions

CREATE DATABASE IF NOT EXISTS risolviamosubito CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE risolviamosubito;

-- Users table with phone support
CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid CHAR(36) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20), -- Optional for customers, required for partners
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('customer', 'partner', 'admin') NOT NULL DEFAULT 'customer',
    status ENUM('active', 'pending', 'suspended') DEFAULT 'active',
    profile_data JSON,
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_user_type (user_type),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB;

-- Partner profiles with AI scoring
CREATE TABLE partner_profiles (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    business_name VARCHAR(255),
    service_category VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    experience_years TINYINT UNSIGNED DEFAULT 0,
    service_description TEXT,
    service_area POLYGON,
    
    -- AI scoring system
    quality_score DECIMAL(3,1) DEFAULT 5.0,
    approval_status ENUM('pending', 'approved', 'rejected', 'suspended') DEFAULT 'pending',
    auto_approved BOOLEAN DEFAULT FALSE,
    
    -- Performance metrics
    jobs_completed INT DEFAULT 0,
    jobs_cancelled INT DEFAULT 0,
    rating_avg DECIMAL(2,1) DEFAULT 0,
    rating_count INT DEFAULT 0,
    response_time_minutes INT DEFAULT 0,
    success_rate DECIMAL(5,2) DEFAULT 0,
    
    -- Availability
    is_available BOOLEAN DEFAULT TRUE,
    last_active TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_service_city (service_category, city),
    INDEX idx_approval_status (approval_status),
    INDEX idx_quality_score (quality_score),
    INDEX idx_rating (rating_avg, rating_count),
    INDEX idx_availability (is_available, last_active),
    SPATIAL INDEX idx_service_area (service_area)
) ENGINE=InnoDB;

-- Problems submitted by customers
CREATE TABLE problems (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid CHAR(36) UNIQUE NOT NULL,
    customer_id INT UNSIGNED NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    urgency ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    
    -- Location data
    city VARCHAR(100) NOT NULL,
    address VARCHAR(500),
    location POINT,
    
    -- Budget
    budget_min DECIMAL(8,2),
    budget_max DECIMAL(8,2),
    
    -- Status tracking
    status ENUM('open', 'matched', 'in_progress', 'completed', 'cancelled') DEFAULT 'open',
    assigned_partner_id INT UNSIGNED NULL,
    
    -- Timing
    required_by TIMESTAMP NULL,
    matched_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    
    -- Metadata
    attachments JSON,
    matching_data JSON,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_partner_id) REFERENCES partner_profiles(id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_category_city (category, city),
    INDEX idx_urgency (urgency),
    INDEX idx_created_at (created_at),
    INDEX idx_customer_id (customer_id),
    INDEX idx_assigned_partner (assigned_partner_id),
    SPATIAL INDEX idx_location (location),
    FULLTEXT INDEX idx_search (title, description)
) ENGINE=InnoDB;

-- AI matching results
CREATE TABLE matches (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid CHAR(36) UNIQUE NOT NULL,
    problem_id INT UNSIGNED NOT NULL,
    partner_id INT UNSIGNED NOT NULL,
    
    -- AI scoring
    confidence_score DECIMAL(5,4) NOT NULL,
    match_reasoning TEXT,
    estimated_duration_minutes INT,
    estimated_cost DECIMAL(10,2),
    
    -- Status
    status ENUM('suggested', 'accepted', 'declined', 'expired') DEFAULT 'suggested',
    partner_response TEXT,
    
    -- Timing
    expires_at TIMESTAMP,
    responded_at TIMESTAMP NULL,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (problem_id) REFERENCES problems(id) ON DELETE CASCADE,
    FOREIGN KEY (partner_id) REFERENCES partner_profiles(id) ON DELETE CASCADE,
    INDEX idx_problem_id (problem_id),
    INDEX idx_partner_id (partner_id),
    INDEX idx_confidence_score (confidence_score),
    INDEX idx_status (status),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB;

-- Reviews and ratings
CREATE TABLE reviews (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    problem_id INT UNSIGNED NOT NULL,
    customer_id INT UNSIGNED NOT NULL,
    partner_id INT UNSIGNED NOT NULL,
    
    -- Ratings (1-5)
    overall_rating TINYINT UNSIGNED NOT NULL,
    quality_rating TINYINT UNSIGNED,
    speed_rating TINYINT UNSIGNED,
    communication_rating TINYINT UNSIGNED,
    value_rating TINYINT UNSIGNED,
    
    -- Review content
    review_title VARCHAR(200),
    review_text TEXT,
    pros TEXT,
    cons TEXT,
    
    -- Metadata
    is_verified BOOLEAN DEFAULT FALSE,
    is_featured BOOLEAN DEFAULT FALSE,
    helpful_votes INT DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (problem_id) REFERENCES problems(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (partner_id) REFERENCES partner_profiles(id) ON DELETE CASCADE,
    INDEX idx_partner_rating (partner_id, overall_rating),
    INDEX idx_is_verified (is_verified),
    INDEX idx_created_at (created_at),
    FULLTEXT INDEX idx_review_content (review_title, review_text)
) ENGINE=InnoDB;

-- Cookie consent tracking (GDPR)
CREATE TABLE cookie_consents (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(128) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT,
    
    -- Consent categories
    necessary BOOLEAN DEFAULT TRUE,
    analytics BOOLEAN DEFAULT FALSE,
    marketing BOOLEAN DEFAULT FALSE,
    preferences BOOLEAN DEFAULT FALSE,
    
    consent_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    
    INDEX idx_session_id (session_id),
    INDEX idx_consent_date (consent_date),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB;

-- System logs
CREATE TABLE activity_logs (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NULL,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    metadata JSON,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB;

-- Service categories
CREATE TABLE service_categories (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INT DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_slug (slug),
    INDEX idx_is_active (is_active),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB;