-- =====================================================
-- 为 users 表添加 login_count 字段
-- 在 Supabase SQL Editor 中执行此脚本
-- =====================================================

-- 1. 添加 login_count 字段（已存在则跳过）
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS login_count INTEGER DEFAULT 0;

-- 2. 初始化：把现有用户的登录次数置为 0（如果是 NULL）
UPDATE users SET login_count = 0 WHERE login_count IS NULL;

SELECT '✅ login_count 字段添加完成！' AS status;
