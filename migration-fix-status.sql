-- =====================================================
-- 数据库迁移脚本 v2 - 修复房间状态不一致问题
-- 在 Supabase SQL Editor 中执行此脚本
-- =====================================================

-- 1. 更新 rooms 表的 status 约束，允许更多状态
ALTER TABLE rooms DROP CONSTRAINT IF EXISTS rooms_status_check;
ALTER TABLE rooms ADD CONSTRAINT rooms_status_check 
  CHECK (status IN ('waiting', 'playing', 'ended', 'dismissed', 'finished'));

-- 2. 添加 host_name 字段（如果不存在）
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'rooms' AND column_name = 'host_name') THEN
        ALTER TABLE rooms ADD COLUMN host_name VARCHAR(50);
    END IF;
END $$;

-- 3. 添加 game_mode 字段（如果不存在）
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'rooms' AND column_name = 'game_mode') THEN
        ALTER TABLE rooms ADD COLUMN game_mode VARCHAR(20) DEFAULT 'shared';
    END IF;
END $$;

-- 4. 添加抢答相关字段（如果不存在）
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'rooms' AND column_name = 'buzzer_locked') THEN
        ALTER TABLE rooms ADD COLUMN buzzer_locked BOOLEAN DEFAULT false;
        ALTER TABLE rooms ADD COLUMN buzzer_player_id VARCHAR(50);
        ALTER TABLE rooms ADD COLUMN buzzer_time BIGINT DEFAULT 0;
        ALTER TABLE rooms ADD COLUMN buzzer_nickname VARCHAR(50);
    END IF;
END $$;

-- 5. 添加 selected_questions 字段（如果不存在）
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'rooms' AND column_name = 'selected_questions') THEN
        ALTER TABLE rooms ADD COLUMN selected_questions JSONB;
    END IF;
END $$;

SELECT '✅ 数据库迁移完成！' AS status;
