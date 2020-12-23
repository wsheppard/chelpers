# 
# SPDX-License-Identifier: MIT
#
# Written by Will Sheppard ( will@jjrsoftware.co.uk ), 2019
#
# Basic makefile include - flexible for many purposes

-include vars.mk

_INCLUDES=$(foreach inc, $(INCLUDES), -I$(shell readlink -f $(inc)))
_LIBPATHS=$(foreach lib, $(LIBPATHS), -L$(shell readlink -f $(lib)))
_LIBS=$(foreach lib, $(LIBS), -l$(lib))

OBJDIR := .objs
DEPDIR := .deps
OBJECTS = $(SOURCES:%.c=$(OBJDIR)/%.o)
DEPFILES := $(SOURCES:%.c=$(DEPDIR)/%.d)
CFLAGS += $(_INCLUDES) -fPIC 
LDFLAGS += $(_LIBPATHS)
LDLIBS += $(_LIBS)
DEPFLAGS = -MT '$(OBJDIR)/$*.o' -MMD -MF $(DEPDIR)/$*.d
DEFAULT ?= binary
SUBDIRS = $(sort $(dir $(SOURCES) ))
ALLDIRS = $(foreach dir, $(SUBDIRS), $(OBJDIR)/$(dir))
ALLDIRS += $(foreach dir, $(SUBDIRS), $(DEPDIR)/$(dir))

all: $(DEFAULT)

$(ALLDIRS):
	@echo Making dir [$@]
	@mkdir -p $@

binary: $(OBJDIR)/$(TARGET)
static: $(OBJDIR)/$(TARGET).a
shared: $(OBJDIR)/lib$(TARGET).so

-include $(DEPFILES)

$(OBJDIR) $(DEPDIR):
	@echo Making dir [$@]
	@mkdir -p $@

$(OBJECTS): $(OBJDIR)/%.o: %.c Makefile | $(ALLDIRS)
	@echo Building object [$@] because [$?]	
	@echo Depfile is - [$*.d]
	$(CC) $(DEPFLAGS) $(CFLAGS) -c -o $@ $<

env:
	@echo [$(SOURCES)]
	@echo [$(OBJECTS)]
	@echo [$(DEPFILES)]
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


