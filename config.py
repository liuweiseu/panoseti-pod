import os
import yaml
from argparse import ArgumentParser

if __name__ == "__main__":
    # Step 0: parse the arguments
    parser = ArgumentParser(prog=os.path.basename(__file__))
    parser.add_argument('--sw-path', dest='sw_path', type=str, 
                        default='/home/wei',
                        help='The path of the cali')

    opts = parser.parse_args()