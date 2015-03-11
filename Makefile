#------------------------------------------------------------------------------
# IMPORTANT:
# This file MUST be called Makefile to be compatible with the Linux kernel
# build system
#------------------------------------------------------------------------------

#==============================================================================
ifeq ($(KERNELRELEASE),)   # i.e. if KERNELRELEASE not defined:
#==============================================================================
# Pass 1: Setup call to kernel build system
# This section is called outside the context of the kernel make system.
# Normal make targets are in this section.
$(info ----->Building drivers 1st pass)

.PHONY:	default clean

#------------------------------------------------------------------------------
# Default location and name of the cross compiler if not defined.
# Can specify without path if PATH has been defined to find the
# cross compiler.
ifndef CROSS_COMPILE
$(error CROSS_COMPILE is not defined)
endif

#------------------------------------------------------------------------------
# Location of built kernel.
# Default location and name of the built kernel if not defined.
ifndef KERNELDIR
$(error KERNELDIR is not defined)
endif

#------------------------------------------------------------------------------
# Architecture
ifndef ARM
ARCH=arm
$(info Assume ARCH=arm)
endif

#------------------------------------------------------------------------------
# Working Directory
PWD:= $(shell pwd)
CLNOBJS= *.o *~ core .depend .*.cmd *.mod.c .tmp_versions *.symvers *.order

# It will execute the kernel makefile for our targets. Essentially
# compiling our source in the context of the kernel.
# Note that ARCH and CROSS_COMPILE are explicitly defined.
# The sub-make will NOT import variables from this file.
# The make system will eventually call this file with KERNELRELEASE
# defined and the 2nd pass part will occurr.
default:
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNELDIR) M=$(PWD) modules
	cp testmodule.ko /tftpboot/.
#------------------------------------------------------------------------------
# Clean everything except final module object.
cleanobj:
	rm -vrf $(CLNOBJS)

#------------------------------------------------------------------------------
# Clean everything including final module object.
clean:
	rm -vrf $(CLNOBJS) *.ko

#==============================================================================
else
#==============================================================================
# Pass 2: Call from kernel build system
# This section of the makefile executed within context of the kernel make
# system. As such, it should look like the contents of an in-tree makefile.
# This is where the targets are specified.
$(info drivers 2nd pass $(MODOBJS))
testmodule-objs :=\
 dmatest.o
obj-m := testmodule.o

#cp hellomodule.ko /tftpboot/.
#==============================================================================
endif	# started with ifeq ($(KERNELRELEASE),)
#==============================================================================

