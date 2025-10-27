-- RisolviAmoSubito Seed Data
-- Initial data for development and demo

USE risolviamosubito;

-- Service Categories
INSERT INTO service_categories (name, slug, description, icon, sort_order) VALUES
('Idraulico', 'plumbing', 'Riparazioni e installazioni idrauliche, perdite, scarichi', '🔧', 1),
('Elettricista', 'electrical', 'Impianti elettrici, riparazioni, installazioni', '⚡', 2),
('Pulizie', 'cleaning', 'Pulizie domestiche e professionali', '🧽', 3),
('Tuttofare', 'handyman', 'Piccole riparazioni e manutenzioni', '🔨', 4),
('Assistenza Informatica', 'tech', 'Supporto computer, reti, software', '💻', 5),
('Servizi Legali', 'legal', 'Consulenza legale, contratti, pratiche', '⚖️', 6),
('Commercialista', 'accounting', 'Consulenza fiscale, dichiarazioni, contabilità', '📊', 7),
('Estetica', 'beauty', 'Servizi estetici a domicilio', '💄', 8),
('Personal Trainer', 'fitness', 'Allenamento personale e fitness', '💪', 9),
('Lezioni Private', 'education', 'Ripetizioni e corsi privati', '📚', 10),
('Giardinaggio', 'gardening', 'Cura giardini, potature, manutenzione verde', '🌱', 11),
('Traslochi', 'moving', 'Servizi di trasloco e trasporto', '🚚', 12);

-- Demo Admin User
INSERT INTO users (uuid, email, password_hash, user_type, status, profile_data) VALUES
('admin-uuid-12345', 'admin@risolviamosubito.it', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', JSON_OBJECT('name', 'Admin RisolviAmoSubito'));

-- Demo Customer Users
INSERT INTO users (uuid, email, phone, password_hash, user_type, status, profile_data) VALUES
('customer-uuid-001', 'mario.rossi@example.com', '+39 333 123 4567', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer', 'active', JSON_OBJECT('name', 'Mario Rossi', 'city', 'Milano')),
('customer-uuid-002', 'laura.bianchi@example.com', '+39 340 987 6543', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer', 'active', JSON_OBJECT('name', 'Laura Bianchi', 'city', 'Roma')),
('customer-uuid-003', 'giovanni.verdi@example.com', NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer', 'active', JSON_OBJECT('name', 'Giovanni Verdi', 'city', 'Napoli'));

-- Demo Partner Users
INSERT INTO users (uuid, email, phone, password_hash, user_type, status, profile_data) VALUES
('partner-uuid-001', 'marco.fontaniere@example.com', '+39 335 111 2222', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'partner', 'active', JSON_OBJECT('name', 'Marco Fontaniere')),
('partner-uuid-002', 'giuseppe.elettrico@example.com', '+39 338 333 4444', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'partner', 'active', JSON_OBJECT('name', 'Giuseppe Elettrico')),
('partner-uuid-003', 'anna.pulizie@example.com', '+39 347 555 6666', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'partner', 'active', JSON_OBJECT('name', 'Anna Pulizie')),
('partner-uuid-004', 'luca.informatico@example.com', '+39 349 777 8888', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'partner', 'active', JSON_OBJECT('name', 'Luca Informatico'));

-- Demo Partner Profiles
INSERT INTO partner_profiles (user_id, business_name, service_category, city, experience_years, service_description, quality_score, approval_status, auto_approved, jobs_completed, rating_avg, rating_count, is_available) VALUES
(4, 'Marco Fontaniere - Idraulico Milano', 'plumbing', 'Milano', 12, 'Idraulico esperto con 12 anni di esperienza. Specializzato in perdite, installazioni e riparazioni urgenti. Disponibile 24/7 per emergenze.', 9.2, 'approved', TRUE, 247, 4.9, 187, TRUE),
(5, 'Giuseppe Elettrico - Impianti Roma', 'electrical', 'Roma', 8, 'Elettricista qualificato per impianti civili e industriali. Certificazioni aggiornate, lavoro sempre a norma di legge.', 8.7, 'approved', TRUE, 156, 4.8, 123, TRUE),
(6, 'Anna Pulizie - Servizi Milano', 'cleaning', 'Milano', 6, 'Servizio di pulizie professionali per casa e ufficio. Team qualificato, prodotti ecologici, massima puntualità.', 9.5, 'approved', TRUE, 89, 5.0, 76, TRUE),
(7, 'Luca Informatico - Tech Support', 'tech', 'Torino', 5, 'Assistenza informatica a 360°: riparazione PC, configurazione reti, installazione software. Interventi rapidi e risolutivi.', 8.3, 'approved', TRUE, 134, 4.7, 98, TRUE);

-- Demo Problems
INSERT INTO problems (uuid, customer_id, title, description, category, urgency, city, address, budget_min, budget_max, status, location) VALUES
('problem-uuid-001', 1, 'Perdita acqua dal rubinetto cucina', 'Il rubinetto della cucina perde continuamente acqua dalla base. La perdita è iniziata ieri sera e sta peggiorando. Urgente riparazione.', 'plumbing', 'high', 'Milano', 'Via Roma 123, Milano', 50, 150, 'open', POINT(9.1900, 45.4642)),
('problem-uuid-002', 2, 'Blackout parziale appartamento', 'Saltata corrente in cucina e bagno, il resto della casa funziona normalmente. Potrebbero essere i fusibili o problema impianto.', 'electrical', 'urgent', 'Roma', 'Via del Corso 456, Roma', 100, 300, 'open', POINT(12.4964, 41.9028)),
('problem-uuid-003', 3, 'Pulizie post ristrutturazione', 'Necessarie pulizie approfondite dopo ristrutturazione bagno. Molta polvere e residui di cemento. Appartamento 80mq.', 'cleaning', 'medium', 'Napoli', 'Via Partenope 789, Napoli', 200, 400, 'open', POINT(14.2681, 40.8518));

-- Demo Matches (AI generated)
INSERT INTO matches (uuid, problem_id, partner_id, confidence_score, match_reasoning, estimated_duration_minutes, estimated_cost, status, expires_at) VALUES
('match-uuid-001', 1, 1, 0.9234, 'Professionista esperto in riparazioni idrauliche con ottima valutazione e vicinanza geografica. Disponibile per interventi urgenti.', 90, 120, 'suggested', DATE_ADD(NOW(), INTERVAL 2 HOUR)),
('match-uuid-002', 2, 2, 0.8876, 'Elettricista qualificato con esperienza in impianti civili. Situato nella stessa città, disponibile per emergenze elettriche.', 120, 250, 'suggested', DATE_ADD(NOW(), INTERVAL 2 HOUR)),
('match-uuid-003', 3, 3, 0.9567, 'Servizio pulizie professionale specializzato in post-ristrutturazione. Eccellenti recensioni e team qualificato.', 240, 350, 'suggested', DATE_ADD(NOW(), INTERVAL 2 HOUR));

-- Demo Reviews
INSERT INTO reviews (problem_id, customer_id, partner_id, overall_rating, quality_rating, speed_rating, communication_rating, value_rating, review_title, review_text, is_verified) VALUES
(1, 1, 1, 5, 5, 5, 5, 4, 'Servizio eccellente e veloce', 'Marco è arrivato in 30 minuti e ha risolto il problema in un ora. Molto professionale, pulito nel lavoro e onesto nel prezzo. Lo consiglio vivamente!', TRUE),
(2, 2, 2, 5, 5, 4, 5, 5, 'Problema risolto perfettamente', 'Giuseppe ha individuato subito il guasto e lo ha riparato in tempi record. Molto competente e disponibile a spiegare il lavoro svolto.', TRUE),
(3, 3, 3, 5, 5, 5, 5, 5, 'Pulizie impeccabili', 'Anna e il suo team hanno fatto un lavoro straordinario. Casa come nuova dopo la ristrutturazione. Puntualissimi e molto attenti ai dettagli.', TRUE);

-- Update partner statistics based on demo data
UPDATE partner_profiles SET 
    jobs_completed = jobs_completed + 1,
    rating_avg = (
        SELECT ROUND(AVG(overall_rating), 1) 
        FROM reviews 
        WHERE reviews.partner_id = partner_profiles.id
    ),
    rating_count = (
        SELECT COUNT(*) 
        FROM reviews 
        WHERE reviews.partner_id = partner_profiles.id
    )
WHERE id IN (1, 2, 3, 4);