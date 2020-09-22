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

all: $(DEFAULT)

binary: $(OBJDIR)/$(TARGET)
static: $(OBJDIR)/$(TARGET).a
shared: $(OBJDIR)/lib$(TARGET).so

$(OBJDIR)/$(TARGET): $(OBJECTS) 
	@echo Linking [$@]
	$(CC) -o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)

-include $(wildcard $(DEPDIR)/*.d)

$(OBJDIR) $(DEPDIR):
	@echo Making dir [$@]
	@mkdir -p $@

$(OBJECTS): $(OBJDIR)/%.o: %.c | $(OBJDIR) $(DEPDIR)
	@echo Building object [$@] because [$?]	
	$(CC) $(DEPFLAGS) $(CFLAGS) -c -o $@ $<

env:
	@echo [$(SOURCES)]
	@echo [$(OBJECTS)]
	@echo [$(DEPFILES)]

clean:
	@rm -irf $(OBJDIR) $(DEPDIR)

$(OBJDIR)/$(TARGET).a: $(OBJECTS)
	@echo Create static library [$@]
	@ar rcs $@ $(OBJECTS)

$(OBJDIR)/lib$(TARGET).so: $(OBJECTS)
	@echo Create shared library [$@]
	$(CC) -shared -o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)


