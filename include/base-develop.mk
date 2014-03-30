SRC_DIR     =$(TOP)/source
TESTS_DIR   =$(TOP)/tests
INCLUDE_DIR =$(TOP)/include
LIB_DIR     =$(TOP)/source
MOD_DIR     =$(TOP)/source

# Set the required file extensions.
include $(INCLUDE_DIR)/extensions.mk

# Include the compiler-specific options.
include $(INCLUDE_DIR)/$(COMPILER).mk

FFLAGS += $I$(INCLUDE_DIR)

ifneq ($(USEMPI),YES)
  FC=$(F90)
else
  FC=$(MPIF90)
endif

ifeq ($(F90_HAS_CPP),YES)
%$(OBJ_EXT): %.F90
	$(FC) -c $(FFLAGS) $(CPPFLAGS) -o $@ $<
else
%$(OBJ_EXT):%.F90
	@$(CPP) $(CPPFLAGS) $(CPPFLAGS) $< > $*_cpp.F90
	$(FC) -c $(FFLAGS)  $*_cpp.F90 -o $@
	$(RM) $*_cpp.F90
endif

.PHONY: clean distclean

clean: local-base0-clean

local-base0-clean:
	-$(RM) *$(OBJ_EXT) *.mod *.i90 *~ *_cpp.F90 *.tmp

distclean: local-base0-distclean

local-base0-distclean: clean
	-$(RM) *$(LIB_EXT) *$(EXE_EXT) dependencies.inc
