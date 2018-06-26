#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from dateutil.parser import parse
from pprint import pprint


def get_seconds(colon_time):
    """ Get amount of seconds based on "00:00:00" format """
    t = list(map(int, colon_time.split(':')))

    return int(t[2] + t[1] * 60 + t[0] * 3600)

def get_slurm_seconds(slurm_time):
    """ Get amount of seconsd based on "1-00:00:00.00" format """

    days = 0
    if '-' in slurm_time:
        days = int(slurm_time.split('-')[0])



def main(argv):
    lines = [line.strip().split() for line in open(argv[0])]
    lines.pop(0) # skip Running on ...
    lines.pop(0) # skip mip5.0
    header = lines.pop(0)
    lines.pop(0) # skip ------

    sums = dict(zip(header, [ 0 for h in range(len(header)) ])) # init ;)
    alloc_elapsed = 0

    #import ipdb; ipdb.set_trace()
    for line in lines:

        line = dict(zip(header, line))
        if 'Partition' in line and line['Partition'] == 'core':

            elapsed = get_seconds(line['Elapsed'])

            sums['Elapsed'] += elapsed
            alloc_elapsed += elapsed * int(line['AllocCPUS'])

    #start_time = parse(lines[0][7])
    #end_time   = parse(lines[-1][8])
    #delta = end_time - start_time

    core_hours = alloc_elapsed / 3600.0

    print('Node time: {}'.format(sums['Elapsed'] / 3600.0))
    #print('Rasta time: {}'.format(delta.total_seconds() / 3600.0))
    print('Core time: {}'.format(core_hours))

    print('Rasta cap: {}'.format(21 * 16 * 24 / core_hours))





if __name__ == "__main__":
    main(sys.argv[1:])
