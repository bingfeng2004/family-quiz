-- 在 Supabase SQL Editor 中执行以下语句，添加新主题并开放主题表写入权限

-- 1. 添加3个新主题
INSERT INTO themes (id, name, icon, color, description) VALUES
('music',    '音乐', '🎵', '#EC4899', '乐理、乐器、音乐家知识'),
('language', '语文', '📝', '#14B8A6', '成语、诗词、古典文学'),
('mixed',    '综合', '🎯', '#EF4444', '各类知识综合考查')
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    icon = EXCLUDED.icon,
    color = EXCLUDED.color,
    description = EXCLUDED.description;

-- 2. 临时开放主题表写入（如需通过API插入）
-- CREATE POLICY "Allow insert themes" ON themes FOR INSERT WITH CHECK (true);

-- 3. 执行完成后验证
SELECT id, name FROM themes ORDER BY id;
