
INCLUDES=
LIBPATHS=
LIBS=rt
CFLAGS= -pthread -g -ggdb

TARGET=intlist 
SOURCES=$(strip $(TARGET)).c
SOURCES+=iter.c tokenizer.c

_INCLUDES=$(foreach inc, $(INCLUDES), -I$(inc))
_LIBPATHS=$(foreach lib, $(LIBPATHS), -L$(lib))
_LIBS=$(foreach lib, $(LIBS), -l$(lib))

OBJDIR := .objs
DEPDIR := .deps
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d
OBJECTS = $(SOURCES:%.c=$(OBJDIR)/%.o)
DEPFILES := $(SOURCES:%.c=$(DEPDIR)/%.d)
CFLAGS += $(_INCLUDES)
LDFLAGS += $(_LIBPATHS)
LDLIBS += $(_LIBS)

$(TARGET): $(OBJECTS) 

$(OBJDIR) $(DEPDIR):
	@echo Making dir..
	mkdir -p $@

$(DEPDIR)/%.d:  | $(DEPDIR)
	@echo A deps?

$(OBJDIR)/%.o : %.c $(DEPDIR)/%.d  | $(OBJDIR) 
	@echo Building object...   	
	$(CC) $(CFLAGS) -c -o $@ $<





env:
	@echo [$(SOURCES)]
	@echo [$(OBJECTS)]
	@echo [$(DEPFILES)]

clean:
	@rm -irf $(OBJDIR)


