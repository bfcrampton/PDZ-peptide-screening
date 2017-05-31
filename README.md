# Peptide Virtual Screening Manual

## Introduction
Blah

## Schrödinger Software Setup
Install fro [BLAH]

Preparation jobs are run through the **maestro** visual interface. They
could all just as easily be run through command line, however it is much
easier to run them visually––especially since the enumeration step requires
visual selection of attachment atoms anyway. The command line equivalents
for each job can be accessed in the job's logs via the **Job Monitor** utility
located in the **Jobs** tab in the upper right hand corner of the **maestro**
interface.

All jobs can be accessed from the **Tasks** tab in the upper right hand corner
of the **maestro** interface.



## Preparation for Peptide Screening
#### Protein Structure Preparation
1. Open up the crystal structure for the protein of interest (`4NMO` for CAL PDZ)
1. Run the **Protein Preparation Wizard** from the *Tasks* tab
1. Run the `Preprocess` job on the *Import and Process* tab with the desired
parameters––can be left with default values
1. Click `Analyze Workspace` on the *Review and Modify* tab
1. Click `View Problems...` and resolve any problems in the recommended
fashion. Usually these are issues with missing heavy atoms in the crystal
structure, but which are known to be in the amino acid sequence. The default
recommendation to fix each problem can generally be used.
1. Run `Optimize` on the *Refine* tab (or `Interactive Optimizer...` if
desired to view each recommended fix before proceeding). This will use basic
optimization to recommend flips in rotation of bonds for particular residues––
often *His*, *Asn*, and *Gln*.
1. If desired, a restrained energy minimization of the structure can also be
performed by running `Minimize` also on the *Refine* tab. This is limited
to a specified RMSD for each atom and was used for refining both CAL and GIPC.
1. A new structure will appear in the **Entry List** after each job. The most recent
(bottom of the list) structure can be renamed something useful, and the remaining
intermediary prep structures can be discarded.
1. If additional solvent / ions still persist in the prepared protein structure
which are undesired, they may be removed at this step by expanding the structure
in the **Structure Hierarchy** window (bottom left) and selecting solvents or other
ions.
1. Expand the *Protein* entry, in the **Structure Hierarchy** window,
and select the chain corresponding to the peptide ligand. Right click
this entry, click `Extract to new entry`, and name it something different. Now
you have a separate protein + solvent and peptide structures.
1. If the peptide docked in the crystal structure does not have *Lys* in the
position where acid-coupling is desired, you must first mutate that residue.
This can be achieved simply by selecting the residue, right clicking one of the
atoms, then hovering over `Mutate Residue` and selecting *Lys*. In
the case of CAL PDZ, `4NMO` has the docked sequence `RWPTSK(Ac)I` which already
has *Lys* at P(-1). For GIPC, the docked sequence `QSTYSEA` required mutation of
P(-1) from *Glu* to *Lys*.
1. The protein and peptide structures have now been prepared for receptor
grid generation and library enumeration.

#### Glide Receptor Grid Generation
1. Ensure just the protein and peptide are displayed in the workspace
1. Run the **Receptor Grid Generation** from the *Tasks* tab
1. When prompted, select an atom on the peptide ligand
1. Check the box for "Generate grid suitable for peptide docking"
1. The remaining parameters may be added or fine-tuned on the remaining tabs.
However, I have not changed any default values during my screens. I experimented
with adding H-bond and positional constraints, however I opted not to use them.
They overly constrained the system and added computational time to satisfy all
the constraints. Instead I used core-RMSD constraints as described in **Peptide
Screening** below.
1. Click `Run`. The output flies will be saved to your current working directory
in **maestro**.

#### Acid Library Preparation
1. Run **Reagent Preparation** from the *Tasks* tab
1. Open the input carboxylic acid library in `.mae`, `.sdf`, `.mol`, or `.smi`
format
1. Select the functional group to identify. Fpr carboxylic acid / *Lys*
coupling, I used the `Carboxylic_Acid_C_O` functional group. This essentially
removes the `-OH` group from the acid for attachment to the terminal amine group
on *Lys*.
1. The remaining parameters may be left in their default values or fine-tuned.
It is important that "Treatment of multiple occurrences" be set to "Produce a
structure only if all are equivalent" or "Ignore the molecule" in order to
maintain selective synthesizability.
1. Click `Run`. The output flies will be saved to your current working directory
in **maestro**.

#### Peptide-Acid Library Enumeration
1. Ensure just the peptide entry is displayed in the workspace
1. Run **Combinatorial Library Enumeration** from the *Tasks* tab
1. Select an atom on the peptide and click `OK` on the pop-up
1. Now select the terminal *Nitrogen* atom on the *Lys* residue which is to be
modified, then select one of the *Hydrogens* attached to it. A blue arrow
indicating the acid-attachment position should be displayed
1. In the file-browser pop-up, select the `.bld` file located within the output
folder from the **Reagent Preparation** run (in the working directory for
**maestro**).
1. The remaining parameters may be left in their default values. Make sure that
"Untangle and minimize structures" is checked. This will change the
conformation of the enumerated peptides––compared to the crystal structure––but
this does not matter since the docking constraints will realign the atoms to the
docked pose of the unmodified peptide.
1. Click `Run`. The output flies will be saved to your current working directory
in **maestro**.
1. Optionally, if you wish to dock the unmodified peptide (with and/or without
a *Lys* mutation), you can merge those structures into the output file. Import
the output file from the enumeration run into **maestro**. Next, duplicate the
additional peptides to be screened the same group (right click entry ––>
`Duplicate` ––> `Into Existing Group`). Then export the entire group of peptides
to be docked into a single file (select the group and right click ––> `Export`
––> `Structures` and enter a filename. This output file should be selected in
**Peptide Screening** section below.


## Google Cloud Engine and VPN Setup (optional)
This is really only needed for the screening part, preparation and library
enumeration jobs take reasonable amounts of time on a normal computer.

Run this job on a computer within a network which has access to the Schrödinger
license server. Replace `LICENSE_SERVER_URL` in the line below with the provider
server URL. Replace `username` with the user login for the remote GCE instance,
and `IP.ADDRESS` with the instance's external IP address.

`
ssh -o "StrictHostKeyChecking no" -nfNT -R 27008:LICENSE_SERVER_URL:27008
-R 53000:LICENSE_SERVER_URL:53000 username@IP.ADDRESS
`


## Peptide Screening 🔎 💊
#### Glide Docking
1. Ensure just the protein and unmodified peptide are displayed in the workspace
1. Run the **Ligand Docking** from the *Tasks* tab
1. Under the *Ligands* tab, select the output file from **Combinatorial
Library Enumeration** run.
1. Under the *Settings* tab, set "Precision" to `SP-Peptide`
1. Under the *Core* tab, check "Use core pattern comparison" and "Pick core-
containing molecule"
1. Select an atom on the unmodified peptide (should be almost exactly aligned
to the crystal structure, except if one of the residues had to be mutated to
*Lys*).
1. Select the "SMARTS pattern" radio-box
1. In the workspace, select the entire peptide minus all of the atoms on the
*Lys* residue which will have modifications on it. The selection has to be
connected––i.e. the alpha-carbon must be selected––but the entire "R" group
does not have to be. During my runs, I also included the hydrogens on the
backbone in this selection, but that is not required either. This pattern
represents the atoms which are fixed in space during the docking procedure and
can be modified as desired. The "Tolerance" I used during my screens was 0.5
Å.
1. The remaining parameters may be left in their default values or fine-tuned.
Constraints generated during **Receptor Grid Generation** may be selected under
the *Constraints* tab. Torsional constraints also may be applied, however with
the core-pattern comparison on most of the molecule's atoms, the torsional
angles are constrained by nature.
1. Clicking the gear drop down next to "Job name", then `Job Settings` brings up
a panel which allows enabling of distributed jobs.
1. Click `Run` to begin the job which can be monitored through the job-monitor
control panel on the top right of Maestro.

#### Prime MMGBSA Simulation
