# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.9

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/lukasz/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/173.4548.31/bin/cmake/bin/cmake

# The command to remove a file.
RM = /home/lukasz/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/173.4548.31/bin/cmake/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/lukasz/CLionProjects/Figura

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/lukasz/CLionProjects/Figura/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/Figura.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Figura.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Figura.dir/flags.make

CMakeFiles/Figura.dir/main.c.o: CMakeFiles/Figura.dir/flags.make
CMakeFiles/Figura.dir/main.c.o: ../main.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/lukasz/CLionProjects/Figura/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/Figura.dir/main.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/Figura.dir/main.c.o   -c /home/lukasz/CLionProjects/Figura/main.c

CMakeFiles/Figura.dir/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/Figura.dir/main.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/lukasz/CLionProjects/Figura/main.c > CMakeFiles/Figura.dir/main.c.i

CMakeFiles/Figura.dir/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/Figura.dir/main.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/lukasz/CLionProjects/Figura/main.c -o CMakeFiles/Figura.dir/main.c.s

CMakeFiles/Figura.dir/main.c.o.requires:

.PHONY : CMakeFiles/Figura.dir/main.c.o.requires

CMakeFiles/Figura.dir/main.c.o.provides: CMakeFiles/Figura.dir/main.c.o.requires
	$(MAKE) -f CMakeFiles/Figura.dir/build.make CMakeFiles/Figura.dir/main.c.o.provides.build
.PHONY : CMakeFiles/Figura.dir/main.c.o.provides

CMakeFiles/Figura.dir/main.c.o.provides.build: CMakeFiles/Figura.dir/main.c.o


CMakeFiles/Figura.dir/figura.c.o: CMakeFiles/Figura.dir/flags.make
CMakeFiles/Figura.dir/figura.c.o: ../figura.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/lukasz/CLionProjects/Figura/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/Figura.dir/figura.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/Figura.dir/figura.c.o   -c /home/lukasz/CLionProjects/Figura/figura.c

CMakeFiles/Figura.dir/figura.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/Figura.dir/figura.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/lukasz/CLionProjects/Figura/figura.c > CMakeFiles/Figura.dir/figura.c.i

CMakeFiles/Figura.dir/figura.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/Figura.dir/figura.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/lukasz/CLionProjects/Figura/figura.c -o CMakeFiles/Figura.dir/figura.c.s

CMakeFiles/Figura.dir/figura.c.o.requires:

.PHONY : CMakeFiles/Figura.dir/figura.c.o.requires

CMakeFiles/Figura.dir/figura.c.o.provides: CMakeFiles/Figura.dir/figura.c.o.requires
	$(MAKE) -f CMakeFiles/Figura.dir/build.make CMakeFiles/Figura.dir/figura.c.o.provides.build
.PHONY : CMakeFiles/Figura.dir/figura.c.o.provides

CMakeFiles/Figura.dir/figura.c.o.provides.build: CMakeFiles/Figura.dir/figura.c.o


# Object files for target Figura
Figura_OBJECTS = \
"CMakeFiles/Figura.dir/main.c.o" \
"CMakeFiles/Figura.dir/figura.c.o"

# External object files for target Figura
Figura_EXTERNAL_OBJECTS =

Figura: CMakeFiles/Figura.dir/main.c.o
Figura: CMakeFiles/Figura.dir/figura.c.o
Figura: CMakeFiles/Figura.dir/build.make
Figura: CMakeFiles/Figura.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/lukasz/CLionProjects/Figura/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C executable Figura"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Figura.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Figura.dir/build: Figura

.PHONY : CMakeFiles/Figura.dir/build

CMakeFiles/Figura.dir/requires: CMakeFiles/Figura.dir/main.c.o.requires
CMakeFiles/Figura.dir/requires: CMakeFiles/Figura.dir/figura.c.o.requires

.PHONY : CMakeFiles/Figura.dir/requires

CMakeFiles/Figura.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Figura.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Figura.dir/clean

CMakeFiles/Figura.dir/depend:
	cd /home/lukasz/CLionProjects/Figura/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/lukasz/CLionProjects/Figura /home/lukasz/CLionProjects/Figura /home/lukasz/CLionProjects/Figura/cmake-build-debug /home/lukasz/CLionProjects/Figura/cmake-build-debug /home/lukasz/CLionProjects/Figura/cmake-build-debug/CMakeFiles/Figura.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Figura.dir/depend

