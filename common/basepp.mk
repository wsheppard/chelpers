# 
# SPDX-License-Identifier: MIT
#
# Written by Will Sheppard ( will@jjrsoftware.co.uk ), 2019
#
# As part of https://github.com/wsheppard/chelpers
#
# Basic makefile include - flexible for many purposes

-include vars.mk

SOURCES ?=$(wildcard *.c) $(EXSRC)
SOURCESXX ?=$(wildcard *.cpp) $(EXSRCXX)

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
OBJECTSALL = $(OBJECTS) $(OBJECTSXX) $(EXOBJS)

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

#.SILENT:help
define listit
	$(foreach src,$(1),printf " * $(src)\n";)
endef

help env:
	@echo ==== COMPILER ====
	@echo "C:  $(CC) [$(shell which $(CC))]"
	@echo "Cxx:  $(CXX)"
	@echo
	@echo ==== TARGET ====
	@echo "  $(TARGET)"
	@echo
	@echo ==== INCLUDES ====
	@$(call listit, $(INCLUDES))
	@echo
	@echo ==== SOURCES ====
	@$(call listit, $(SOURCESALL))
	@echo
	@echo ==== OBJECTS ====
	@$(call listit, $(OBJECTSALL))
	@echo
	@echo ==== DEPFILES ====
	@$(call listit, $(DEPFILESALL))
	@echo
	@echo ==== ALLDIRS ====
	@$(call listit, $(ALLDIRS))
	@echo
	@echo ==== LIBS ====
	@$(call listit, $(LIBS))
	@echo
	@echo ==== LDFLAGS ====
	@$(call listit, $(LDFLAGS))
	@echo
	@echo ==== CFLAGS ====
	@$(call listit, $(CFLAGS))
	@echo

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


