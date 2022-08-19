cd ~/julia/src
make -j8 debug
gdb --args usr/bin/julia-debug --project ~/.julia/dev/SPIRV -e 'using SPIRV'
