import collections

parens_users = collections.defaultdict(int)
square_users = collections.defaultdict(int)

om = open('original_messages.txt').read()

for msg in om[65:].split("\n" + '-'*64 + "\n"):
    user = msg.split("\n")[0].split(' | ')[2]

    for c in ('**', '//', '__', '--', '/\\', '\\/', '++', '==', '""', '..'):
        if '(' + c in msg and c + ')' in msg:
            parens_users[user] += 1
            break

    for b in ('b', 'i', 'u', 's', '^', 'v', 'code', 'pre', 'q', '.'):
        if '[' + b in msg and b + ']' in msg:
            square_users[user] += 1
            break

print('()')
print("\n".join(f'{u}: {c}' for u, c in parens_users.items() if u not in square_users))
print()
print('[]')
print("\n".join(f'{u}: {c}' for u, c in square_users.items() if u not in parens_users))
print()
print('() + []')
print("\n".join(f'{u}: {c}/{square_users[u]}' for u, c in parens_users.items() if u in square_users))

r'''
(**жирный**) или [b]жирный[/b]
(//курсив//) или [i]курсив[/i]
(__подчёркнутый__) или [u]подчёркнутый[/u]
(--зачёркнутый--) или [s]зачёркнутый[/s]
(/\приподнятый/\) или [^]приподнятый[/^]
(\/пониженный\/) или [v]пониженный[/v]

(++код++) или [code]код[/code]
(==текст программы==) или [pre]текст программы[/pre]
(""цитата"") или [q]цитата[/q]
(..отступ с маркером..) или [.]отступ с маркером[/.]
'''
