-- =====================================================
-- 用户系统迁移 v1 - 手机号登录
-- 在 Supabase SQL Editor 中执行此脚本
-- =====================================================

-- 1. 添加手机号字段
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20) UNIQUE;

-- 2. 添加验证状态
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone_verified BOOLEAN DEFAULT false;

-- 3. 添加注册时间
ALTER TABLE users ADD COLUMN IF NOT EXISTS registered_at TIMESTAMP DEFAULT NOW();

-- 4. 确保 nickname 唯一（已有唯一约束，但确认一下）
-- 注意：如果有重复昵称，需要先清理

-- 5. 创建昵称检查函数（用于注册时校验）
CREATE OR REPLACE FUNCTION check_nickname_exists(p_nickname VARCHAR)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (SELECT 1 FROM users WHERE nickname = p_nickname);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. 创建手机号检查函数
CREATE OR REPLACE FUNCTION check_phone_exists(p_phone VARCHAR)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (SELECT 1 FROM users WHERE phone = p_phone);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

SELECT '✅ 用户系统迁移完成！' AS status;
