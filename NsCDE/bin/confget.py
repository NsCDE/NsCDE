#!/usr/bin/python

import ConfigParser, getopt, os, sys, re

def usage():
    print "confget [ -c <file> [ -s <section> ] -k <key> [ -h ]"

def cmdoptions():
    section = ''
    typecf = ''

    try:
        opts, args = getopt.getopt(sys.argv[1:], "c:s:k:h", ["conffile=", "section=", "key=", "help"])
    except getopt.GetoptError as err:
        print(err)
        sys.exit(2)
    output = None
    verbose = False
    for o, a in opts:
        if o in ("-c", "--conffile"):
            conffile = a
        elif o in ("-s", "--section"):
            section = a
        elif o in ("-k", "--key"):
            key = a
        elif o in ("-h", "--help"):
            usage()
            sys.exit()
        else:
            assert False, "getopt: unhandled option"

    return conffile, section, key

def main ():
    conffile, section, key = cmdoptions()

    parser = ConfigParser.ConfigParser()
    parser.optionxform = lambda option: option
    parser.read(conffile)

    try:
        print parser.get(section, key)
    except ConfigParser.NoSectionError:
        sys.exit(2)
    except ConfigParser.NoOptionError:
        sys.exit(3)

# Action ...
if __name__ == '__main__':
    cmdoptions()
    main()

