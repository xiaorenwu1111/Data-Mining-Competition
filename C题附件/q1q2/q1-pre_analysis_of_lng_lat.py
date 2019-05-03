#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 25 18:53:53 2019

@author: cuidanni
"""

import csv
    
csv_reader = csv.reader(open("/Users/cuidanni/Desktop/cq1/AF00373.csv"))

location = []
for row in csv_reader:
    location.append(row)

fopen = open('/Users/cuidanni/Desktop/cq1/AF00373.txt', 'w')
for i in range(1,len(location)):
    strl = []
    strl = "'" + str(i) + "': " + str(location[i]) +","
    fopen.write(strl+'\r\n')
    
 # {name: 'Z??rich', value: 129},   
fopen = open('/Users/cuidanni/Desktop/cq1/AF00373d.txt', 'w')
for i in range(1,len(location)):
    strl = []
    strl = "{name: '" + str(i) + "', value: 12}," 
    fopen.write(strl+'\r\n')
    
    
