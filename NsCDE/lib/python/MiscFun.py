#!/usr/bin/python
#import signal
#signal.signal(signal.SIGINT, signal.SIG_DFL)
import os.path
import subprocess
import sys
import os

def execWithShell1(cmd):
    print cmd
    #cmd='echo hello'
    print subprocess.check_output(cmd, shell=True)

#this also seems to introduce quite a delay
def execWithShell(cmd):
    try:
        output=subprocess.check_output(cmd, shell=True)
    except subprocess.CalledProcessError as e:
        print cmd
        print '!!!!!!!!!!!!!!!!!!!ERROR!!!!!!!!!!!!!!!!!!!!!!!'
        print e.output
        output=''
    return output
def execWithShellThread(cmd):
        try: 
            p=subprocess.Popen(cmd,shell=True) 
        except OSError as e: 
            #this doesnt seem to work
            print cmd
            print '!!!!!!!!!!!!!!!!!!!ERROR!!!!!!!!!!!!!!!!!!!!!!!'
            print e.output
            p=''
        return p
def checkFile(filename):
    if os.path.isfile(filename):
        return filename
    else:
        print 'FILE NOT FOUND: '+filename
        sys.exit()
def checkDir(filename):
    if os.path.isdir(filename):
        return filename
    else:
        print 'DIRECTORY NOT FOUND: '+filename
        sys.exit()

