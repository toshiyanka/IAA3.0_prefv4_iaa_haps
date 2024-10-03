#!/usr/intel/bin/python

import re, os, datetime, shutil, traceback, getpass
#time stamp for marking output file with it
x=datetime.datetime.now()
y=x.strftime("%d")+"_"+x.strftime("%b")+"_"+x.strftime("%Y")

#list of email recepients
MailList=["nityajos",getpass.getuser()]    #mail recievers
ListOwners=["nitya.joshi@intel.com",getpass.getuser()]    #error debuggers list

IPMod="$IP_MODELS/hqm/hqm-srvr10nm-wave4-latest/"
inpath="verif/tb/hqm/scripts/disable_test_check/"

def pathjoin(a,b):
 a=a.strip()
 b=b.strip()
 a=a.rstrip("/")
 b=b.strip("/")
 c=a+"/"+b+"/"
 return c

#list of common cases
comexlst=pathjoin(IPMod,inpath)+"com_ex"

#list of modes
bglst=[pathjoin(IPMod,inpath)+"bg_ex","HQM_DISABLE_BACKGROUND_CFG_GEN_SEQ","Background","BG"]
aglst=[pathjoin(IPMod,inpath)+"ag_ex","HQM_SKIP_AGITATE_SEQ","Agitate","AG"]
phlst=[pathjoin(IPMod,inpath)+"ph_ex","HQM_DISABLE_PROCHOT_DRIVE","Proc_Hot","PH"]
idlst=[pathjoin(IPMod,inpath)+"ism_ex","+HQM_DIS_PRIM_ISM_DLY_OVERRIDE","Prim ISM Delay","ISM Delay"]
lst=[bglst,aglst,phlst,idlst]			#list of modes being input

#string pieces for email header
inimsg=["Hello,\n\nHere is the list of testcases that have been excluded in ","mode regressions, but have not been reviewed yet.\n\nIf ","modes need to be disabled for your tests, please include them in respective exclusion files to avoid reporting.\n\nNumber of tests disabled and not reviewed for:"]

def concat(lst):
 mailist=""
 for id in lst:
  mailist=mailist+id+","
 return mailist

errmailst=concat(ListOwners)
mailst=concat(MailList)

modename=""
for ele in lst:
 modename=modename + ele[3] +"/ "
modename=modename.rstrip("/ ")

simreg="simregress -l $IP_MODELS/hqm/hqm-srvr10nm-wave4-latest/verif/tb/hqm/reglist/hqm_functional/hqm_functional.list -model hqm -dut hqm -notify -ver $IP_MODELS/hqm/hqm-srvr10nm-wave4-latest/ -n -test_results hqmv25_reg"
errmailer='mail -s "Testrun ERROR: Please check code" ' +errmailst+' <out_file'
mailer='mail -s "Tests disabled in '+modename+' modes" '+mailst+' <out_file'
mailrunner='mail -s "All tests reviewed in '+modename+' modes" '+getpass.getuser()+' <out_file'


#function to get path for a file, used in extending functionality to relative paths inside the lists

def pathdir(line):
 absolute1=line.find("/")
 absolute2=line.find("$")
 if(absolute1==0 or absolute2==0):
  path=os.path.dirname(line)
 if(absolute1!=0 and absolute2!=0):
  path=os.path.dirname(os.path.realpath(__file__))
 path=path+"/"
 return path

#returns 1 if string is the first word in any line of the file
def exclude(file,string):
 excl=open(file,"r")
 matchline=excl.readline()
 match=re.split("\s",matchline)
 while(matchline):
  if(string==match[0]):
   return 1
  if("string"!=match[0]):
   matchline=excl.readline()
   match=re.split("\s",matchline)
 excl.close()
 return 0

#returns the first word in sentence and tells to ignore line if its blank 
def textract(sentence):
 sentence=sentence.strip()
 word=re.split("\s", sentence)
 i=0
 if sentence=="\n" or sentence=="":
  return "ignore this line pls"
 if sentence!="\n":
  while word[i]=="":
   i+=1
  return word[i]

#function for creating the main exclusion list. filin is the input list path, filou gets created from filin by adding all the the testcases from filin, and the paths are opened and testcases from there added too. Child paths can also lead to more testcase paths.
def fopener(filin,filou):
 abs1=filin.find("/")
 abs2=filin.find("$")
 path=pathdir(filin)
 filpath=(os.path.realpath(__file__)) 
 fildir=pathdir(filpath)
 if(abs1==0 or abs2==0): #a local copy of absolute file is made which is deleted after addition of testcases from it is over.
  fnamelst=re.split("/",filin)
 # shutil.copy(filin , fildir+"copy"+fnamelst[-1])
  copier="cp "+filin+" "+fildir+"copy"+fnamelst[-1]
  os.system(copier)
  os.chmod(fildir+"copy"+fnamelst[-1],0o666)
  filst=open(fildir+"copy"+fnamelst[-1],"r")
 if(abs1!=0 and abs2!=0): #recursion as an absolute path if relative path/filename inside cwd was given)
  fopener(path+filin,filou)
  return 1
 
 #listing out of testcases occurs in this block
 filo=open(filou,"a")
 bline=filst.readline()
 while bline:
  word=textract(bline)
  key="#" in word[0] or word=="ignore this line pls"
  if(key!=0):
   bline=filst.readline()
  if(key==0):
   if(word!="include"):
    filo.write(word)
    filo.write("\n")
    bline=filst.readline()
   if(word=="include"):
    incl=re.split(word,bline)
    fname=textract(incl[1])
    filo.close()
    patt=re.search("\w",fname)
    absc=patt.start()
    if absc!=0:
     fopener(fname,filou)
    if absc==0:
     fopener(path+fname,filou)
    filo=open(filou,"a")
    bline=filst.readline()
 filo.close()
 filst.close()
 os.remove(fildir+"copy"+fnamelst[-1])

#takes exclusion file name,the keyword required to be looked up, and name of the mode. opens exclusion file and adds all testcases in it and its child files. opens common list and does the same. takes the final exclusion list of approved testcases created and skips them from being written in the output file 
def filtr(bg_ex,keytofindmode,modename,comex,fileoutput): 
 fileinput=open("hqmv25_reg/hqm/hqm/hqm_functional.list/hqm_functional.list.netbatch_ready","r")
 bd=0
 fopener(bg_ex,"bgexlst")
 fopener(comex,"bgexlst")     #comex is the Common file list for all three modes
 line=fileinput.readline()
 fileoutput.write("\n\n=================================\nTestlist for "+modename+" mode disabled:\n=================================")
 while line:
  key=keytofindmode in line
  if(key):
   parts=re.split("trex",line)
   listo=parts[1]
   testname=textract(listo)
   ex=exclude("bgexlst",testname)
   if(ex==0):
    if(bd==0):
     prevtest=testname
     fileoutput.write("\n")
     fileoutput.write(testname)
    if(bd!=0):
     if(prevtest==testname):
      bd-=1
     if(prevtest!=testname):
      fileoutput.write("\n")
      fileoutput.write(testname)
      prevtest=testname
    bd+=1
  line=fileinput.readline()
 os.remove("bgexlst")
 fileinput.close()
 return bd


def bodfunc(comex,inimsg,lsts):
 fileop=open("out_file","w")
 fileop.write(inimsg[0]+inimsg[1]+inimsg[2]+"                                                                                                                                                                                                                                        ")
 paths=open("plist","w")
 paths.write("\n\n=================================\nReviewed tests exclusion files:\n=================================")
 errcnt=0
 inimstr=""
 for lst in lsts:
  lastmodename=lst[2]
  paths.write("\n"+lst[2]+" mode: ")
  pat=re.search("\w",lst[0])
  wloc=pat.start()
  if wloc==0:
   paths.write("./")
  paths.write(lst[0])
  cnt=filtr(lst[0],lst[1],lst[2],comex,fileop)
  inimsg[0]=inimsg[0]+lst[2]+", "
  inimsg[1]=inimsg[1]+lst[2]+"/ "
  inimsg[2]=inimsg[2]+"\n"+lst[2]+" mode= "+str(cnt)
  errcnt=cnt+errcnt
 inimsg[0]=inimsg[0].replace(lastmodename+", ","and "+lastmodename+" ")
 inimsg[1]=inimsg[1].replace(lastmodename+"/ ",lastmodename+" ")
 paths.write("\n\nIf tests are required to be excluded for all of the above regression modes, include the tests in\nReviewed tests exclusion file: ")
 pat=re.search("\w",lst[0])
 wloc=pat.start()
 if wloc==0:
  paths.write("./")
 paths.write(comex+"\n\nNote: Script does not report tests/testlists which have been reviewed for exclusion.\n\nRegards,\nNitya Joshi.")
 paths.close()
 path=open("plist","r")
 fileop.write(path.read())

 if errcnt==0:
  fileop.close()
  fileop=open("out_file","w")
  fileop.write("All testcases have been reviewed already.\n")
  path=open("plist","r")
  fileop.write(path.read())

 else:
  #print final counts of testcases to be reviewed to the beginning of email
  fileop.seek(0, 0)
  fileop.write(inimsg[0]+inimsg[1]+inimsg[2])
 path.close()
 fileop.close()
 os.remove("plist")
 shutil.rmtree("hqmv25_reg")
 return errcnt

try:    
 #erases previous results, if any, and runs the script.
 if (os.path.isdir("hqmv25_reg")):  #erase old simulation results, if any.
  shutil.rmtree("hqmv25_reg")
 os.system(simreg)
 
 errcnt=bodfunc(comexlst,inimsg,lst)

 if errcnt==0:
  os.system(mailrunner)
 else:
  os.system(mailer)

#if anything fails, code creators get a notification mail with error traceback to debug the code
except:
 scrpth=pathdir(os.path.realpath(__file__))
 mail=open("out_file","w")
 mail.seek(0,0)
 mail.write("Your testrun failed.\n\n")
 traceback.print_exc(file=mail)
 mail.close()
 os.system(errmailer)

#file cleanup post run, shifts output to output log folder with a time stamp, in order to avoid clutter in the directory where script would be running periodically
finally:
 scrpth=pathdir(os.path.realpath(__file__))
 if os.path.isdir(scrpth+"outlog"):
  os.rename("out_file",scrpth+"outlog/out_file_"+y)
 else:
  os.mkdir(scrpth+"outlog")
  os.rename("out_file",scrpth+"outlog/out_file_"+y)
 exit()
