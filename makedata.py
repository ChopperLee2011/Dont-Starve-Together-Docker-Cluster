#!/usr/bin/python3.6

import os
import sys
import re

service_format = '''
 {name}:
    image: makarawang/dont-starve-together-docker-cluster
    ports:
      - "10999:10999/udp"
      - "10998:10998/udp"
    volumes:
      - "{ini_path}:/root/.klei/DoNotStarveTogether/Cluster_1"
      - "{mods_path}:/root/DST/mods"
      - "{mods_setup_path}:/root/DST/mods/dedicated_server_mods_setup.lua"
    container_name: {name}
'''

version_format = '''version : "2"
services:'''

cluster_ini = '''[GAMEPLAY]
game_mode = endless
max_players = 32
pvp = false
pause_when_empty = true

[NETWORK]
lan_only_cluster = false
cluster_intention = cooperative
cluster_description = {intro}
cluster_name = {name}
offline_cluster = false
cluster_password = {passwd}

[MISC]
console_enabled = true

[SHARD]
shard_enabled = false
bind_ip = 127.0.0.1
master_ip = 127.0.0.1
master_port = 10888
cluster_key = defaultPass
'''

path = "/".join(os.path.abspath(sys.argv[0]).split("/")[:-1])
path_data = path + "/data"

os.system('mkdir ' + path + "/data 2>/dev/null")

with open(path + "/infos", 'r') as f:
    text = f.read()

text = re.sub("\s?#.*", "", text)
tokens = []
names = []
intro = []
passwd = []
for line in text.split("\n"):
    if line != "":
        info = re.split("\s", line)
        tokens.append(info[0])
        names.append(info[1])
        intro.append(info[2])
        if len(info) == 4:
            passwd.append(info[3])
        else:
            passwd.append("")

infos = list(zip(names, tokens, intro, passwd))

docker_compose_yml = version_format
for info in infos:
    name = info[0]
    token = info[1]
    intro = info[2]
    passwd = info[3]
    path_data_name = path_data + '/' + name
    path_mods_name = path_data + '/' + 'mods'
    os.system("cd " + path)
    os.system('cp -rf template ' + path_data_name)
    os.system('cp -rf mods ' + path_mods_name)
    with open(path_data_name + "/cluster_token.txt", 'w') as f:
        f.write(token)
    with open(path_data_name + "/cluster.ini", 'w') as f:
        f.write(cluster_ini.format(
            name=name,
            intro=intro,
            passwd=passwd,
        ))

    docker_compose_yml = docker_compose_yml + \
                         service_format.format(
                             name=name,
                             ini_path=path_data_name,
                             mods_path = path_mods_name,
                             mods_setup_path=path_data_name + "/dedicated_server_mods_setup.lua",
                         )

with open(path_data + "/docker-compose.yml", 'w') as f:
    f.write(docker_compose_yml)
