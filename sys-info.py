import argparse
import csv
import datetime
import os
import paramiko
import socket
import sys

__version__ = "1.0.0"

parser = argparse.ArgumentParser(description='Get SysInfo for Remote Systems')
parser.add_argument("-f", "--file", help="Input file for bulk IPs", type=str)
parser.add_argument("-u", "--username", help="SSH username to use for remote connections", type=str, required=True)
parser.add_argument("-p", "--password", help="SSH password to use for remote connections", type=str, required=True)
parser.add_argument("-c", "--cmd", help="Command to run on remote hosts", type=str)
parser.add_argument("-v", "--version", help="current SysInfo version.", action="store_true")
args = parser.parse_args()

client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

data = {}

def get_sys_info(ip, cmd):     
    global client
    try:
        print(f"[" + str(ip) + "]")
        client.connect(ip, username=args.username, password=args.password, timeout=3)

        stdin, stdout, stderr = client.exec_command(cmd)

        if stdout is not None: 
            for line in stdout:
                print("Output:", line)
                return line.rstrip()

        client.close()
    except Exception as e:
        print("Error:", e, end="\n\n")
        return "Error: " + str(e)
        pass

def save_csv(data):
    headers = ['Hostname', 'IP Address', 'Timestamp (PT)', 'Command', 'Output']

    if os.path.isfile('output.csv'):
        with open('output.csv', 'a', encoding="utf-8") as outfile:
            writer = csv.writer(outfile)
            for key, value in data.items():
                writer.writerow([key, value])
    else:
        with open('output.csv', 'w', encoding="utf-8") as outfile:
            writer = csv.writer(outfile)
            writer.writerow(headers)
            for key, value in data.items():
                writer.writerow([key, value])

def main():
    """main func."""

    if args.version:
        print(f"Current Version: {__version__}\n")
        sys.exit(0)

    if args.file:
        hosts = open(args.file, 'r') 
    else:
        hosts = open('hosts.txt', 'r')

    if args.cmd:
        cmd = args.cmd
    else:
        cmd = "uptime | awk -F'( |,|:)+' '{print $6,$7\",\",$8,\"hours,\",$9,\"minutes.\"}'"

    count = 0

    while True: 
        count += 1
        host = hosts.readline().rstrip()
        if not host: 
            break

        out = get_sys_info(host, cmd)

        data[str(host)] = {}
        data[str(host)]['ip'] = socket.gethostbyname(host)
        data[str(host)]['timestamp'] = str(datetime.datetime.now())
        data[str(host)]['cmd'] = cmd
        data[str(host)]['output'] = out

    hosts.close() 

if __name__ == '__main__':
    try:
        print("** Gathering system information... **\n")
        main()
        print(data, end="\n\n")
        save_csv(data)
        print("FINISHED\n")
    except KeyboardInterrupt:
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)