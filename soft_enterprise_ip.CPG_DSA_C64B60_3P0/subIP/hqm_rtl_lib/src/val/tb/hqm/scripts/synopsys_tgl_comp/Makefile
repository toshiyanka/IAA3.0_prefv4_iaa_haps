CC	= g++
#CFLAGS	= -Wall -std=c++11
CFLAGS	= -Wall 
LD	= $(CC)
LDFLAGS	=
RM	= rm

NPI_INC    = $(VERDI_HOME)/share/NPI/inc
NPI_L1_INC = $(VERDI_HOME)/share/NPI/L1/C/inc

ifeq ($(MACHINE_BIT), 32)
	M32 =  -m32
else
	M32 =  
endif

#
# program setup
#
SHLIB_NAME = libCmpTwoVdbTgl
SRCS       = cmp_two_vdb_tgl.cpp 
OBJS       = ${SRCS:.cpp=.o}

#
# compiling and linking
#
.SUFFIXES: .o .cpp
.cpp.o :
	$(CC) $(CFLAGS) $(M32) -c -fPIC $< -I$(NPI_INC) -I$(NPI_L1_INC) 

all: $(OBJS)
	$(LD) $(M32) -shared -o $(SHLIB_NAME).so $(OBJS) 
	@echo make $(SHLIB_NAME).so successful...

clean:
	-$(RM) -f $(SHLIB_NAME).so $(OBJS)
