import re

path = r"c:\Users\fengxin\WorkBuddy\Claw\家庭竞答应用\index-cloud.html"
with open(path, encoding="utf-8") as f:
    content = f.read()

# 给所有 <button ... onclick=...> 加上 type="button"（如果还没有的话）
def fix_button_tag(m):
    tag = m.group(0)
    if 'type="button"' in tag:
        return tag
    return tag.replace('<button ', '<button type="button" ', 1)

fixed = re.sub(r'<button [^>]+onclick[^>]*?>', fix_button_tag, content)
# 也处理 <button class=...> (自闭合或带子元素的) - 只要没有type
fixed2 = re.sub(r'<button (class="[^"]*")([^>]*?)>', 
                lambda m: '<button type="button" ' + m.group(1) + m.group(2) + '>' 
                if 'type=' not in m.group(0) else m.group(0),
                fixed)

with open(path, "w", encoding="utf-8") as f:
    f.write(fixed2)

count = fixed2.count('type="button"')
print(f"Done. type=button count: {count}")
