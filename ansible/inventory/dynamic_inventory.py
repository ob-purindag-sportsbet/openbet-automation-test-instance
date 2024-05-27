#!/usr/bin/env python3

import json
import yaml
import os

def load_yaml_file(filename):
    with open(filename, 'r') as file:
        return yaml.safe_load(file)

def create_local_inventory(data):
    machine_ip = data['instance'].get('machine_ip')
    username = data['instance'].get('username', 'ubuntu')
    ssh_key = data['instance'].get('ssh_key', '~/.ssh/id_rsa')

    inventory = {
        'all': {
            'hosts': ['local_machine'],
            'vars': {
                'ansible_ssh_private_key_file': ssh_key,
                'ansible_user': username,
                'ansible_python_interpreter': data['instance'].get('python_interpreter', '/usr/bin/python3')
            }
        },
        '_meta': {
            'hostvars': {
                'local_machine': {
                    'ansible_host': machine_ip
                }
            }
        }
    }
    return inventory

def create_aws_inventory(data):
    profile = data.get('aws_profile', 'default')
    instance_tags = data['instance'].get('tags', {})

    inventory = {
        'plugin': 'aws_ec2',
        'regions': [data.get('ec2_region', 'ap-southeast-1')],
        'filters': {
            'instance-state-name': 'running'
        },
        'keyed_groups': [
            {
                'key': 'tags.Name',
                'prefix': 'tag'
            }
        ],
        'hostnames': [
            'tag:Name'
        ],
        'compose': {
            'ansible_host': 'public_ip_address'
        },
        'strict': False,
        'aws_profile': profile
    }
    return inventory

def main():
    yaml_file = os.getenv('INVENTORY_YAML_FILE')
    if not yaml_file:
        print("Error: INVENTORY_YAML_FILE environment variable not set.")
        sys.exit(1)

    data = load_yaml_file(yaml_file)

    target = data.get('target')
    if target == 'local':
        inventory = create_local_inventory(data)
    elif target == 'aws':
        inventory = create_aws_inventory(data)
    else:
        print("Error: Unknown target specified in the YAML file")
        sys.exit(1)

    print(json.dumps(inventory, indent=2))

if __name__ == "__main__":
    main()
