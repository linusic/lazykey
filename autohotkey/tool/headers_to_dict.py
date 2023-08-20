# pip install pyperclip

import re
from textwrap import indent
# import subprocess
import pyperclip


regex_dict = re.compile(r"(.*?):\s(.*)")

# def to_clip(feed_content:str):
    # subprocess.run('clip.exe', shell=True, close_fds=True, input=feed_content.encode('utf-8'))

headers = pyperclip.paste()

def rep(obj: re.Match):
    # raw = obj.group(0)
    k = obj.group(1)
    v = obj.group(2)
    result = f"'{k.strip()}':'{v.strip()}',"  # clear \n
    return result

result = regex_dict.sub(
    rep,
    headers
)

lines:list = result.strip().split("\n")
def map_line(line):
    if ':' not in line:
        line = f"'{line}':None,"
    return line

map_result = map(map_line, lines)
kv_pair_str = "\n".join(map_result)
dedent_dict = indent(kv_pair_str, "    ")
dict_str = f"""{{
{dedent_dict}
}}"""

# to_clip(dict_str)

headers = pyperclip.paste()

pyperclip.copy(dict_str)
