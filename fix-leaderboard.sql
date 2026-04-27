-- =====================================================
-- 修复排行榜函数
-- 删除旧函数并重新创建
-- =====================================================

DROP FUNCTION IF EXISTS get_leaderboard(INTEGER);

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
        COALESCE(u.nickname, '') as nickname,
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

SELECT '✅ 排行榜函数修复完成！' AS status;
