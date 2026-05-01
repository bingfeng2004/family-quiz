-- =====================================================
-- 家庭竞答应用 - 数据库初始化 & 字段扩展
-- Supabase SQL Editor 中执行
-- 版本：2026.05.01
-- =====================================================

-- ---------------------------------------------------
-- 1. users 表扩展：手机号 + 登录计数
-- ---------------------------------------------------
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20) UNIQUE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone_verified BOOLEAN DEFAULT false;
ALTER TABLE users ADD COLUMN IF NOT EXISTS registered_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE users ADD COLUMN IF NOT EXISTS login_count INTEGER DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMPTZ DEFAULT NOW();
COMMENT ON COLUMN users.login_count IS '用户登录次数';
COMMENT ON COLUMN users.last_login_at IS '最后登录时间';

-- ---------------------------------------------------
-- 2. player_stats 表（玩家排行统计）
-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS player_stats (
  od_id VARCHAR(50) PRIMARY KEY,          -- localStorage 的 quiz_user_id / userId
  nickname VARCHAR(20) NOT NULL,          -- 昵称
  total_score INTEGER DEFAULT 0,          -- 累计总分
  games_played INTEGER DEFAULT 0,          -- 参与局数
  games_won INTEGER DEFAULT 0,             -- 获胜次数
  correct_answers INTEGER DEFAULT 0,       -- 答对题数
  total_answers INTEGER DEFAULT 0,         -- 总答题数
  max_score INTEGER DEFAULT 0,             -- 单局最高分
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 开启 RLS
ALTER TABLE player_stats ENABLE ROW LEVEL SECURITY;
CREATE POLICY "player_stats all" ON player_stats FOR ALL USING (true) WITH CHECK (true);

-- 启用实时订阅（可选）
ALTER PUBLICATION supabase_realtime ADD TABLE player_stats;

-- ---------------------------------------------------
-- 3. 游戏结束时更新玩家统计
-- ---------------------------------------------------
CREATE OR REPLACE FUNCTION update_player_stats(
  p_od_id VARCHAR,
  p_nickname VARCHAR,
  p_score INTEGER,
  p_is_winner BOOLEAN,
  p_correct INTEGER DEFAULT 0,
  p_total INTEGER DEFAULT 1
) RETURNS VOID AS $$
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
      max_score = GREATEST(max_score, p_score),
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

GRANT EXECUTE ON FUNCTION update_player_stats TO anon;

-- ---------------------------------------------------
-- 4. 排行榜查询函数
-- ---------------------------------------------------
CREATE OR REPLACE FUNCTION get_leaderboard(limit_count INTEGER DEFAULT 20)
RETURNS TABLE (
  rank BIGINT,
  od_id TEXT,
  nickname TEXT,
  total_score BIGINT,
  games_played BIGINT,
  games_won BIGINT,
  max_score BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ROW_NUMBER() OVER (ORDER BY ps.total_score DESC, ps.games_won DESC)::BIGINT AS rank,
    ps.od_id::TEXT,
    ps.nickname::TEXT,
    ps.total_score::BIGINT,
    ps.games_played::BIGINT,
    ps.games_won::BIGINT,
    ps.max_score::BIGINT
  FROM player_stats ps
  ORDER BY ps.total_score DESC, ps.games_won DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION get_leaderboard TO anon;

-- ---------------------------------------------------
-- 5. 初始化访问统计表
-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS page_visits (
  id BIGSERIAL PRIMARY KEY,
  ip_address VARCHAR(45),
  user_agent TEXT,
  device_type VARCHAR(20),
  browser VARCHAR(30),
  screen_size VARCHAR(20),
  platform VARCHAR(30),
  language VARCHAR(10),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE page_visits ENABLE ROW LEVEL SECURITY;
CREATE POLICY "page_visits all" ON page_visits FOR ALL USING (true) WITH CHECK (true);

SELECT '✅ 数据库初始化完成' AS status;
