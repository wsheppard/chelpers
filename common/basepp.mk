# 
# SPDX-License-Identifier: MIT
#
# Written by Will Sheppard ( will@jjrsoftware.co.uk ), 2019
#
# As part of https://github.com/wsheppard/chelpers
#
# Basic makefile include - flexible for many purposes

-include vars.mk

SOURCES ?=$(wildcard *.c)
SOURCESXX ?=$(wildcard *.cpp)

_INCLUDES=$(foreach inc, $(INCLUDES), -I$(realpath $(inc)))
_LIBPATHS=$(foreach lib, $(LIBPATHS), -L$(realpath $(lib)))
_LIBS=$(foreach lib, $(LIBS), -l$(lib))
_SOURCES=$(foreach src, $(SOURCES), $(realpath $(src)))
_SOURCESXX=$(foreach src, $(SOURCESXX), $(realpath $(src)))

SOURCESALL =$(_SOURCES) $(_SOURCESXX)
SOURCESBASE= $(basename $(SOURCESALL))
TARGET ?= $(word 1, $(SOURCESBASE) )

OBJDIR := .objs
DEPDIR := .deps
OBJECTS = $(_SOURCES:%.c=$(OBJDIR)/%.o)
OBJECTSXX = $(_SOURCESXX:%.cpp=$(OBJDIR)/%.o)
OBJECTSALL = $(OBJECTS) $(OBJECTSXX)

DEPFILES := $(_SOURCES:%.c=$(DEPDIR)/%.d)
DEPFILESXX := $(_SOURCESXX:%.cpp=$(DEPDIR)/%.d)
DEPFILESALL := $(DEPFILES) $(DEPFILESXX)

CFLAGS += $(_INCLUDES) #-fPIC 
LDFLAGS += $(_LIBPATHS)
LDLIBS += $(_LIBS)
DEFAULT ?= binary
SUBDIRS = $(sort $(dir $(SOURCESALL) ))
ALLDIRS = $(foreach dir, $(SUBDIRS), $(OBJDIR)/$(dir))
ALLDIRS += $(foreach dir, $(SUBDIRS), $(DEPDIR)/$(dir))

all: $(DEFAULT)

$(ALLDIRS):
	@echo Making dir [$@]
	@mkdir -p $@

binary: $(OBJDIR)/$(TARGET)
	ln -snf $< $(TARGET)
static: $(OBJDIR)/$(TARGET).a
shared: $(OBJDIR)/lib$(TARGET).so

-include $(DEPFILESALL)

$(OBJDIR) $(DEPDIR):
	@echo Making dir [$@]
	@mkdir -p $@

$(OBJECTS): $(OBJDIR)/%.o: %.c $(MAKEFILE_LIST) | $(ALLDIRS)
	@echo Building C object [$@] because [$?]	
	@echo Depfile is - [$*.d]
	$(CC) $(DEPFLAGS) $(CFLAGS) -c -o $@ $<

$(OBJECTSXX): $(OBJDIR)/%.o: %.cpp $(MAKEFILE_LIST) | $(ALLDIRS)
	@echo Building CXX object [$@] because [$?]	
	@echo Depfile is - [$*.d]
	$(CXX) $(DEPFLAGS) $(CXXFLAGS) -c -o $@ $<

env:
	@echo TARGET: [$(TARGET)]
	@echo ==== INCLUDES ====
	@echo [$(INCLUDES)]
	@echo ==== SOURCES ====
	@echo [$(SOURCESALL)]
	@echo ==== OBJECTS ====
	@echo [$(OBJECTSALL)]
	@echo ==== DEPFILES ====
	@echo [$(DEPFILESALL)]
	@echo ==== ALLDIRS ====
	@echo [$(ALLDIRS)]
	@echo ==== LIBS ====
	@echo [$(LIBS)]

clean:
	@rm -irf $(OBJDIR) $(DEPDIR)

#Binary
$(OBJDIR)/$(TARGET): $(OBJECTSALL) 
	@echo Linking [$@]
	$(CXX) -o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)

#Static
$(OBJDIR)/$(TARGET).a: $(OBJECTS)
	@echo Create static library [$@]
	@ar rcs $@ $(OBJECTS)

#Shared
$(OBJDIR)/lib$(TARGET).so: $(OBJECTS)
	@echo Create shared library [$@]
	$(CC) -shared -o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)


