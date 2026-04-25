# Supabase 数据库设计

## 数据库连接

```javascript
const SUPABASE_URL = 'YOUR_PROJECT_URL';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY';
const supabase = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
```

## 数据表设计

### 1. users（用户表）
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nickname VARCHAR(20) NOT NULL,
  avatar VARCHAR(10) DEFAULT '👤',
  total_score INTEGER DEFAULT 0,
  games_played INTEGER DEFAULT 0,
  games_won INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 2. themes（主题表）
```sql
CREATE TABLE themes (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  icon VARCHAR(10) NOT NULL,
  description TEXT,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 初始数据
INSERT INTO themes (id, name, icon, description, sort_order) VALUES
('science', '科学', '🔬', '物理、化学、生物等科学知识', 1),
('history', '历史', '📜', '中外历史人物和事件', 2),
('geo', '地理', '🌍', '地理知识和世界风貌', 3),
('animal', '动物', '🐾', '动物世界的有趣知识', 4),
('plant', '植物', '🌳', '植物王国的奥秘', 5),
('space', '天文', '🚀', '宇宙星空的探索', 6);
```

### 3. questions（题目表）
```sql
CREATE TABLE questions (
  id VARCHAR(20) PRIMARY KEY,
  theme_id VARCHAR(50) REFERENCES themes(id),
  difficulty VARCHAR(10) CHECK (difficulty IN ('easy', 'medium', 'hard')),
  type VARCHAR(10) DEFAULT 'single',
  content TEXT NOT NULL,
  options JSONB NOT NULL,
  answer VARCHAR(5) NOT NULL,
  explanation TEXT,
  video_url VARCHAR(500),
  usage_count INTEGER DEFAULT 0,
  correct_rate DECIMAL(5,2) DEFAULT 0,
  status VARCHAR(10) DEFAULT 'enabled',
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 4. rooms（房间表）
```sql
CREATE TABLE rooms (
  id VARCHAR(10) PRIMARY KEY,
  host_id UUID REFERENCES users(id),
  theme_id VARCHAR(50) REFERENCES themes(id),
  settings JSONB DEFAULT '{}',
  status VARCHAR(20) DEFAULT 'waiting',
  current_question INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
-- RLS: 房间成员可读，更新需通过函数
```

### 5. room_players（房间玩家表）
```sql
CREATE TABLE room_players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id VARCHAR(10) REFERENCES rooms(id),
  user_id UUID REFERENCES users(id),
  nickname VARCHAR(20) NOT NULL,
  score INTEGER DEFAULT 0,
  is_ready BOOLEAN DEFAULT false,
  joined_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(room_id, user_id)
);
```

### 6. game_records（游戏记录表）
```sql
CREATE TABLE game_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id VARCHAR(10) NOT NULL,
  theme_id VARCHAR(50) REFERENCES themes(id),
  players JSONB NOT NULL,
  ranking JSONB NOT NULL,
  duration INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 7. player_stats（玩家统计表）
```sql
CREATE TABLE player_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  theme_id VARCHAR(50) REFERENCES themes(id),
  total_games INTEGER DEFAULT 0,
  correct_answers INTEGER DEFAULT 0,
  total_answers INTEGER DEFAULT 0,
  best_score INTEGER DEFAULT 0,
  UNIQUE(user_id, theme_id)
);
```

## 实时订阅

```javascript
// 订阅房间更新
supabase
  .channel('room_' + roomId)
  .on('postgres_changes', { 
    event: '*', 
    schema: 'public', 
    table: 'room_players',
    filter: `room_id=eq.${roomId}`
  }, handlePlayerUpdate)
  .on('postgres_changes', { 
    event: 'UPDATE', 
    schema: 'public', 
    table: 'rooms',
    filter: `id=eq.${roomId}`
  }, handleRoomUpdate)
  .subscribe();
```

## 安全规则 (RLS)

```sql
-- 允许用户读取自己的数据
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);
```

## 快速开始步骤

1. 注册 Supabase: https://supabase.com
2. 创建新项目
3. 在 SQL Editor 执行上述建表语句
4. 获取 Project URL 和 anon public key
5. 替换代码中的配置
