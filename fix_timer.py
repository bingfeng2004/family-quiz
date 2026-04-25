path = r"c:\Users\fengxin\WorkBuddy\Claw\家庭竞答应用\index-cloud.html"
with open(path, encoding="utf-8") as f:
    content = f.read()
count = content.count("clearInterval(state.timerInterval)")
fixed = content.replace("clearInterval(state.timerInterval)", "stopTimer()")
with open(path, "w", encoding="utf-8") as f:
    f.write(fixed)
print(f"Replaced {count} occurrences")
