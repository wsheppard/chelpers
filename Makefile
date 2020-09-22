
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
OBJECTS = $(SOURCES:%.c=$(OBJDIR)/%.o)
DEPFILES := $(SOURCES:%.c=$(DEPDIR)/%.d)
CFLAGS += $(_INCLUDES)
LDFLAGS += $(_LIBPATHS)
LDLIBS += $(_LIBS)

$(TARGET): $(OBJECTS) 
	@echo Linking...
	$(CC) -o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)

-include $(wildcard $(DEPDIR)/*.d)

$(OBJDIR) $(DEPDIR):
	@echo Making dir..
	mkdir -p $@

$(DEPFILES): $(DEPDIR)/%.d : %.c | $(DEPDIR)
	@echo dep $@ $*
	$(CC) -MT '$(OBJDIR)/$*.o' -MM -MF $@ $*.c

$(OBJECTS): $(OBJDIR)/%.o: %.c $(DEPDIR)/%.d | $(OBJDIR)
	@echo Hello
	@echo Building object [$@] from [$^]	
	$(CC) $(CFLAGS) -c -o $@ $<

env:
	@echo [$(SOURCES)]
	@echo [$(OBJECTS)]
	@echo [$(DEPFILES)]

clean:
	@rm -irf $(OBJDIR)




