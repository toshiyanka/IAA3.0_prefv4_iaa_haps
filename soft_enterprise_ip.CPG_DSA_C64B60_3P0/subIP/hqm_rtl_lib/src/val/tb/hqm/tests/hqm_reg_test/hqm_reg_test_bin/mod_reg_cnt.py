#!/usr/bin/python

import string
import sys
import re

class mod_reg_cnt:
    'module register counts'

    def get_reg_cnt(self,un_fname='untestables.txt',is_fname='istestables.txt',fw_fname='mod_reg_cnts.txt'):
        try:
            fun_hand = open(un_fname)
        except:
            print ('File cannot be opened:',un_fname)
            exit()
        try:
            fis_hand = open(is_fname)
        except:
            print ('File cannot be opened:',is_fname)
            exit()
        try:
            fw_hand = open(fw_fname,'w')
        except:
            print ('File cannot be opened:',fw_fname)
            exit()

        hd_str = '%21s:%10s %10s\n' % ('Module','testable','untestable')
        print(hd_str)
        fw_hand.write(hd_str)

        is_counts = dict()
        for line in fis_hand:
            colonpos = line.find(':')
            modname = line[:colonpos]
            modnamefrag = re.findall('(.+)\[[0-9]+\]$',modname)
            if len(modnamefrag) > 0:
                modname_str = modnamefrag[0]
                modname = '%s%s' % (modname_str, '[*]')
            if modname not in is_counts:
                is_counts[modname] = 1
            else :
                is_counts[modname] += 1

        un_counts = dict()
        for line in fun_hand:
            colonpos = line.find(':')
            modname = line[:colonpos]
            modnamefrag = re.findall('(.+)\[[0-9]+\]$',modname)
            if len(modnamefrag) > 0:
                modname_str = modnamefrag[0]
                modname = '%s%s' % (modname_str, '[*]')
            if modname not in un_counts:
                un_counts[modname] = 1
            else :
                un_counts[modname] += 1

        lst = list(un_counts.keys())
        for key in lst:
            if key not in is_counts:
                 is_counts[key] = 0
        lst = list(is_counts.keys())
        lst.sort()
        for key in lst:
            if key not in un_counts:
                 un_counts[key] = 0
            fw_str = '%21s:%10d %10d' % (key,is_counts[key],un_counts[key])
            print(fw_str)
            fw_hand.write(fw_str)
            fw_hand.write('\n')

mod_reg_cnt1 = mod_reg_cnt()

if __name__ == "__main__":
    if len(sys.argv) > 1 :
         mod_reg_cnt1.get_reg_cnt(sys.argv[1], sys.argv[2])
    else :
         mod_reg_cnt1.get_reg_cnt()

