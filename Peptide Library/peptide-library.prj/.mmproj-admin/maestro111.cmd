######################################################
# Please do not edit this file.                      #
# Contents of this file will be overwritten when the #
# project is closed.                                 #
######################################################
prefer fitenhance=true fitenhancenear=2.64157 fitenhancefar=-2.64157
ribbon display=ribbonsonly
hbondcriteria display=true displayhbond=true displayhalogen=true displaysaltbridge=true displayaromatichbond=false distance=2.8 donorangle=120 acceptorangle=90 halogendistance=3.5 donorminimumangleasdonor=140 acceptorminimumangleasdonor=90 donorminimumangleasacceptor=120 acceptorminimumangleasacceptor=90 acceptormaximumangleasacceptor=170 saltbridgedistance=5 aromatichbonddistance_o=2.8 aromatichbonddistance_n=2.5 aromatichbonddonorminangle_o=90 aromatichbonddonorminangle_n=108 aromatichbonddonormaxangle_n=130 aromatichbondacceptorminangle=90
displayhbondsmode  mode=other
hbondset2 (protein_near_ligand) or (water)
hbondset1 (ligand) or (water)
contactcriteria display=true displaygood=false displaybad=true displayugly=true good=1.3 bad=0.89 ugly=0.75 excludehbond=true
displaycontactsmode  mode=other
contactset2 (protein_near_ligand) or (water)
contactset1 (ligand) or (water)
displaypiinteractions display=true displaystacking=true displaycation=true
displaypiinteractionsmode  mode=other
piinteractionset2 (protein_near_ligand) or (water)
piinteractionset1 (ligand) or (water)
clip front=16.7851 back=-6.56487 frontsurface=16.7851 backsurface=-6.56487 leftsurface=-20.0093 rightsurface=3.34063 leftslopesurface=0 rightslopesurface=0 frontselect=16.7851 backselect=-6.56487 boxoffset=0 objects=all
prefer annotationsvisible=true interactionsvisible=true measurementsvisible=true ribbonsvisible=true surfacesvisible=true
