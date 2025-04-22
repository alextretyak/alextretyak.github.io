import os, re

for root, dirs, files in os.walk('.'):
    for name in files:
        if name.endswith('.pq'):
            file_contents = open(os.path.join(root, name), encoding = 'utf-8').read()
            if re.search(r'[ \t]$', file_contents, re.MULTILINE):
                print(os.path.join(root, name))
