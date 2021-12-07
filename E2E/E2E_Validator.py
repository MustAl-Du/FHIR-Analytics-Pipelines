import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--StorageConnectionString", help="Storage connection string.")
parser.add_argument("--SqlUsername", help="SQL username")
parser.add_argument("--SqlPassword", help="SQL password")
args = parser.parse_args()

if __name__ == "__main__":
    sys.stdout.flush()

    print('Executing script file is:', str(sys.argv[0]))
    print('The arguments are:', str(sys.argv))

    print('Hello ', args.world)
