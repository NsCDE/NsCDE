#!/usr/bin/env python3

#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

import configparser, getopt, os, sys, re

def usage():
    print ("confset [ -c <file> -t [ properties|ini ] [ -s <section> ] -k <key> -v <value> | [ -h ]")

def cmdoptions():
    section = ''
    typecf = ''
    removekey = 0

    try:
        opts, args = getopt.getopt(sys.argv[1:], "c:t:rs:k:v:h", ["conffile=", "typecf=", "remove", "section=", "key=", "value=", "help"])
    except getopt.GetoptError as err:
        print(err)
        sys.exit(2)
    output = None
    verbose = False
    for o, a in opts:
        if o in ("-c", "--conffile"):
            conffile = a
        elif o in ("-t", "--typecf"):
            typecf = a
        elif o in ("-r", "--remove"):
            removekey = 1
        elif o in ("-s", "--section"):
            section = a
        elif o in ("-k", "--key"):
            key = a
        elif o in ("-v", "--value"):
            value = a
        elif o in ("-h", "--help"):
            usage()
            sys.exit()
        else:
            assert False, "getopt: unhandled option"

    if removekey:
       value = ''

    return conffile, typecf, section, key, value, removekey

def removew(d):
    for k, v in d.iteritems():
        if isinstance(v, dict):
            removew(v)
        else:
            d[k]=v.strip()

def main ():
    conffile, typecf, section, key, value, removekey = cmdoptions()

    if typecf == '':
        typecf = 'ini'

    if typecf == 'ini':
        parser = configparser.ConfigParser()
        parser.optionxform = lambda option: option
        parser.read(conffile)

        try:
            if removekey:
                parser.remove_option(section, key)
            else:
                parser.set(section, key, value)
        except configparser.NoSectionError:
            if not removekey:
                print ("No section named " + section + " creating it.")
                parser.add_section(section)
                parser.set(section, key, value)

        with open(conffile, 'w') as cff:
            parser.write(cff)

    if typecf == 'properties':
        try:
            with open(conffile, 'r+') as cff:
                props = dict(line.split('=', 1) for line in cff)
                checkprops = props
                checkprops = [x.strip() for x in checkprops]
                if not key in checkprops:
                    cff.write(key + ' = ' + value + '\n')
                else:
                    cff.seek(0)
                    cff.truncate()
                    for dkey, val in props.items():
                        mkey = re.findall(key + '.*', dkey)
                        if mkey:
                            cff.write(key + ' = ' + value + '\n')
                        else:
                            cff.write(dkey + '=' + val)
            cff.close()
        except:
            print ("Cannot open file", conffile, "trying to create it.")
            fh = open(conffile, 'w')
            fh.write(key + ' = ' + value + '\n')
            fh.close()

# Action ...
if __name__ == '__main__':
    cmdoptions()
    main()

