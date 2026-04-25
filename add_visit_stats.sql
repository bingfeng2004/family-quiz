-- ============================================================
-- 家庭知识竞答 — 访问统计表初始化
-- 执行位置：Supabase SQL Editor
-- ============================================================

-- 1. 创建 page_visits 表（记录每次页面访问）
CREATE TABLE IF NOT EXISTS page_visits (
    id BIGSERIAL PRIMARY KEY,
    ip_address TEXT,
    user_agent TEXT,
    device_type TEXT,        -- Mobile / Desktop / iPad
    browser TEXT,            -- Chrome / Safari / Firefox / WeChat
    screen_size TEXT,        -- 1920x1080
    platform TEXT,           -- Win32 / MacIntel / Linux
    language TEXT,           -- zh-CN / en-US
    city TEXT,
    region TEXT,
    country TEXT,
    visited_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 允许匿名插入（前端 JS 直接 insert）
ALTER TABLE page_visits ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow anonymous inserts" ON page_visits
    FOR INSERT TO anon WITH CHECK (true);

-- 3. 允许公开读取总数（用于首页计数显示）
CREATE POLICY "Allow count select" ON page_visits
    FOR SELECT TO anon USING (true);

-- 4. 创建索引，加速按时间排序查询
CREATE INDEX IF NOT EXISTS idx_page_visits_visited_at ON page_visits (visited_at DESC);

-- 5. (可选) RPC 函数：获取访问总数
CREATE OR REPLACE FUNCTION get_visit_count()
RETURNS BIGINT
LANGUAGE SQL
SECURITY DEFINER
AS $$
    SELECT COUNT(*)::BIGINT FROM page_visits;
$$;
