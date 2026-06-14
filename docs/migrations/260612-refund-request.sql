-- ============================================================
-- Migration: Refund Request Feature
-- Plan: 260612-0035-refund-request
-- Date: 2026-06-12
-- ============================================================

-- Table 1: refund_requests
-- One refund per order (UNIQUE on order_id)
CREATE TABLE IF NOT EXISTS refund_requests (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    user_id       INT NOT NULL,
    reason        VARCHAR(100) NOT NULL,
    description   TEXT,
    bank_name     VARCHAR(100) NOT NULL,
    bank_account  VARCHAR(50)  NOT NULL,
    bank_holder   VARCHAR(100) NOT NULL,
    refund_amount DOUBLE NOT NULL,
    status        VARCHAR(20)  NOT NULL DEFAULT 'pending',
    admin_note    TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (user_id)  REFERENCES users(id),
    UNIQUE KEY uk_order_refund (order_id)
);

-- Table 2: refund_request_images
-- CASCADE delete when parent refund_request is deleted
CREATE TABLE IF NOT EXISTS refund_request_images (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    refund_request_id  INT          NOT NULL,
    image_url          VARCHAR(500) NOT NULL,
    cloudinary_public_id VARCHAR(200),
    media_type         VARCHAR(10)  DEFAULT 'image',
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (refund_request_id) REFERENCES refund_requests(id) ON DELETE CASCADE
);

-- ============================================================
-- Status flow reference:
--   refund_requests.status: pending → approved → refunded
--                           pending → rejected
--   orders.status when confirmRefunded(): completed → refunded (direct, no intermediate)
-- ============================================================
