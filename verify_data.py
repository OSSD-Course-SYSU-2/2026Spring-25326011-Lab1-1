import json
import re

# 读取questions.json
with open('entry/src/main/resources/rawfile/questions.json', 'r', encoding='utf-8') as f:
    questions_data = json.load(f)

questions = questions_data.get('questions', [])
print('总题目数:', len(questions))

# 统计字数分布
char_counts = {}
invalid_questions = []

for i, q in enumerate(questions):
    content = q.get('content', '')
    # 过滤所有标点和空格
    filtered = re.sub(r'[，。、；：？！\"\"\'\'《》【】（）—…·\s]', '', content)
    count = len(filtered)

    if count not in char_counts:
        char_counts[count] = 0
    char_counts[count] += 1

    if count not in [10, 14]:
        invalid_questions.append({
            'index': i,
            'content': content,
            'char_count': count
        })

print('\n字数分布:')
for count in sorted(char_counts.keys()):
    print(f'  {count}字: {char_counts[count]}题')

print(f'\n非法题目数（不是10或14字）: {len(invalid_questions)}')

if invalid_questions:
    print('\n前20个非法题目:')
    for item in invalid_questions[:20]:
        print(f'  题目{item["index"]}: {item["content"]} ({item["char_count"]}字)')
