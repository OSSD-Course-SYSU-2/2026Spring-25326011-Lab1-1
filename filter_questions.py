import json
import re

# 读取questions.json
with open('entry/src/main/resources/rawfile/questions.json', 'r', encoding='utf-8') as f:
    questions_data = json.load(f)

questions = questions_data.get('questions', [])
print('原始题目数:', len(questions))

# 过滤非法题目
valid_questions = []
invalid_count = 0

for q in questions:
    content = q.get('content', '')
    # 过滤所有标点和空格
    filtered = re.sub(r'[，。、；：？！\"\"\'\'《》【】（）—…·\s]', '', content)
    count = len(filtered)

    # 只保留10字或14字的题目
    if count in [10, 14]:
        valid_questions.append(q)
    else:
        invalid_count += 1

print(f'非法题目数: {invalid_count}')
print(f'合法题目数: {len(valid_questions)}')

# 保存过滤后的题库
questions_data['questions'] = valid_questions
with open('entry/src/main/resources/rawfile/questions.json', 'w', encoding='utf-8') as f:
    json.dump(questions_data, f, ensure_ascii=False, indent=2)

print('题库过滤完成！')

# 验证过滤后的结果
print('\n验证过滤后的题库:')
char_counts = {}
for q in valid_questions:
    content = q.get('content', '')
    filtered = re.sub(r'[，。、；：？！\"\"\'\'《》【】（）—…·\s]', '', content)
    count = len(filtered)
    if count not in char_counts:
        char_counts[count] = 0
    char_counts[count] += 1

print('字数分布:')
for count in sorted(char_counts.keys()):
    print(f'  {count}字: {char_counts[count]}题')
