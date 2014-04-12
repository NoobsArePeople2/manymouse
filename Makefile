#****************************************************************************
#
# Makefile for TinyXml test.
# Lee Thomason
# www.grinninglizard.com
#
# This is a GNU make (gmake) makefile
#****************************************************************************

# DEBUG can be set to YES to include debugging info, or NO otherwise
DEBUG          := YES

# PROFILE can be set to YES to include profiling info, or NO otherwise
PROFILE        := NO

#****************************************************************************

# CC     := gcc
# CXX    := g++
# LD     := g++
CC     := clang
CXX    := clang++
LD     := clang++
AR     := ar rc
RANLIB := ranlib
ARCH   := -arch i386
C_LIB  := -stdlib=libc++

DEBUG_CFLAGS     := -Wall -Wno-format -g -DDEBUG ${ARCH} ${C_LIB}
RELEASE_CFLAGS   := -Wall -Wno-unknown-pragmas -Wno-format -O3 ${ARCH} ${C_LIB}

LIBS         :=

DEBUG_CXXFLAGS   := ${DEBUG_CFLAGS}
RELEASE_CXXFLAGS := ${RELEASE_CFLAGS}

DEBUG_LDFLAGS    := -g ${ARCH} ${C_LIB}
RELEASE_LDFLAGS  := ${ARCH} ${C_LIB}

ifeq (YES, ${DEBUG})
	 CFLAGS       := ${DEBUG_CFLAGS}
	 CXXFLAGS     := ${DEBUG_CXXFLAGS}
	 LDFLAGS      := ${DEBUG_LDFLAGS}
else
	 CFLAGS       := ${RELEASE_CFLAGS}
	 CXXFLAGS     := ${RELEASE_CXXFLAGS}
	 LDFLAGS      := ${RELEASE_LDFLAGS}
endif

ifeq (YES, ${PROFILE})
	 CFLAGS   := ${CFLAGS} -pg -O3
	 CXXFLAGS := ${CXXFLAGS} -pg -O3
	 LDFLAGS  := ${LDFLAGS} -pg
endif

LDFLAGS += -framework Carbon -framework IOKit

#****************************************************************************
# Preprocessor directives
#****************************************************************************

DEFS :=

#****************************************************************************
# Include paths
#****************************************************************************

#INCS := -I/usr/include/g++-2 -I/usr/local/include
INCS :=


#****************************************************************************
# Makefile code common to all platforms
#****************************************************************************

CFLAGS   := ${CFLAGS}   ${DEFS}
CXXFLAGS := ${CXXFLAGS} ${DEFS}

#****************************************************************************
# Targets of the build
#****************************************************************************

OUTPUT := manymouse

all: ${OUTPUT}


#****************************************************************************
# Source files
#****************************************************************************

SRCS := linux_evdev.c macosx_hidmanager.c macosx_hidutilities.c manymouse.c windows_wminput.c x11_xinput2.c

# Add on the sources for libraries
SRCS := ${SRCS}

OBJS := $(addsuffix .o,$(basename ${SRCS}))

#****************************************************************************
# Output
#****************************************************************************

${OUTPUT}: ${OBJS}
		${LD} -o $@ ${LDFLAGS} ${OBJS} ${LIBS} ${EXTRA_LIBS}

#****************************************************************************
# common rules
#****************************************************************************

# Rules for compiling source files to object files
%.o : %.cpp
		${CXX} -c ${CXXFLAGS} ${INCS} $< -o $@

%.o : %.c
		${CC} -c ${CFLAGS} ${INCS} $< -o $@

dist:
		bash makedistlinux

clean:
		-rm -f core ${OBJS} ${OUTPUT}

depend:
		#makedepend ${INCS} ${SRCS}

archive:
		ar rcs libmanymouse.a *.o

# linux_evdev.o: linux_evdev.c x11_xinput2.c
# macosx.o: macosx_hidmanager.c macosx_hidutilities.c
# manymouse.o: manymouse.h manymouse.c
# windows.o: windows_wminput.c
