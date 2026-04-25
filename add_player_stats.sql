-- =====================================================
-- 玩家排行系统 - 数据库扩展
-- 在 Supabase SQL Editor 中执行
-- =====================================================

-- 1. 创建玩家统计数据表（用 od_id 标识，localStorage 的 userId）
CREATE TABLE IF NOT EXISTS player_stats (
  od_id VARCHAR(50) PRIMARY KEY,         -- localStorage 里的 quiz_user_id
  nickname VARCHAR(20) NOT NULL,          -- 昵称
  total_score INTEGER DEFAULT 0,           -- 累计总分
  games_played INTEGER DEFAULT 0,         -- 参与局数
  games_won INTEGER DEFAULT 0,            -- 获胜次数
  correct_answers INTEGER DEFAULT 0,       -- 答对题数
  total_answers INTEGER DEFAULT 0,        -- 总答题数
  max_score INTEGER DEFAULT 0,            -- 单局最高分
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 启用实时订阅
ALTER PUBLICATION supabase_realtime ADD TABLE player_stats;

-- 3. 开启 RLS
ALTER TABLE player_stats ENABLE ROW LEVEL SECURITY;

-- 4. 允许所有读写操作（开发环境）
CREATE POLICY "player_stats all" ON player_stats FOR ALL USING (true) WITH CHECK (true);

-- 5. 创建函数：游戏结束时调用，更新/插入玩家统计
CREATE OR REPLACE FUNCTION update_player_stats(
  p_od_id VARCHAR,
  p_nickname VARCHAR,
  p_score INTEGER,
  p_is_winner BOOLEAN,
  p_correct INTEGER DEFAULT 0,
  p_total INTEGER DEFAULT 1
)
RETURNS VOID AS $$
DECLARE
  existing RECORD;
BEGIN
  SELECT * INTO existing FROM player_stats WHERE od_id = p_od_id;

  IF existing.od_id IS NOT NULL THEN
    UPDATE player_stats SET
      nickname = p_nickname,
      total_score = total_score + p_score,
      games_played = games_played + 1,
      games_won = CASE WHEN p_is_winner THEN games_won + 1 ELSE games_won END,
      correct_answers = correct_answers + p_correct,
      total_answers = total_answers + p_total,
      max_score = GREATEST(max_score, p_max_score),
      updated_at = NOW()
    WHERE od_id = p_od_id;
  ELSE
    INSERT INTO player_stats (od_id, nickname, total_score, games_played, games_won,
      correct_answers, total_answers, max_score)
    VALUES (p_od_id, p_nickname, p_score, 1,
      CASE WHEN p_is_winner THEN 1 ELSE 0 END,
      p_correct, p_total, p_score);
  END IF;
END;
$$ LANGUAGE plpgsql;

-- 6. 允许 RPC 调用
GRANT EXECUTE ON FUNCTION update_player_stats TO anon;

-- 7. 查询排行榜 TOP 20
CREATE OR REPLACE FUNCTION get_leaderboard(limit_count INTEGER DEFAULT 20)
RETURNS TABLE (
  rank BIGINT,
  od_id VARCHAR,
  nickname VARCHAR,
  total_score BIGINT,
  games_played BIGINT,
  games_won BIGINT,
  max_score BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ROW_NUMBER() OVER (ORDER BY ps.total_score DESC, ps.games_won DESC)::BIGINT AS rank,
    ps.od_id,
    ps.nickname,
    ps.total_score,
    ps.games_played,
    ps.games_won,
    ps.max_score
  FROM player_stats ps
  ORDER BY ps.total_score DESC, ps.games_won DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION get_leaderboard TO anon;

SELECT '✅ player_stats 表创建成功' AS status;
