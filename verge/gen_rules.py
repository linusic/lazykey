### Gen Rules (for "prepend-rules:" in Merge File)
import re
from pathlib import Path
from typing import Literal

from httpx import Client

domain_regex = re.compile(r"  - '(.+?)'")

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 Edg/112.0.1722.48"
}

IP = "127.0.0.1"
PORT = 7890

SIMPLE_PROXIES = {
    'http://': f'http://{IP}:{PORT}',
    'https://': f'http://{IP}:{PORT}'  # convert https to http
}

def gen_direct(domain_name: str, yaml_indent: int = 4):
    # TODO: more
    return f"{' ' * yaml_indent}- 'DOMAIN-SUFFIX,{domain_name},DIRECT'"


def parse_file(file_name_prefix: str, file_text: str, yaml_indent: int = 4) -> list:
    indent = yaml_indent * ' '

    for line in file_text.split("\n")[1:]:
        if line.startswith("  - '"):
            domain_rule = domain_regex.search(line).group(1)
            # sub domain - by filename [DIRECT/REJECT]
            if domain_rule.startswith("+."):
                rule = f"{indent}- 'DOMAIN-SUFFIX,{domain_rule.lstrip('+.')},{file_name_prefix.upper()}'"
            # full domain
            else:
                rule = f"{indent}- 'DOMAIN,{domain_rule},{file_name_prefix.upper()}'"
            yield rule
        else:
            # application => eg:            #   - PROCESS-NAME,app_name
            if line.startswith("  - PROCESS-NAME"):
                _name = line.lstrip("  - ")  # PROCESS-NAME,app_name
                rule = f"{indent}- '{_name},DIRECT'"
            # in the future ...
            else:
                continue
        yield rule


def gen_verge_rule(config_dir, file_name, proxy=False, yaml_indent: int = 4,
                   download_choices: list[
                       Literal["apple", "applications", "cncidr", "direct", "gfw", "google", "greatfire", "icloud",
                       "lancidr", "private", "proxy", "reject", "telegramcidr", "tld-not-cn"
                       ]] = ["direct", "reject", "applications"],
                   direct_list: list | None = None 
                   ):
    proxies = None if not proxy else SIMPLE_PROXIES

    if not Path(config_dir).exists():
        print(f"Verge config home not exist: {config_dir}")
        return
    store_file = Path(config_dir) / file_name

    with Client(headers=HEADERS, proxies=proxies) as client:
        result = client.get("https://api.github.com/repos/Loyalsoldier/clash-rules/releases/latest").json()
        if not (result and result.get("assets")):
            print(result)
            print("FAILED: Limit Rate!")
            return
        filename_2_url: dict = {assets_obj["name"]: assets_obj["browser_download_url"] for assets_obj in
                                result["assets"]}

        if not filename_2_url:
            print("FAILED: Parse Download URL ERROR!")
            return

        all_rule_list = []

        for file_name_prefix in download_choices:
            _file = f"{file_name_prefix}.txt"
            all_rule_list.extend(
                [*parse_file(file_name_prefix, client.get(filename_2_url[_file], follow_redirects=True).text,
                             yaml_indent)]
            )
    if direct_list:
        all_rule_list.extend([gen_direct(_direct) for _direct in direct_list])

    Path(store_file).write_text("\n".join(all_rule_list), encoding="utf-8")
    print(f"Completed => {Path(store_file)}")


if __name__ == '__main__':
    file_name = "union_rules.txt"
    config_dir = Path.home() / ".config/clash-verge"

    direct_list = [
        "vultr.com"
    ]

    gen_verge_rule(
        config_dir=config_dir, file_name=file_name, yaml_indent=4,
        download_choices=["direct", "reject", "applications"],
        proxy=True,
        direct_list = direct_list
    )

### ADD to Script File
"""
function main(config) {
  // DNS
  config.dns["default-nameserver"] = ["8.8.8.8", "4.2.2.1"]; 
  
  // Rules  (vultr: "____" => Direct)
  const foundIndex = config.rules.findIndex(item => item.includes("vultr.com"));
  if (foundIndex !== -1) { config.rules[foundIndex] = "DOMAIN-SUFFIX,vultr.com,DIRECT" }; 

  // Proxy-Groups
  if (!config["proxy-groups"]) return config;
  config["proxy-groups"].forEach((group) => {
    if (group.name === "____" ){
      group.proxies.unshift("DIRECT");  // insert
    }
  });
  return config;
}
"""
