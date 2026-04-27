-- =====================================================
-- 排行榜函数迁移
-- 在 Supabase SQL Editor 中执行此脚本
-- =====================================================

-- 创建排行榜 RPC 函数
CREATE OR REPLACE FUNCTION get_leaderboard(limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
    id UUID,
    nickname VARCHAR(20),
    total_score INTEGER,
    games_played INTEGER,
    games_won INTEGER,
    registered_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.id, u.nickname, u.total_score, u.games_played, u.games_won, u.registered_at
    FROM users u
    WHERE u.total_score > 0
    ORDER BY u.total_score DESC, u.games_won DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 为 users 表添加 RLS 策略（允许匿名读取排行榜）
DROP POLICY IF EXISTS "Allow anonymous read" ON users;
CREATE POLICY "Allow anonymous read" ON users
    FOR SELECT USING (true);

-- 确保 RLS 已启用
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

SELECT '✅ 排行榜函数创建成功！' AS status;
