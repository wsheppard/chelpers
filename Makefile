
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
DEPFLAGS = -MT '$(OBJDIR)/$*.o' -MMD -MF $(DEPDIR)/$*.d

$(TARGET): $(OBJECTS) 
	@echo Linking...
	$(CC) -o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)

-include $(wildcard $(DEPDIR)/*.d)

$(OBJDIR) $(DEPDIR):
	@echo Making dir..
	mkdir -p $@

$(OBJECTS): $(OBJDIR)/%.o: %.c | $(OBJDIR) $(DEPDIR)
	@echo Hello
	@echo Building object [$@] from [$^]	
	$(CC) $(DEPFLAGS) $(CFLAGS) -c -o $@ $<

env:
	@echo [$(SOURCES)]
	@echo [$(OBJECTS)]
	@echo [$(DEPFILES)]

clean:
	@rm -irf $(OBJDIR)




