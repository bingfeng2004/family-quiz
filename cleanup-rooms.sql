-- =====================================================
-- 清理房间脚本
-- 1. 清空所有房间
-- 2. 限制活动房间最多10个
-- 执行前请确认！
-- =====================================================

-- 1. 清空房间表和玩家表
DELETE FROM room_players;
DELETE FROM rooms;

-- 2. 可选：如果只想清理已结束的房间并限制数量，可以这样做：
-- 先删除已结束的房间
-- DELETE FROM room_players WHERE room_id IN (SELECT id FROM rooms WHERE status IN ('ended', 'dismissed', 'finished'));
-- DELETE FROM rooms WHERE status IN ('ended', 'dismissed', 'finished');

-- 3. 可选：创建RLS策略，限制活动房间不超过10个
-- 注意：这个策略会在创建第11个活动房间时阻止插入

SELECT '✅ 房间已清空！' AS status;
