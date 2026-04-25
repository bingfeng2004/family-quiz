import re

with open(r"c:\Users\fengxin\WorkBuddy\Claw\家庭竞答应用\generate_questions.py", encoding="utf-8") as f:
    content = f.read()

# 替换 emoji 为 ASCII 避免 GBK 编码错误
fixed = content.replace("'✅ 主题更新成功", "'[OK] 主题更新成功")
fixed = fixed.replace("'⚠️  主题更新返回", "'[WARN] 主题更新返回")
fixed = fixed.replace("'✅ 批次", "'[OK] 批次")
fixed = fixed.replace("'❌ 批次", "'[FAIL] 批次")
fixed = fixed.replace('"完成！共成功插入/更新', '"完成！共成功插入/更新')

with open(r"c:\Users\fengxin\WorkBuddy\Claw\家庭竞答应用\generate_questions.py", "w", encoding="utf-8") as f:
    f.write(fixed)

print("emoji替换完成")
