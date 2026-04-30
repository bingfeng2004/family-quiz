"""插入「猜电视」主题及12道题目到 Supabase"""

import urllib.request, json

SUPABASE_URL = 'https://mnptrblqvocfkwntfmof.supabase.co'
SUPABASE_KEY = 'sb_publishable_zFcq1rfWxViECIE8sPyylw_xlWp-TfQ'
HEADERS = {
    'apikey': SUPABASE_KEY,
    'Authorization': f'Bearer {SUPABASE_KEY}',
    'Content-Type': 'application/json',
    'Prefer': 'resolution=merge-duplicates'
}

def upsert(table, rows):
    url = f'{SUPABASE_URL}/rest/v1/{table}'
    data = json.dumps(rows).encode()
    req = urllib.request.Request(url, data=data, headers=HEADERS)
    req.get_method = lambda: 'POST'
    with urllib.request.urlopen(req) as r:
        return r.status, r.read().decode()

# ===== 1. 插入主题 =====
print('=== 插入主题 ===')
theme = [{
    'id': 'tv',
    'name': '猜电视',
    'icon': '📺',
    'color': '#FF6B6B',
    'description': '经典电视剧剧情猜剧名、台词接龙等趣味电视知识'
}]
status, resp = upsert('themes', theme)
print(f'  themes upsert: {status} {resp[:80]}')

# ===== 2. 插入题目 =====
print('=== 插入题目 ===')
questions = [
    # 剧情猜剧名 - easy
    {'id': 'TV001', 'theme_id': 'tv', 'difficulty': 'easy', 'type': 'single',
     'content': '小燕子阴差阳错进了皇宫，与紫薇、金锁在皇宫中发生的啼笑皆非的故事，是哪部电视剧？',
     'options': [{'key':'A','value':'还珠格格'},{'key':'B','value':'甄嬛传'},{'key':'C','value':'宫锁心玉'},{'key':'D','value':'步步惊心'}],
     'answer': 'A', 'explanation': '《还珠格格》是琼瑶的经典作品，小燕子、紫薇的角色家喻户晓。'},
    {'id': 'TV002', 'theme_id': 'tv', 'difficulty': 'easy', 'type': 'single',
     'content': '同福客栈里，佟湘玉、白展堂、郭芙蓉、吕秀才等人每天发生的爆笑故事，是哪部电视剧？',
     'options': [{'key':'A','value':'家有儿女'},{'key':'B','value':'武林外传'},{'key':'C','value':'爱情公寓'},{'key':'D','value':'乡村爱情'}],
     'answer': 'B', 'explanation': '《武林外传》是宁财神编剧的古装情景喜剧，堪称一代人的回忆。'},
    {'id': 'TV003', 'theme_id': 'tv', 'difficulty': 'easy', 'type': 'single',
     'content': '孙悟空大闹天宫后被压五指山下五百年，后随唐僧西天取经，是哪部电视剧？',
     'options': [{'key':'A','value':'封神榜'},{'key':'B','value':'新白娘子传奇'},{'key':'C','value':'西游记'},{'key':'D','value':'宝莲灯'}],
     'answer': 'C', 'explanation': '86版《西游记》是六小龄童主演的经典之作，重播次数创下吉尼斯世界纪录。'},
    # 剧情猜剧名 - medium
    {'id': 'TV004', 'theme_id': 'tv', 'difficulty': 'medium', 'type': 'single',
     'content': '李云龙带领独立团在抗日战场上屡建奇功，"二营长，你他娘的意大利炮呢"出自哪部电视剧？',
     'options': [{'key':'A','value':'我的团长我的团'},{'key':'B','value':'亮剑'},{'key':'C','value':'雪豹'},{'key':'D','value':'潜伏'}],
     'answer': 'B', 'explanation': '《亮剑》由李幼斌主演，李云龙这个角色性格鲜明，台词广为流传。'},
    {'id': 'TV005', 'theme_id': 'tv', 'difficulty': 'medium', 'type': 'single',
     'content': '甄嬛从天真少女成长为善于权谋的太后，勾心斗角的后宫故事是哪部电视剧？',
     'options': [{'key':'A','value':'金枝欲孽'},{'key':'B','value':'延禧攻略'},{'key':'C','value':'如懿传'},{'key':'D','value':'甄嬛传'}],
     'answer': 'D', 'explanation': '《甄嬛传》是孙俪主演的宫斗剧经典，"贱人就是矫情"成为流行语。'},
    {'id': 'TV006', 'theme_id': 'tv', 'difficulty': 'medium', 'type': 'single',
     'content': '许仙在西湖断桥边遇见白娘子，展开了一段人妖相恋的凄美故事，是哪部电视剧？',
     'options': [{'key':'A','value':'天仙配'},{'key':'B','value':'牛郎织女'},{'key':'C','value':'新白娘子传奇'},{'key':'D','value':'梁山伯与祝英台'}],
     'answer': 'C', 'explanation': '《新白娘子传奇》由赵雅芝、叶童主演，主题曲《千年等一回》广为传唱。'},
    # 剧情猜剧名 - hard
    {'id': 'TV007', 'theme_id': 'tv', 'difficulty': 'hard', 'type': 'single',
     'content': '"你已经成功引起我的注意了"这句霸道总裁经典台词，常用来调侃哪类电视剧的套路？',
     'options': [{'key':'A','value':'武侠剧'},{'key':'B','value':'偶像剧'},{'key':'C','value':'宫斗剧'},{'key':'D','value':'历史剧'}],
     'answer': 'B', 'explanation': '霸道总裁爱上我的套路是偶像剧的标志性桥段，"邪魅一笑"也是标配。'},
    # 上句猜下句/经典台词 - easy
    {'id': 'TV008', 'theme_id': 'tv', 'difficulty': 'easy', 'type': 'single',
     'content': '"皇上，你还记得大明湖畔的夏雨荷吗？" 这句话出自谁之口？',
     'options': [{'key':'A','value':'小燕子'},{'key':'B','value':'紫薇'},{'key':'C','value':'金锁'},{'key':'D','value':'晴儿'}],
     'answer': 'B', 'explanation': '紫薇对皇上说的这句台词出自《还珠格格》，是剧中最经典的场景之一。'},
    # 上句猜下句/经典台词 - medium
    {'id': 'TV009', 'theme_id': 'tv', 'difficulty': 'medium', 'type': 'single',
     'content': '下一句接龙："葫芦娃，葫芦娃，一根藤上七朵花。" 下一句是什么？',
     'options': [{'key':'A','value':'风吹雨打都不怕'},{'key':'B','value':'七个葫芦本领大'},{'key':'C','value':'啦啦啦啦啦啦'},{'key':'D','value':'妖精快还我爷爷'}],
     'answer': 'A', 'explanation': '《葫芦娃》主题曲歌词："葫芦娃，葫芦娃，一根藤上七朵花，风吹雨打都不怕，啦啦啦啦。"'},
    {'id': 'TV010', 'theme_id': 'tv', 'difficulty': 'medium', 'type': 'single',
     'content': '"妖精，还我爷爷！" 这句话出自哪部动画片？',
     'options': [{'key':'A','value':'大闹天宫'},{'key':'B','value':'葫芦兄弟'},{'key':'C','value':'黑猫警长'},{'key':'D','value':'哪吒闹海'}],
     'answer': 'B', 'explanation': '《葫芦兄弟》（葫芦娃）中，葫芦娃们为了救爷爷与蛇精蝎子精斗智斗勇。'},
    # 上句猜下句/经典台词 - hard
    {'id': 'TV011', 'theme_id': 'tv', 'difficulty': 'hard', 'type': 'single',
     'content': '《西游记》中孙悟空最常说的一句话是？',
     'options': [{'key':'A','value':'俺老孙来也'},{'key':'B','value':'妖怪哪里跑'},{'key':'C','value':'呆子，别跑'},{'key':'D','value':'师父小心'}],
     'answer': 'A', 'explanation': '"俺老孙来也" 是孙悟空最标志性的口头禅，每次出场都伴随这句台词。'},
    {'id': 'TV012', 'theme_id': 'tv', 'difficulty': 'hard', 'type': 'single',
     'content': '"我还会回来的！" 这句经典台词出自哪部动画片中的角色？',
     'options': [{'key':'A','value':'汤姆猫'},{'key':'B','value':'灰太狼'},{'key':'C','value':'光头强'},{'key':'D','value':'格格巫'}],
     'answer': 'B', 'explanation': '《喜羊羊与灰太狼》中灰太狼每次被小羊打败后都会喊出这句经典台词。'},
]

status, resp = upsert('questions', questions)
print(f'  questions upsert: {status} {resp[:200]}')

print('=== 完成 ===')
if status // 100 in (2, 3):
    print('✅ TV 主题和题目已成功插入 Supabase！')
else:
    print(f'❌ 插入失败，HTTP {status}')
