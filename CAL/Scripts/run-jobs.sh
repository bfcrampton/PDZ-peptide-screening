#!/usr/local/bin/bash

# Run Glide Docking job (must configure "glide-dock-run2.in" file using maestro)
/opt/schrodinger/suites2017-1/glide glide-dock-run2.in -OVERWRITE -NJOBS 183 -HOST localhost:1,researcher1:24,researcher2:24,researcher3:24,researcher4:24,researcher5:62,researcher6:24 -PROJ /Users/bryancrampton/Documents/Dartmouth/Research/Schrodinger/CALP.prj -DISP append -VIEWNAME glide_docking_gui.DockingPanel -TMPLAUNCHDIR -ATTACHED

# Run Prime MM-GBSA job (run job on one host in maestro to create project file first)
/opt/schrodinger/suites2017-1/prime_mmgbsa -OVERWRITE -prime_opt OPLS_VERSION=OPLS3 prime-mmgbsa-run2_pv.maegz -NJOBS 121 -HOST localhost:1,researcher1:24,researcher2:24,researcher3:24,researcher4:24,researcher6:24 -PROJ /Users/bryancrampton/Documents/Dartmouth/Research/Schrodinger/CALP.prj -DISP append -VIEWNAME prime_mmgbsa_gui.PrimeMmgbsaPanel -TMPLAUNCHDIR -ATTACHED
