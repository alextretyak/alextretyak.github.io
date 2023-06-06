import re

outf = open('sm-typos.pq', 'w', encoding = 'utf-8', newline = "\n")
outf.write("T‘\n")

for line in open('sm-typos.txt', encoding = 'utf-8').read().split("\n"):
    if line.startswith('> ') and ("-'‘" in line or "+'‘" in line): # ’’
        outf.write('‘‘' + re.sub(r"\+'‘(.+?)’'", '', re.sub(  "-'‘(.+?)’'", r'С(-866)‘\1’', line[2:])) + '’ ‘'
                        + re.sub(  "-'‘(.+?)’'", '', re.sub(r"\+'‘(.+?)’'", r'С(-686)‘\1’', line[2:])) + "’’\n")

outf.write("’\n")
