-- Enum types
CREATE TYPE transaction_type AS ENUM (
    'purchase', 
    'payment', 
    'refund', 
    'cash_advance', 
    'fee', 
    'interest'
);

CREATE TYPE transaction_status AS ENUM (
    'pending', 
    'completed', 
    'failed', 
    'reversed'
);

CREATE TYPE installment_status AS ENUM (
    'active', 
    'completed', 
    'defaulted', 
    'cancelled'
);

-- Core tables
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE banks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    swift_code VARCHAR(11) UNIQUE,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE card_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bank_id UUID REFERENCES banks(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    annual_fee DECIMAL(10,2) NOT NULL DEFAULT 0,
    interest_rate DECIMAL(5,2) NOT NULL,
    credit_limit_min DECIMAL(12,2) NOT NULL,
    credit_limit_max DECIMAL(12,2) NOT NULL,
    grace_period INTEGER NOT NULL DEFAULT 0,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_credit_limit CHECK (credit_limit_min <= credit_limit_max)
);

CREATE TABLE credit_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    card_product_id UUID REFERENCES card_products(id),
    card_number VARCHAR(16) NOT NULL UNIQUE,
    card_holder_name VARCHAR(100) NOT NULL,
    expiry_date DATE NOT NULL,
    cvv VARCHAR(4) NOT NULL,
    credit_limit DECIMAL(12,2) NOT NULL,
    current_balance DECIMAL(12,2) DEFAULT 0,
    available_credit DECIMAL(12,2) GENERATED ALWAYS AS (credit_limit - current_balance) STORED,
    statement_date DATE,
    due_date DATE,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_dates CHECK (due_date > statement_date)
);

-- Transaction related tables
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    credit_card_id UUID REFERENCES credit_cards(id) ON DELETE CASCADE,
    type transaction_type NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    description TEXT,
    merchant_name VARCHAR(100),
    transaction_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status transaction_status DEFAULT 'pending',
    reference_number VARCHAR(50) UNIQUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT positive_amount CHECK (amount > 0)
);

CREATE TABLE installment_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID REFERENCES transactions(id) ON DELETE CASCADE,
    credit_card_id UUID REFERENCES credit_cards(id) ON DELETE CASCADE,
    total_amount DECIMAL(12,2) NOT NULL,
    number_of_installments INTEGER NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    monthly_amount DECIMAL(12,2) NOT NULL,
    remaining_amount DECIMAL(12,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status installment_status DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_plan_dates CHECK (end_date > start_date),
    CONSTRAINT positive_installments CHECK (number_of_installments > 0)
);

CREATE TABLE installment_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    installment_plan_id UUID REFERENCES installment_plans(id) ON DELETE CASCADE,
    amount DECIMAL(12,2) NOT NULL,
    due_date DATE NOT NULL,
    paid_date TIMESTAMPTZ,
    status BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT positive_payment CHECK (amount > 0)
);

-- Indexes
CREATE INDEX idx_transactions_card_date ON transactions(credit_card_id, transaction_date);
CREATE INDEX idx_installments_card_status ON installment_plans(credit_card_id, status);
CREATE INDEX idx_cards_user_status ON credit_cards(user_id, status);
CREATE INDEX idx_installment_payments_plan ON installment_payments(installment_plan_id, due_date);

-- Triggers
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER set_timestamp
    BEFORE UPDATE ON credit_cards
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER set_timestamp
    BEFORE UPDATE ON installment_plans
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();
