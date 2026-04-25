-- ============================================================
-- 家庭竞答 共享屏幕模式 数据库迁移
-- 运行方式：Supabase SQL Editor → 粘贴执行
-- ============================================================

-- 1. 给 rooms 表增加共享模式字段
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS game_mode TEXT DEFAULT 'versus';
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS buzzer_locked BOOLEAN DEFAULT FALSE;
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS buzzer_player_id TEXT DEFAULT '';
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS buzzer_time BIGINT DEFAULT 0;
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS buzzer_nickname TEXT DEFAULT '';
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS host_name TEXT DEFAULT '';
-- 保存抽取的题目（确保所有玩家看到同一套题）
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS selected_questions JSONB DEFAULT '[]'::jsonb;

-- 2. 给 room_players 表增加抢答标记
ALTER TABLE room_players ADD COLUMN IF NOT EXISTS buzzed BOOLEAN DEFAULT FALSE;

-- 3. 更新 RLS 策略（允许所有人读写新增字段）
DROP POLICY IF EXISTS "Allow all rooms insert" ON rooms;
DROP POLICY IF EXISTS "Allow all rooms update" ON rooms;
DROP POLICY IF EXISTS "Allow all rooms select" ON rooms;

CREATE POLICY "Allow all rooms select" ON rooms FOR SELECT USING (true);
CREATE POLICY "Allow all rooms insert" ON rooms FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow all rooms update" ON rooms FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Allow all room_players insert" ON room_players;
DROP POLICY IF EXISTS "Allow all room_players update" ON room_players;
DROP POLICY IF EXISTS "Allow all room_players select" ON room_players;
DROP POLICY IF EXISTS "Allow all room_players delete" ON room_players;

CREATE POLICY "Allow all room_players select" ON room_players FOR SELECT USING (true);
CREATE POLICY "Allow all room_players insert" ON room_players FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow all room_players update" ON room_players FOR UPDATE USING (true);
CREATE POLICY "Allow all room_players delete" ON room_players FOR DELETE USING (true);

-- 4. 验证
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'rooms' AND column_name IN ('game_mode','buzzer_locked','buzzer_player_id','buzzer_time','buzzer_nickname');
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'room_players' AND column_name = 'buzzed';
