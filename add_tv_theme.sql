-- ============================================
-- 插入「猜电视」主题及题目到 Supabase
-- 请在 Supabase 控制台 SQL 编辑器中执行
-- ============================================

-- 1. 插入主题（已有则跳过）
INSERT INTO themes (id, name, icon, color, description)
VALUES ('tv', '猜电视', '📺', '#FF6B6B', '经典电视剧剧情猜剧名、台词接龙等趣味电视知识')
ON CONFLICT (id) DO NOTHING;

-- 2. 插入题目（已有则跳过）
INSERT INTO questions (id, theme_id, difficulty, type, content, options, answer, explanation) VALUES
('TV001', 'tv', 'easy', 'single',
 '小燕子阴差阳错进了皇宫，与紫薇、金锁在皇宫中发生的啼笑皆非的故事，是哪部电视剧？',
 '[{"key":"A","value":"还珠格格"},{"key":"B","value":"甄嬛传"},{"key":"C","value":"宫锁心玉"},{"key":"D","value":"步步惊心"}]',
 'A', '《还珠格格》是琼瑶的经典作品，小燕子、紫薇的角色家喻户晓。'),

('TV002', 'tv', 'easy', 'single',
 '同福客栈里，佟湘玉、白展堂、郭芙蓉、吕秀才等人每天发生的爆笑故事，是哪部电视剧？',
 '[{"key":"A","value":"家有儿女"},{"key":"B","value":"武林外传"},{"key":"C","value":"爱情公寓"},{"key":"D","value":"乡村爱情"}]',
 'B', '《武林外传》是宁财神编剧的古装情景喜剧，堪称一代人的回忆。'),

('TV003', 'tv', 'easy', 'single',
 '孙悟空大闹天宫后被压五指山下五百年，后随唐僧西天取经，是哪部电视剧？',
 '[{"key":"A","value":"封神榜"},{"key":"B","value":"新白娘子传奇"},{"key":"C","value":"西游记"},{"key":"D","value":"宝莲灯"}]',
 'C', '86版《西游记》是六小龄童主演的经典之作，重播次数创下吉尼斯世界纪录。'),

('TV004', 'tv', 'medium', 'single',
 '李云龙带领独立团在抗日战场上屡建奇功，"二营长，你他娘的意大利炮呢"出自哪部电视剧？',
 '[{"key":"A","value":"我的团长我的团"},{"key":"B","value":"亮剑"},{"key":"C","value":"雪豹"},{"key":"D","value":"潜伏"}]',
 'B', '《亮剑》由李幼斌主演，李云龙这个角色性格鲜明，台词广为流传。'),

('TV005', 'tv', 'medium', 'single',
 '甄嬛从天真少女成长为善于权谋的太后，勾心斗角的后宫故事是哪部电视剧？',
 '[{"key":"A","value":"金枝欲孽"},{"key":"B","value":"延禧攻略"},{"key":"C","value":"如懿传"},{"key":"D","value":"甄嬛传"}]',
 'D', '《甄嬛传》是孙俪主演的宫斗剧经典，"贱人就是矫情"成为流行语。'),

('TV006', 'tv', 'medium', 'single',
 '许仙在西湖断桥边遇见白娘子，展开了一段人妖相恋的凄美故事，是哪部电视剧？',
 '[{"key":"A","value":"天仙配"},{"key":"B","value":"牛郎织女"},{"key":"C","value":"新白娘子传奇"},{"key":"D","value":"梁山伯与祝英台"}]',
 'C', '《新白娘子传奇》由赵雅芝、叶童主演，主题曲《千年等一回》广为传唱。'),

('TV007', 'tv', 'hard', 'single',
 '"你已经成功引起我的注意了"这句最常见的偶像剧台词，常用于调侃哪类电视剧的套路？',
 '[{"key":"A","value":"武侠剧"},{"key":"B","value":"偶像剧"},{"key":"C","value":"宫斗剧"},{"key":"D","value":"历史剧"}]',
 'B', '霸道总裁爱上我的套路是偶像剧的标志性桥段，"邪魅一笑"也是标配。'),

('TV008', 'tv', 'easy', 'single',
 '"皇上，你还记得大明湖畔的夏雨荷吗？" 这句话出自谁之口？',
 '[{"key":"A","value":"小燕子"},{"key":"B","value":"紫薇"},{"key":"C","value":"金锁"},{"key":"D","value":"晴儿"}]',
 'B', '紫薇对皇上说的这句台词出自《还珠格格》，是剧中最经典的场景之一。'),

('TV009', 'tv', 'medium', 'single',
 '下一句接龙："葫芦娃，葫芦娃，一根藤上七朵花。" 下一句是什么？',
 '[{"key":"A","value":"风吹雨打都不怕"},{"key":"B","value":"七个葫芦本领大"},{"key":"C","value":"啦啦啦啦啦啦"},{"key":"D","value":"妖精快还我爷爷"}]',
 'A', '《葫芦娃》主题曲歌词："葫芦娃，葫芦娃，一根藤上七朵花，风吹雨打都不怕，啦啦啦啦。"'),

('TV010', 'tv', 'medium', 'single',
 '"妖精，还我爷爷！" 这句话出自哪部动画片？',
 '[{"key":"A","value":"大闹天宫"},{"key":"B","value":"葫芦兄弟"},{"key":"C","value":"黑猫警长"},{"key":"D","value":"哪吒闹海"}]',
 'B', '《葫芦兄弟》（葫芦娃）中，葫芦娃们为了救爷爷与蛇精蝎子精斗智斗勇。'),

('TV011', 'tv', 'hard', 'single',
 '《西游记》中孙悟空最常说的一句话是？',
 '[{"key":"A","value":"俺老孙来也"},{"key":"B","value":"妖怪哪里跑"},{"key":"C","value":"呆子，别跑"},{"key":"D","value":"师父小心"}]',
 'A', '"俺老孙来也" 是孙悟空最标志性的口头禅，每次出场都伴随这句台词。'),

('TV012', 'tv', 'hard', 'single',
 '"我还会回来的！" 这句经典台词出自哪部动画片中的角色？',
 '[{"key":"A","value":"汤姆猫"},{"key":"B","value":"灰太狼"},{"key":"C","value":"光头强"},{"key":"D","value":"格格巫"}]',
 'B', '《喜羊羊与灰太狼》中灰太狼每次被小羊打败后都会喊出这句经典台词。')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- 如需同时开放 API 写入权限，执行下面语句
-- ============================================
-- CREATE POLICY "Allow all themes insert" ON themes FOR INSERT WITH CHECK (true);
-- CREATE POLICY "Allow all questions insert" ON questions FOR INSERT WITH CHECK (true);
-- CREATE POLICY "Allow all themes update" ON themes FOR UPDATE USING (true) WITH CHECK (true);
-- CREATE POLICY "Allow all questions update" ON questions FOR UPDATE USING (true) WITH CHECK (true);
