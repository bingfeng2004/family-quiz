-- =====================================================
-- 添加用户表缺失字段
-- =====================================================

ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20) UNIQUE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone_verified BOOLEAN DEFAULT false;
ALTER TABLE users ADD COLUMN IF NOT EXISTS registered_at TIMESTAMPTZ DEFAULT NOW();

SELECT '✅ 用户表字段添加完成！' AS status;
