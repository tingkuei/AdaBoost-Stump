import sys
import re
import math

# in/out file declare
infile=open(sys.argv[1],'r')
outfile=open(sys.argv[2],'wb')

test_pattern=r'.\w*\.\w+'
Data_rate=[]
Threshold1=172.5
label=0;
i=0
temp_list=[];
while True :
	string=infile.readline()
	if not string:
		break	
	match=re.findall(test_pattern,string)
	if match:
		temp_list=match
		for i in range(1,len(temp_list)):
			outfile.write(str(temp_list[i])+' ')
		if float(temp_list[0]) > Threshold1:
			outfile.write(str(1)+' ')
		else:
			outfile.write(str(-1)+' ')
		outfile.write('\n')
total_lines=i
infile.close()
outfile.close()	