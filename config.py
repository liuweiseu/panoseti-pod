#! /usr/bin/env python3
import os, sys
import yaml
from argparse import ArgumentParser

X86_IMAGE = 'ghcr.io/liuweiseu/ubuntu-x86:24.04-v1.2'
AARCH64_IMAGE = 'ghcr.io/liuweiseu/ubuntu-aarch64:24.04-v1.2'

if __name__ == "__main__":
    # Step 0: parse the arguments
    parser = ArgumentParser(prog=os.path.basename(__file__))
    parser.add_argument('--sw-path', dest='sw_path', type=str, 
                        default=None,
                        help='The path of the PanoSETI control software.')
    parser.add_argument('--clone-sw', dest='clone_sw', action='store_true',
                        default=False,
                        help='clone the PanoSETI control software.')
    parser.add_argument('--arch', dest='arch', type=str,
                        default='x86', choices=['x86', 'aarch64'],
                        help='The architecture of the CPU')
    opts = parser.parse_args()

    # get the current dir
    cur_path = os.path.abspath(__file__)
    cur_dir = os.path.dirname(cur_path)
    # get the paramters
    if opts.clone_sw:
        sw_path = cur_dir
        if os.path.exists('panoseti'):
            print('The panoseti directory exists.')
        else:
            cmd = 'git clone -b container --depth=1 https://github.com/panoseti/panoseti.git'
            os.system(cmd)
    elif opts.sw_path != None:
        sw_path = opts.sw_path
    else:
        print('*************************************************************')
        print('Please specify the panoseti software path with `--sw-path`.')
        print('Or please use `--clone-sw` to clone the repo automatically.')
        print('*************************************************************')
        sys.exit()
    if opts.arch == 'x86':
        image = X86_IMAGE
    elif opts.arch == 'aarch64':
        image = AARCH64_IMAGE

    # open the template
    with open('template/template.yaml', 'r', encoding='utf-8') as f:
        template_config = yaml.safe_load(f)
    
    # populate the config
    template_config['spec']['containers'][0]['image'] = image
    # the first vol is panoseti-control, and it could be in somewhere else.
    template_config['spec']['volumes'][0]['hostPath']['path'] = '%s/panoseti'%sw_path
    for vol in template_config['spec']['volumes'][1:]:
        p = vol['hostPath']['path']
        vol['hostPath']['path'] = '%s/%s'%(cur_dir, p)
    # dump yaml file
    with open('panoseti-pod.yaml', 'w', encoding='utf-8') as f:
        yaml.dump(template_config, f, allow_unicode=True)
    print('panoseti-pod.yaml generated successfully!')
