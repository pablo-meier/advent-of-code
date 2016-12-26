#!/bin/sh

tail -n+3 input.txt | awk '{ xy=substr($1, 16); split(xy, splitted, "-"); printf("INSERT INTO advent_cluster (x,y,total_space,used,available) VALUES (%d,%d,%d,%d,%d);\n", substr(splitted[1], 2), substr(splitted[2], 2), $2, $3, $4); }' > inserts.sql
