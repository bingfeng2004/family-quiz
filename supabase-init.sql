-- =====================================================
-- 家庭知识竞答应用 - 数据库初始化脚本
-- 在 Supabase SQL Editor 中执行此脚本
-- =====================================================

-- 1. 创建主题表
CREATE TABLE IF NOT EXISTS themes (
  id VARCHAR(20) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  icon VARCHAR(20) DEFAULT '📚',
  color VARCHAR(20) DEFAULT '#4F46E5',
  description TEXT,
  question_count INTEGER DEFAULT 0
);

-- 2. 创建题目表
CREATE TABLE IF NOT EXISTS questions (
  id VARCHAR(20) PRIMARY KEY,
  theme_id VARCHAR(20) REFERENCES themes(id),
  difficulty VARCHAR(10) CHECK (difficulty IN ('easy', 'medium', 'hard')),
  type VARCHAR(10) DEFAULT 'single',
  content TEXT NOT NULL,
  options JSONB NOT NULL,
  answer VARCHAR(5) NOT NULL,
  explanation TEXT,
  video_url VARCHAR(500)
);

-- 3. 创建用户表
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nickname VARCHAR(20) NOT NULL UNIQUE,
  total_score INTEGER DEFAULT 0,
  games_played INTEGER DEFAULT 0,
  games_won INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4. 创建房间表
CREATE TABLE IF NOT EXISTS rooms (
  id VARCHAR(10) PRIMARY KEY,
  host_id VARCHAR(50) NOT NULL,
  theme_id VARCHAR(20),
  settings JSONB DEFAULT '{"questionCount": 10, "answerTime": 15}',
  status VARCHAR(20) DEFAULT 'waiting' CHECK (status IN ('waiting', 'playing', 'finished')),
  current_question INTEGER DEFAULT 0,
  snatched_player_id VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 5. 创建房间玩家表
CREATE TABLE IF NOT EXISTS room_players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id VARCHAR(10) REFERENCES rooms(id) ON DELETE CASCADE,
  odin VARCHAR(50) NOT NULL,
  nickname VARCHAR(20) NOT NULL,
  score INTEGER DEFAULT 0,
  UNIQUE(room_id, odin)
);

-- 6. 创建游戏记录表
CREATE TABLE IF NOT EXISTS game_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id VARCHAR(10),
  theme_id VARCHAR(20),
  players JSONB,
  ranking JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- 插入初始数据
-- =====================================================

-- 插入主题
INSERT INTO themes (id, name, icon, color, description) VALUES
('science', '科学探索', '🔬', '#3B82F6', '物理、化学、生物等科学知识'),
('history', '历史长河', '📜', '#8B5CF6', '中外历史典故与人物'),
('geography', '地理百科', '🌍', '#10B981', '山川河流、国家城市'),
('animal', '动物世界', '🦁', '#F59E0B', '野生动物与昆虫知识'),
('plant', '植物奥秘', '🌲', '#22C55E', '花草树木的奇妙世界'),
('space', '宇宙星空', '🚀', '#6366F1', '太空探索与天文知识')
ON CONFLICT (id) DO NOTHING;

-- 插入题目
INSERT INTO questions (id, theme_id, difficulty, content, options, answer, explanation) VALUES
-- 科学类
('S001', 'science', 'easy', '水的化学式是什么？', '{"A": "H2O", "B": "CO2", "C": "O2", "D": "NaCl"}', 'A', '水由两个氢原子和一个氧原子组成，化学式为H2O。', ''),
('S002', 'science', 'easy', '地球的自转周期大约是多少小时？', '{"A": "12小时", "B": "24小时", "C": "36小时", "D": "48小时"}', 'B', '地球自转一周大约需要24小时，这就是一天的长度。', ''),
('S003', 'science', 'medium', '光在真空中的传播速度是多少？', '{"A": "30万公里/秒", "B": "30亿公里/秒", "C": "3万公里/秒", "D": "300万公里/秒"}', 'A', '光速是宇宙中最快的速度，约为30万公里/秒。', ''),
('S004', 'science', 'medium', '人体最大的器官是什么？', '{"A": "心脏", "B": "肝脏", "C": "皮肤", "D": "大脑"}', 'C', '皮肤是人体最大的器官，成年人皮肤总面积约为1.5-2平方米。', ''),
('S005', 'science', 'hard', '元素周期表中原子序数为79的元素是？', '{"A": "银", "B": "铂", "C": "金", "D": "铜"}', 'C', '金元素的原子序数是79，化学符号是Au。', ''),
-- 历史类
('H001', 'history', 'easy', '中国的第一个皇帝是谁？', '{"A": "刘邦", "B": "项羽", "C": "秦始皇", "D": "汉武帝"}', 'C', '秦始皇是中国历史上第一个皇帝。', ''),
('H002', 'history', 'easy', '明朝的开国皇帝是谁？', '{"A": "朱棣", "B": "朱元璋", "C": "朱允炆", "D": "崇祯"}', 'B', '朱元璋是明朝的开国皇帝，年号洪武。', ''),
('H003', 'history', 'medium', '第一次鸦片战争爆发于哪一年？', '{"A": "1839年", "B": "1840年", "C": "1842年", "D": "1850年"}', 'B', '第一次鸦片战争于1840年爆发。', ''),
('H004', 'history', 'medium', '丝绸之路的主要开拓者是谁？', '{"A": "张骞", "B": "班超", "C": "郑和", "D": "玄奘"}', 'A', '张骞被誉为"丝绸之路之父"。', ''),
-- 地理类
('G001', 'geography', 'easy', '世界上面积最大的国家是哪个？', '{"A": "中国", "B": "加拿大", "C": "俄罗斯", "D": "美国"}', 'C', '俄罗斯是世界上面积最大的国家。', ''),
('G002', 'geography', 'easy', '世界上最高的山峰是什么？', '{"A": "乔戈里峰", "B": "干城章嘉峰", "C": "珠穆朗玛峰", "D": "马卡鲁峰"}', 'C', '珠穆朗玛峰是世界最高峰。', ''),
('G003', 'geography', 'medium', '世界上最长的河流是？', '{"A": "亚马逊河", "B": "尼罗河", "C": "长江", "D": "密西西比河"}', 'B', '尼罗河全长约6650公里，是世界上最长的河流。', ''),
('G004', 'geography', 'medium', '中国陆地面积最大的省份是？', '{"A": "新疆", "B": "西藏", "C": "内蒙古", "D": "青海"}', 'A', '新疆维吾尔自治区是中国陆地面积最大的省级行政区。', ''),
-- 动物类
('A001', 'animal', 'easy', '以下哪个是哺乳动物？', '{"A": "鲨鱼", "B": "鲸鱼", "C": "鳄鱼", "D": "企鹅"}', 'B', '鲸鱼是哺乳动物，它们用肺呼吸。', ''),
('A002', 'animal', 'easy', '猎豹的最高速度可达多少公里/小时？', '{"A": "80公里/小时", "B": "100公里/小时", "C": "120公里/小时", "D": "150公里/小时"}', 'C', '猎豹的最高速度可达120公里/小时。', ''),
('A003', 'animal', 'medium', '企鹅属于鸟类吗？', '{"A": "不属于", "B": "属于", "C": "属于哺乳动物", "D": "是两栖动物"}', 'B', '企鹅属于鸟类，它们是恒温动物，有羽毛。', ''),
('A004', 'animal', 'medium', '变色龙改变体色主要是为了？', '{"A": "美观", "B": "调节体温和伪装", "C": "吸引配偶", "D": "恐吓敌人"}', 'B', '变色龙变色主要用于调节体温和伪装。', ''),
-- 植物类
('P001', 'plant', 'easy', '以下哪种植物不需要土壤就能生长？', '{"A": "苹果树", "B": "小麦", "C": "空气凤梨", "D": "水稻"}', 'C', '空气凤梨是少数不需要土壤就能生长的植物。', ''),
('P002', 'plant', 'medium', '光合作用主要发生在植物的哪个部位？', '{"A": "根部", "B": "茎部", "C": "叶片", "D": "花朵"}', 'C', '光合作用主要发生在叶片的叶绿体中。', ''),
('P003', 'plant', 'medium', '以下哪种植物的种子最大？', '{"A": "西瓜", "B": "椰子", "C": "海椰子", "D": "榴莲"}', 'C', '海椰子的种子是世界上最大的种子。', ''),
-- 天文类
('SP001', 'space', 'easy', '太阳系中有多少颗行星？', '{"A": "7颗", "B": "8颗", "C": "9颗", "D": "10颗"}', 'B', '太阳系有8颗行星。', ''),
('SP002', 'space', 'easy', '地球距离月球大约有多远？', '{"A": "38万公里", "B": "380万公里", "C": "3800万公里", "D": "38000公里"}', 'A', '地球与月球的平均距离约为38.4万公里。', ''),
('SP003', 'space', 'medium', '银河系的形状是什么样的？', '{"A": "圆形", "B": "方形", "C": "螺旋形", "D": "不规则形"}', 'C', '银河系是一个螺旋星系。', ''),
('SP004', 'space', 'hard', '太阳的寿命大约还有多久？', '{"A": "10亿年", "B": "50亿年", "C": "100亿年", "D": "500亿年"}', 'B', '太阳预计还能燃烧约50亿年。', '')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 启用实时订阅（重要！）
-- =====================================================

-- 启用 rooms 表的实时订阅
ALTER PUBLICATION supabase_realtime ADD TABLE rooms;

-- 启用 room_players 表的实时订阅
ALTER PUBLICATION supabase_realtime ADD TABLE room_players;

-- =====================================================
-- 开启行级安全策略（RLS）
-- =====================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE themes ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_records ENABLE ROW LEVEL SECURITY;

-- 创建允许所有操作的策略（开发环境）
CREATE POLICY "Allow all users operations" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all rooms operations" ON rooms FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all room_players operations" ON room_players FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all themes read" ON themes FOR SELECT USING (true);
CREATE POLICY "Allow all questions read" ON questions FOR SELECT USING (true);
CREATE POLICY "Allow all game_records operations" ON game_records FOR ALL USING (true) WITH CHECK (true);

-- =====================================================
-- 完成！
-- =====================================================
SELECT '✅ 数据库初始化完成！' AS status;
SELECT '📚 主题数量: ' || COUNT(*) FROM themes;
SELECT '❓ 题目数量: ' || COUNT(*) FROM questions;
