# Bulk Rename Images in Directory 
#
# Req: Python 3.x
#
# Usage: `python3 rename-files.py`
  
import os, sys
import readline
import time

readline.parse_and_bind("tab: complete")

def main():
    temp = os.system("clear")
    cwd = os.getcwd()
    indir = input("Directory to Rename (" + cwd + "): ")
    outdir = input("Output Directory (" + cwd + "): ")
    name = input("What should these files be named? (auto): ")

    if (indir == ""):
        indir = cwd

    if (outdir == ""):
        outdir = cwd

    temp = os.system("clear")
    print("Input Directory: " + indir)
    print("Output Directory: " + outdir)
    if (name == ""):
        print("\n** Files will be sequentially renamed **")
    else:
        print("File Names: " + name + "-x.ext")

    filecount = sum(len(files) for _, _, files in os.walk(indir))
    if not input("\nAre you sure you want to rename " + str(filecount) + " files? (y/n): ").lower().strip()[:1] == "y": sys.exit(1)

    i = 1

    try:
        os.makedirs(outdir)
    except FileExistsError:
        # directory exists
        pass
      
    for filename in os.listdir(indir):
        dst = None
        if (name == ""):
            dst = str(i) + os.path.splitext(filename)[1]
        else:
            dst = name + '-' + str(i) + os.path.splitext(filename)[1]
        src = indir + '/' + filename
        dst = outdir + '/' + dst

        # print("Renaming: " + src + " --> " + dst)

        try:
            os.rename(src, dst)
            i += 1
        except:
            print("File Error: " + src)

    time.sleep(2) # artifical sleep, otherwise it feels like nothing happened
    print("\nProcessing Complete!\n")
  
if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n")
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)