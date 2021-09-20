# 
# SPDX-License-Identifier: MIT
#
# Written by Will Sheppard ( will@jjrsoftware.co.uk ), 2019
#
# As part of https://github.com/wsheppard/chelpers
#
# Basic makefile include - flexible for many purposes

-include vars.mk

SOURCES ?= $(wildcard *.c)
TARGET ?= $(word 1, $(SOURCES:%.c=%) )

_INCLUDES=$(foreach inc, $(INCLUDES), -I$(realpath -f $(inc)))
_LIBPATHS=$(foreach lib, $(LIBPATHS), -L$(realpath -f $(lib)))
_LIBS=$(foreach lib, $(LIBS), -l$(lib))
_SOURCES=$(foreach src, $(SOURCES), $(realpath -f $(src)))


OBJDIR := .objs
DEPDIR := .deps
OBJECTS = $(_SOURCES:%.c=$(OBJDIR)/%.o)
DEPFILES := $(_SOURCES:%.c=$(DEPDIR)/%.d)
CFLAGS += $(_INCLUDES) #-fPIC 
LDFLAGS += $(_LIBPATHS)
LDLIBS += $(_LIBS)
DEPFLAGS = -MT '$(OBJDIR)/$*.o' -MMD -MF $(DEPDIR)/$*.d
DEFAULT ?= binary
SUBDIRS = $(sort $(dir $(_SOURCES) ))
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

-include $(DEPFILES)

$(OBJDIR) $(DEPDIR):
	@echo Making dir [$@]
	@mkdir -p $@

$(OBJECTS): $(OBJDIR)/%.o: %.c $(MAKEFILE_LIST) | $(ALLDIRS)
	@echo Building object [$@] because [$?]	
	@echo Depfile is - [$*.d]
	$(CC) $(DEPFLAGS) $(CFLAGS) -c -o $@ $<

env:
	@echo TARGET: [$(TARGET)]
	@echo ==== INCLUDES ====
	@echo [$(INCLUDES)]
	@echo ==== SOURCES ====
	@echo [$(SOURCES)]
	@echo ==== OBJECTS ====
	@echo [$(OBJECTS)]
	@echo ==== DEPFILES ====
	@echo [$(DEPFILES)]
	@echo ==== ALLDIRS ====
	@echo [$(ALLDIRS)]

clean:
	@rm -irf $(OBJDIR) $(DEPDIR)

#Binary
$(OBJDIR)/$(TARGET): $(OBJECTS) 
	@echo Linking [$@]
	$(CC) -o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)

#Static
$(OBJDIR)/$(TARGET).a: $(OBJECTS)
	@echo Create static library [$@]
	@ar rcs $@ $(OBJECTS)

#Shared
$(OBJDIR)/lib$(TARGET).so: $(OBJECTS)
	@echo Create shared library [$@]
	$(CC) -shared -o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)


