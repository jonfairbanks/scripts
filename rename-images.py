# Bulk Rename Images in Directory 
#
# Req: Python 3.x
#
# Usage: `python3 rename_images.py`
  
import os, sys
from colorama import Fore, Style
  
def main():
    indir = input("Directory to Rename: ")
    outdir = input("Output Directory: ")

    if (indir == ""):
        print(Fore.RED + "A valid input directory is required...")
        print(Style.RESET_ALL) 
        indir = input("Directory to Rename: ")

    if (outdir == ""):
        print(Fore.RED + "A valid output directory is required...")
        print(Style.RESET_ALL) 
        outdir = input("Output Directory: ")

    print("Input Directory: " + indir)
    print("Output Directory: " + outdir)

    if not input("\nAre you sure you want to rename images? (y/n): ").lower().strip()[:1] == "y": sys.exit(1)

    i = 1

    try:
        os.makedirs(outdir)
    except FileExistsError:
        # directory already exists
        pass
      
    for filename in os.listdir(indir):
        dst = str(i) + '.jpg'
        src = indir + '/' + filename
        dst = outdir + '/' + dst

        print("Renaming: " + src + " --> " + dst)

        os.rename(src, dst)
        i += 1
  
if __name__ == '__main__': 
    main()