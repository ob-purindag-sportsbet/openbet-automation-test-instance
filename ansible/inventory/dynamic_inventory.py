# dynamic_inventory.py
import json
import yaml
import sys

# Get the YAML file name from the command line arguments
filename = sys.argv[1]

with open(filename, 'r') as file:
    data = yaml.safe_load(file)

# Use the machine_ip as the host if it exists, otherwise use the name
host = data['instance'].get('machine_ip', data['instance']['name'])

inventory = {
    'all': {
        'hosts': [host],
        'vars': {
            'ansible_ssh_private_key_file': data['instance'].get('ssh_key', data['instance'].get('private_key_path')),
            'ansible_user': data['instance'].get('ssh_user', data['instance'].get('username')),
            'ansible_python_interpreter': data['instance'].get('python_interpreter', '/usr/bin/python3'),
            'instance_type': data['instance'].get('instance_type'),
            'keypair': data['instance'].get('keypair'),
            'ec2_image': data['instance'].get('ec2', {}).get('image'),
            'ec2_user': data['instance'].get('ec2', {}).get('user'),
            'tags': data['instance'].get('tags'),
            'num_instances': data['instance'].get('num_instances')
        }
    },
    '_meta': {
        'hostvars': {}
    }
}

print(json.dumps(inventory))