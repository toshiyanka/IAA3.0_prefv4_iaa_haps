#!/usr/intel/bin/python

import re, string, os, datetime, shutil,getpass, traceback

#time stamp for marking output file with it
x=datetime.datetime.now()
y=x.strftime("%d")+"_"+x.strftime("%b")+"_"+x.strftime("%Y")
defaultArea="$IP_MODELS/hqm/hqm-srvr10nm-wave4-latest/verif/tb/hqm/reglist/"
lst=["hqm_functional","hqm_compliance","hqm_hqmproc_functional","hqm_reg"]

#list of email recepients
ListOwners=["nitya.joshi@intel.com",getpass.getuser()]    #error debuggers list
MailList=[getpass.getuser(),"nitya.joshi@intel.com"]    #mail recievers

def concat(lst):
 mailist=""
 for id in lst:
  mailist=mailist+id+","
 return mailist

errmailst=concat(ListOwners)
mailst=concat(MailList)

errmailer='mail -s "Test run ERROR: Please check code" ' +errmailst+' <out_file'
mailer='mail -s "Miscellaneous Error Check" '+mailst+" <out_file"
#folchk checks all files inside dirname for the +defaults and -defaults balance using defchk
def folchk(defar, dirname):
	#output file temporarily being worked with as out_file
	outfile=open("out_file","a")
	outfile.write("\n=================================\nSub directory: "+dirname+"\n=================================")

	#defchk function takes a file as input
	def defchk(deflist):
		defaultfile=open(os.path.dirname(os.path.realpath(__file__))+"/cpdirec/"+deflist,"r")
		#scans each line and splits it on spaces to get a list of words in the line
		line=defaultfile.readline()
		flg=0
		pluslist=[]
		while (line):
			words=re.split("\s",line)
			while "" in words:
				words.remove("")
			if words==[]:
				b=0
			#if the first word is +defaults then that words list is added to the +default accumulator pluslist (a list of +defaults words list). 
			elif (words[0]=="+defaults"):
				pluslist=pluslist+[words]

			#when the first word is -defaults, the contents of words after -defaults are searched for in the pluslist.
			elif (words[0]=="-defaults"):
				i=0
				a=len(pluslist)
				for ls in pluslist:
					# if a match is found it is popped out of pluslist 
					if words[1:]==ls[1:]:
						pluslist.pop(i)
					i+=1

				#else a line is printed in the output file alerting about the presence of an unmatched +/-defaults
				if a==len(pluslist):
					outfile.write("\n+/-defaults mismatch: "+deflist)
					flg+=1
					break
			line=defaultfile.readline()

		#if no imbalanced -defaults raised an error, and there are imbalanced +defaults left in pluslist an error line is printed in output.
		if (pluslist!=[]) and (flg==0):
			outfile.write("\n+/-defaults mismatch: "+deflist)
		defaultfile.close()

	#splchk checks for presence of typing errors like +/-default and ++
	def splchk(deflist):
		defaultfile=open(os.path.dirname(os.path.realpath(__file__))+"/cpdirec/"+deflist,"r")
		line=defaultfile.readline()
		i=0
		while (line):
			words=re.split("\s",line)

			#remove white spaces to avoid reporting of extra errors than reality
			while "" in words:
				words.remove("")

			#ignore empty lines to save from running into out of index error
			if words!=[]:
				cmtch=re.findall("^#",words[0])
				#perform checks only on non-comment lines
				if cmtch==[] and ("+default"==words[0] or "-default"==words[0] or "++" in line):
					outfile.write("\ntyping error: "+deflist)
					break
			line=defaultfile.readline()
		defaultfile.close()

	#checks if number of .repeat are even or not
	def repchk(deflist):
		defaultfile=open(os.path.dirname(os.path.realpath(__file__))+"/cpdirec/"+deflist,"r")
		line=defaultfile.readline()
		repcnt=0
		while (line):
			words=re.split("\s",line)
			while "" in words:
				words.remove("")
			if words!=[]:
				if ".repeat" in words[0]: 
					repcnt+=1
			line=defaultfile.readline()
		flg=repcnt%2
		if flg==1:
			outfile.write("\n.repeat error: "+deflist)
		defaultfile.close()


	#checks if ny testcases are comments
	def comchk(deflist):
		defaultfile=open(os.path.dirname(os.path.realpath(__file__))+"/cpdirec/"+deflist,"r")
		line=defaultfile.readline()
		lcnt=0
		while (line):
			lcnt+=1
			words=re.split("\s",line)
			while "" in words:
				words.remove("")
			if words!=[]:
				hmtch=re.findall("^#",words[0])
				if "#.include" in words[0] or (hmtch!=[] and "-dirtag" in line):
					outfile.write("\nCommented out testcase: "+deflist)
					return 0
			line=defaultfile.readline()
		defaultfile.close()


	if os.path.isdir(os.path.dirname(os.path.realpath(__file__))+"/cpdirec"):
		shutil.rmtree(os.path.dirname(os.path.realpath(__file__))+"/cpdirec")

	os.system("cp -r "+defar+dirname+" "+os.path.dirname(os.path.realpath(__file__))+"/cpdirec")
	os.system("chmod -R 777 "+os.path.dirname(os.path.realpath(__file__))+"/cpdirec")
	filecnt=0
	for filename in os.listdir(os.path.dirname(os.path.realpath(__file__))+"/cpdirec"):
		defchk(filename)
	for filename in os.listdir(os.path.dirname(os.path.realpath(__file__))+"/cpdirec"):
	        splchk(filename)
	for filename in os.listdir(os.path.dirname(os.path.realpath(__file__))+"/cpdirec"):
		repchk(filename)
	for filename in os.listdir(os.path.dirname(os.path.realpath(__file__))+"/cpdirec"):
		comchk(filename)
		filecnt+=1
	shutil.rmtree(os.path.dirname(os.path.realpath(__file__))+"/cpdirec")
	outfile.write("\nnumber of files scanned="+str(filecnt)+"\n")
	outfile.close()

#follstchk is folchk but with multiple folder input possible
def follstchk(defaultArea, dirs):
	outfile=open("out_file","a")
	outfile.write("Hello,\n\nHere is a list of testcases that might have some miscellaneous errors in them.\n")
	outfile.write("\n==================================================================\nDirectory: "+defaultArea+"\n==================================================================")
	outfile.close()
	for dir in dirs:
		folchk(defaultArea,dir)
	outfile=open("out_file","a")
	outfile.write("\n\nRegards,\nNitya Joshi.")
	outfile.close()

#attempt to run the script and then mail the output
try:
	follstchk(defaultArea,lst)
	os.system(mailer)
	#if anything fails, code creators get a notification mail with error traceback to debug the code
except:
	mail=open("out_file","w")
	mail.write("Your testrun failed.\n\n")
	traceback.print_exc(file=mail)
	mail.close()
	os.system(errmailer)

#file cleanup post run, shifts output to output log folder with a time stamp, in order to avoid clutter in the directory where script would be running periodically
finally:
	if os.path.isdir(os.path.dirname(os.path.realpath(__file__))+"/outlog"):
		os.rename("out_file",os.path.dirname(os.path.realpath(__file__))+"/outlog/out_file_"+y)
	else:
		os.mkdir(os.path.dirname(os.path.realpath(__file__))+"/outlog")
		os.rename("out_file",os.path.dirname(os.path.realpath(__file__))+"/outlog/out_file_"+y)
	exit()
