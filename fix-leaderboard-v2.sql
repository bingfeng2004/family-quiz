-- =====================================================
-- 排行榜函数修复 - 统一返回类型为TEXT
-- 在 Supabase SQL Editor 中执行此脚本
-- =====================================================

-- 1. 删除旧函数
DROP FUNCTION IF EXISTS get_leaderboard(INTEGER);

-- 2. 重新创建函数，统一返回类型为TEXT
CREATE OR REPLACE FUNCTION get_leaderboard(limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
    id TEXT,
    nickname TEXT,
    total_score BIGINT,
    games_played BIGINT,
    games_won BIGINT,
    registered_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(u.id::TEXT, '') as id,
        COALESCE(u.nickname::TEXT, '') as nickname,
        COALESCE(u.total_score, 0)::BIGINT as total_score,
        COALESCE(u.games_played, 0)::BIGINT as games_played,
        COALESCE(u.games_won, 0)::BIGINT as games_won,
        COALESCE(u.registered_at, NOW())::TIMESTAMPTZ as registered_at
    FROM users u
    WHERE u.total_score > 0
    ORDER BY u.total_score DESC, u.games_won DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. 确保匿名执行权限
GRANT EXECUTE ON FUNCTION get_leaderboard TO anon;
GRANT EXECUTE ON FUNCTION get_leaderboard TO authenticated;

SELECT '✅ 排行榜函数修复完成！类型已统一为TEXT' AS status;
