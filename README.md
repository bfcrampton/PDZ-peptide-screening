# Peptide Virtual Screening Overview

## Introduction
This is a guide and summary of the peptide virtual screening work I (Bryan
Crampton 17') completed, with direction from Professor Spaller, from October 2016 to
June 2017.

#### Previous Work
The work is an extension of the that done in
[Chemically Modified Peptide Scaffolds Target the CFTR-Associated Ligand PDZ Domain](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0103650).
Their study demonstrated the potential of developing novel CAL-PDZ peptide
inhibitors by coupling organic acids to a Lysine amino acid inserted into
varying positions of the
[iCAL36](http://onlinelibrary.wiley.com/doi/10.1002/anie.201005575/full) peptide
sequence: ANSRWPTSII. It was determined that the P(-1) residue––counting from
the right, starting at P(0)––tolerated these modifications best. In fact, every
acid modification coupled to Lysine at the P(-1) position demonstrated a greater
binding affinity to CAL-PDZ than iCAL36 itself. These peptides were
ANSRWPTS[Ac-K]I, ANSRWPTS[BB-K]I, ANSRWPTS[FB-K]I, and ANSRWPTS[Tfa-K]I.

#### My Project
Based on this proof of concept, my project aimed to take the screening process
for these modified peptides *in silico* due to the time consuming and costly
nature of synthesizing and purifying peptides, followed by running binding
assays with CAL PDZ (which must also be expressed!). Additionally, these are
not standard peptides and require a
modified synthesis procedure. The idea was to narrow down
a library of roughly 700 organic acids––which was pre-filtered for
synthesizability––to a few top hits which could be physically made and tested
in the lab. I completed the screening process in early April, and synthesized
and purified 5 of the screened compounds by June. These have not yet been used
for a binding assay, but are scheduled to be in the future.  

#### Software Choice
###### Schrödinger [Small-Molecule Drug Discovery Suite](https://www.schrodinger.com/suites/small-molecule-drug-discovery-suite)
I ended up using the Schrödinger software due to it's comprehensive capability
to manipulate peptides, run docking and solvation simulation models, and easily
execute jobs concurrently on a computer cluster. The process for Glide SP-PEP
docking, followed by Prime MM-GBSA simulation calculations was taken from
[Improved Docking of Polypeptides with Glide](http://pubs.acs.org/doi/abs/10.1021/ci400128m)
which demonstrated its accuracy compared to competitors––58% success rate with
docked poses having a RMSD ≤ 2.0 Å compared to the crystal structure.
This software is commercial and requires a license to use. During my work, I had
near unlimited access to jobs through a trial that has expired, however the
[Norris Cotten Cancer](http://cancer.dartmouth.edu/researchers.html) recently
purchased a limited license.

###### Rosetta [FlexPepDock](https://www.rosettacommons.org/docs/latest/application_documentation/docking/flex-pep-dock)
The primary other software considered for use
was [Rosetta's](https://www.rosettacommons.org) peptide docking implementation
–– FlexPepDock, an open source alternative. It excels at determining correct
docked poses of peptides by sequence. In our case, however, we know the general
crystal structure of the iCAL36 and its derivatives. Their bound poses vary
little between each other, and primarily in the region of modification.
Essentially, we want to keep most of the peptide backbone
reasonably fixed in space and allow the varied region to move freely in space to
more fully explore the effects of the modification. This is not FlexPepDock's
strength, but can be easily achieved through Schödinger's Glide and Prime.
Whether or not this would have been possible to achieve with FlexPepDock was not
investigated. Assumedly it could be done with enough work, given that the
software is open source. Another down-side , as shown in the
[Improved Docking of Polypeptides with Glide](http://pubs.acs.org/doi/abs/10.1021/ci400128m)
paper, Rosetta's docking process requires approximately 100 times more
computational power than Schrödinger's. Given that this power is expensive––and
my project short––I opted not to use their software.

## Software Setup
#### Schrödinger Installation –– [Full Guide](https://www.schrodinger.com/sites/default/files/s3/mkt/Documentation/2017-1/docs/Documentation.htm#quick_reference/mac_quick_install.htm%3FTocPath%3DInstallation%2520and%2520Jobs%7C_____2)

Create an account with [Schrödinger](https://www.schrodinger.com) and download
the Small-Molecule-Drug-Discovery-Suite for your OS
[here](https://www.schrodinger.com/downloads/releases). Follow the installation
instructions included in the download. Generally it just requires run
`./INSTALL` from the unarchived download folder. It is assumed that this is
being run on a unix-based OS (macOS or linux), but everything should be
relatively similar on Windows. Wherever you decide to install the software
(default is `~/schrodinger/suites2017-1/`), please add it to your `~/.bashrc`
or `~/.zshrc` so that `$SCHRODINGER` can be accessed anywhere in terminal. This
can be acheived by appending the following line (or replace `$SCHRODINGER`
with your installation path every where going forward):
```bash
export SCHRODINGER="/opt/schrodinger/suites2017-1/"
```

#### Execution Method
##### Maestro
In this process, it will be explained how to run all jobs via the visual
interface. This can be accessed via your Applications folder (macOS) or by
running `$SCHRODINGER/Maestro` in terminal.
[Maestro](https://www.schrodinger.com/Maestro) is a highly customizable
molecular visualization software. A reference guide to its use can be found
[here](http://content.schrodinger.com/Training+Material/Maestro11/Maestro+11+Beta+Reference+Guide.pdf).
Jobs from all of the various pieces of software included in the Schrödinger
suite can be executed via the **Tasks** dropdown menu in the upper-right hand
corner of the window. These jobs' statuses can be monitored by clicking the
"Monitor" button on the **Jobs** dropdown menu, again in the upper-right hand
corner. This opens the **Job Monitor** utility where progress on a job's
completion is updated, and logs files can be viewed. Multiple structures can be
saved within a single project file (included in this repository), and are shown
in the **Workspace Navigator**. One or more structures can be shown at once by
Shift/Command clicking on the circle in the "In" column. Selecting entries
in the **Workspace Navigator** does not display the structures, but can be used
as input into jobs.

##### Bash Execution
All jobs that are run can easily be executed via command line, however it is
much easier to run them visually––especially since the library enumeration step
requires visual selection of attachment atoms anyway.
- **Note**: The command line equivalents for each job can be accessed in the job's
log file within the **Job Monitor** utility.

##### KNIME Execution
I began setting up a workflow using [KNIME](https://www.knime.org) which is an
open source data-mining and automation tool included with the Schrödinger
software suite. It comes with custom Schrödinger "nodes" built in which allow
sequential execution of jobs and feeding data between processes. In theory, it
works great, and allowed me to automate many of the pre-processing steps.
However, many of its the nodes were limiting in that they did not include all
parameters for each job execution. For example, the *SP-PEP* mode for Glide
docking was not a specifiable option––which is the optimal way to dock peptides.
You can create custom nodes with python or bash commands, so I'm sure it would
be possible to remedy many of these problems, however I never had the time to
come back and do this. I ran into bigger problems with getting the Google
Compute Engine setup with VPN connection to the Schrödinger licensing server
which ended up taking the majority of my time to solve. Regardless, some
steps are easier/necessary to complete visually with Maestro and it does not
take too long to start the jobs manually compared to automatically with KNIME
automation.


## Pre-Processing for Peptide Screening
#### Protein Structure Preparation
1. Open up the crystal structure for the protein of interest (`4NMO` for CAL)
1. Run the **Protein Preparation Wizard** from the *Tasks* drop down menu
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
atoms, then hovering over `Mutate Residue` and selecting *Lys*.
  - In the case of CAL PDZ, `4NMO` has the docked sequence `RWPTSK(Ac)I` which
  already has *Lys* at P(-1). For GIPC, the docked sequence `QSTYSEA` required
  mutation of P(-1) from *Glu* to *Lys*.
12. The protein and peptide structures have now been prepared for receptor
grid generation and library enumeration.

#### Glide Receptor Grid Generation
1. Ensure just the protein and peptide are displayed in the workspace
1. Run the **Receptor Grid Generation** from the *Tasks* drop down menu
1. When prompted, select an atom on the peptide ligand
1. Check the box for "Generate grid suitable for peptide docking"
1. The remaining parameters may be added or fine-tuned on the remaining tabs.
However, I have not changed any default values during my screens. I experimented
with adding H-bond and positional constraints, however I opted not to use them.
They overly constrained the system and added computational time to satisfy all
of them. Instead I used core-RMSD constraints, described in **Peptide
Screening** below.
1. Click `Run`. The output files will be saved to your current working directory
in **Maestro**.

#### Acid Library Preparation
1. Run **Reagent Preparation** from the *Tasks* drop down menu
1. Open the input carboxylic acid library in `.mae`, `.sdf`, `.mol`, or `.smi`
format
1. Select the functional group to identify. For carboxylic acid / *Lys*
coupling, I used the `Carboxylic_Acid_C_O` functional group. This essentially
removes the `-OH` group from the acid for attachment to the terminal amine group
on the *Lys* residue.
1. The remaining parameters may be left in their default values or fine-tuned.
It is important that "Treatment of multiple occurrences" be set to "Produce a
structure only if all are equivalent" or "Ignore the molecule" in order to
maintain selective synthesizability.
1. Click `Run`. The output flies will be saved to your current working directory
in **Maestro**.

#### Peptide-Acid Library Enumeration
1. Ensure just the peptide entry is displayed in the workspace
1. Run **Combinatorial Library Enumeration** from the *Tasks* drop down menu
1. Select an atom on the peptide and click `OK` on the pop-up
1. Now select the terminal *Nitrogen* atom on the *Lys* residue which is to be
modified, then select one of the *Hydrogens* attached to it. A blue arrow
indicating the acid-attachment position should be displayed
1. In the file-browser pop-up, select the `.bld` file located within the output
folder from the **Reagent Preparation** run (in the working directory for
**Maestro**).
1. The remaining parameters may be left in their default values. Make sure that
"Untangle and minimize structures" is checked. This will change the
conformation of the enumerated peptides––compared to the crystal structure––but
this does not matter since the docking constraints will realign the atoms to the
docked pose of the unmodified peptide.
1. Click `Run`. The output flies will be saved to your current working directory
in **Maestro**.
1. Optionally, if you wish to dock the unmodified peptide (with and/or without
the *Lys* mutation), you can merge those structures into the output file. Import
the output file from the enumeration run into **Maestro**. Then duplicate the
additional peptides to be screened the same group (select entries ––> right
click entry ––> `Duplicate` ––> `Into Existing Group`). Then export the entire
group of peptides to be docked into a single file (select the group and right
click ––> `Export` ––> `Structures` and enter a filename. This output file
should be selected in **Peptide Screening** section below instead of the output
from enumeration job.


## Google Cloud Engine and SSH Tunneling Setup (optional)
### Usage
Use of Google Cloud––specifically Google Compute Engine (GCE) is really only
necessary for the screening part––Glide docking and Prime MMGBSA simulation.
Preparation and library enumeration jobs take reasonable amounts of time on a
normal computer.

### Creation and Setup Automation
Under the `Google Cloud` directory, there are various scripts to automate the
creation and setup of a number of GCE instances. They are all rather simple,
and simply demonstrate the ability to automate these task with relative ease.
They utilize basic bash commands as well as the gcloud sdk, which must be
[installed](https://cloud.google.com/sdk/downloads). The
[gcloud reference](https://cloud.google.com/sdk/gcloud/reference/)
provides detailed explanations of all parameters for these commands. The scripts
are documented and can be investigated as needed. The general protocol to run
these scripts is outlined below. It is assumed all commands are executed within
the `Google Cloud` directory.

#### Requirements
1. A local installation of the [Schrödinger Software Setup](Schrödinger-Software-Setup)
1. A local installation of the [gcloud SDK](https://cloud.google.com/sdk/downloads)
initialized with an active Google Cloud account (run `gloud init` and sign in).
The Google Cloud account should have Firewall rules allowing unlimited access
on ports `5901`, `27008`, and `53000` (IP ranges: 0.0.0.0/0) tcp and udp.
1. A vnc viewer, such as [Real VNC](https://www.realvnc.com/download/viewer/)
1. A custom `researcher-5-9-17` image on your Google Cloud Console. This was
the custom OS image I created and should be included in the Google Cloud account
I passed off to Professor Spaller. Details on this process of making custom
images can be found
[here](https://cloud.google.com/compute/docs/images/create-delete-deprecate-private-images)
or within `image-disk.sh`. This image can be further customized. Currently, it
has installed:
  - Based on [Ubuntu 16.04](http://releases.ubuntu.com/16.04/)
  - The newest version of Schrödinger suite at the time of writing (2017-1)
  - [vncserver](https://linux.die.net/man/1/vncserver)
  - [Chrome Remote Desktop](https://chrome.google.com/webstore/detail/chrome-remote-desktop/gbchcmhmhahfdphkhkmpfmihenigjmpp?hl=en)
  - python 2.7
  - [gcloud sdk](https://cloud.google.com/sdk/)
  - Various other dependencies for above software

#### Instance Creation
1. Customize the `zones`, `cpu_counts`, and `memory_counts` variables in
`create-instances.sh`. These were maxed out to the quotas at the time (for my
GCE account). CPU quotas are described
[here](https://cloud.google.com/compute/quotas)
and custom machine types (maximum memory per CPU ratio) is outlined [here](https://cloud.google.com/compute/docs/instances/creating-instance-with-custom-machine-type).
  - **Note**: I have always used the maximum amount of memory per CPU that is
  possible. This is because the Glide docking jobs are extremely memory
  intensive. I additionally create virtual swap-memory––preventing crashing when
  the instances run out of memory (which happens often). That being said, the
  Prime MMGBSA simulations are not very memory intensive and it would probably
  be cheaper to use lower-memory instances for these jobs.
2. Execute `./create-instances.sh` and watch logs to ensure no errors occur
3. Verify the instances have been created on
[Google Cloud Console](https://console.cloud.google.com/compute/instances)

#### Instance Setup
1. Ensure the machine you are currently on has access to the network in which
the Schödinger license server is located (either physical or via VPN).
1. Customize the `zones` variable in `setup-instances.sh` to match
`create-instances.sh`. Replace `LICENSE_SERVER_URL` with the correct license
server URL for the Schrödinger license. If you simply have a license file
(not a hosted server which requires VPN access) then the line setting up these
tunnels can be removed.
1. Execute `./setup-instances.sh` and watch logs to ensure no errors occur
  - **Note**: This script does two things. First, it creates a **local•** SSH
  tunnel on port `590X` (where X is researcherX) for VNC desktop access. This
  routes all local traffic from the current computer on `localhost:5901` to
  the remote instance's port `5901` (designated for VNC). Second, it creates two
  **remote** SSH tunnels on ports `27008` and `53000`. This routes all traffic
  in and out of the instance (bound for `LICENSE_SERVER_URL`) **through** the
  current computer to access the license server. This is  the crux of what
  allows these remote cloud instances to access the license server without a
  VPN on each one of them.
4. Verify success by using Real VNC Viewer pointed to `localhost::5901` (not
sure why the two colons but its required). It may warn you that the connection
is not encrypted, but don't worry about that or any other errors that pop up.
You should have full access to Desktop of the remote instance at this point.
5. Through the the VNC Viewer, right click on the desktop and click open new
terminal. In the window, run `~/schrodinger2017-1/utilities/configure` and a
configuration window should open. Input the necessary information to access
the Schrödinger license (either enter the license text or the server info).
6. Verify the success of the license configuration by running
`~/schrodinger2017-1/maestro`. If the main window shows up, then the license
settings, local VPN, and SSH tunnels are working correctly.  

#### Schrödinger Host File Setup
This should be executed on whichever computer you wish to be the host for all
the jobs. If you need access to a particular local network for license access
(i.e. DHMC) it may be easiest to use a computer physically connected to the
network to host everything. However, you can also run the setup (with SSH
tunneling for license access) from that computer and still execute the jobs from
a different one. For processing large libraries, I find it is preferable to
execute the distributed job from one of the Google Cloud Instance machines,
rather than a local one. This is because those instances have extremely fast
internet connections (I have seen up to 100 MiB/sec) which is incomparable to
even the fastest local connections (generally less than 1 MiB/sec). This can
significantly slow the time it takes to start all of the jobs––especially for
Prime MMGBSA which processes many more structures than in the initial
library (Glide generates ~40 docked poses per ligand each of which must be
simulated with MMGBSA). When run from a GCE instance, 528 jobs could be started
across the distributed system in under 20 minutes; this took hours to start from
my local machine. During this job startup time we pay for usage of Google Cloud,
and thus want to minimize how long it takes.

1. Customize the `zones` and `cpu_counts` variables in `get-hosts.sh` to match
`create-instances.sh`
1. Execute `./get-host.sh` and watch the logs to ensure no errors occur
1. The script will output all of the remote instances specified in the format
which Schrödinger reads. This should be copy and pasted into the hosts file
located in `$SCHRODINGER/schrodinger.hosts`. If you are running the jobs from
one of the GCE instances, you should replace whichever "researcher" you are on's
`name` and `host` to `localhost`. If you are running it from a machine not
listed (i.e. a physical-access computer), then you should leave the default
entry on the top of the file which should look something like:
```bash
# Local Machine
name: localhost
host: localhost
processors: 4
tmpdir: /Users/bryancrampton/scratch
```



## Peptide Screening 🔎 💊
#### Glide Docking
1. Transfer all relevant project and input structure files to the host computer
to run the jobs from
1. Ensure just the protein and unmodified peptide are displayed in the workspace
1. Run **Ligand Docking** from the *Tasks* drop down menu
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
the *Constraints* tab if desired. Torsional constraints also may be applied,
however with the core-pattern comparison on most of the peptide's atoms, the
torsional angles are inherently constrained.
1. Clicking the gear drop down next to "Job name", then `Job Settings` brings up
a panel which allows enabling of distributed jobs. Having completed the above
Google Cloud Setup Select all the available remote machines which you wish to
run the jobs on.
1. Click `Run` to begin the job which can be monitored through the job-monitor
control panel on the top right of Maestro.
1. Upon completion you can turn off the instances in the GCE console if you are
using them. However, this will leave the disks intact which will cost a modest
amount (a bit more since they are SSD). Instead, you can delete them completely
since the creation process is automated in a script. **However**, ensure that
you copy the data off the computer first. This can easily be accomlished
with the `gsutil cp` command which will copy files to a Google Storage bucket.
The documentation is available
[here](https://cloud.google.com/storage/docs/gsutil/commands/cp).

#### Prime MMGBSA Simulation
1. Transfer all relevant project and input structure files to the host computer
to run the jobs from
1. Run **Prime MM-GBSA** from *Tasks* drop down menu
1. Click "Browse" under "Take complexes from a Maestro Pose Viewer file" and
select the output file from the glide docking job. This is located within the
job output folder and is called `JOBNAME_pv.maegz`
1. The remaining parameters were left in their default values, as specified in
[Improved Docking of Polypeptides with Glide](http://pubs.acs.org/doi/abs/10.1021/ci400128m),
but they can be customized if desired.
1. Clicking the gear drop down next to "Job name", then `Job Settings` brings up
a panel which allows enabling of distributed jobs. Having completed the above
Google Cloud Setup Select all the available remote machines which you wish to
run the jobs on.
1. Click `Run` to begin the job which can be monitored through the job-monitor
control panel on the top right of Maestro.
1. Upon completion you can turn off the instances in the GCE console if you are
using them. However, this will leave the disks intact which will cost a modest
amount (a bit more since they are SSD). Instead, you can delete them completely
since the creation process is automated in a script. **However**, ensure that
you copy the data off the computer first. This can easily be accomlished
with the `gsutil cp` command which will copy files to a Google Storage bucket.
The documentation is available
[here](https://cloud.google.com/storage/docs/gsutil/commands/cp).

#### Data Processing
The easiest way to process the data is to open the Prime MMGBSA output
structure file into maestro and export a CSV file with the desired data fields.
You may wish to do this on one of the GCE instances if you ran it from one
because opening very large numbers of structures can take some time (25,000+ in
my case).
1. Open the Prime MMGBSA output file. This file is located within the job output
folder and is named `JOBNAME-out.maegz`.
1. After the import completes, select the group of structures you just imported.
Expand the group, and right click on one of the entries ––> `Export` ––>
`Spreadsheet`
1. Make sure the "Entries" drop down menu shows `Selected`
1. For "Properties", you can either leave all (and have a bunch of blank or
irrelevant columns), or pick `Selected` and pick which output columns you want.
1. I usually include the following properties:
```bash
glide emodel
glide gscore
MMGBSA dG Bind
Title
Entry Name
MMGBSA dG Bind Coulomb
MMGBSA dG Bind Covalent
MMGBSA dG Bind Hbond
MMGBSA dG Bind Lipo
MMGBSA dG Bind Packing
MMGBSA dG Bind SelfCont
MMGBSA dG Bind Solv GB
MMGBSA dG Bind vdW
MMGBSA dG Bind(NS)
MMGBSA dG Bind(NS) Coulomb
MMGBSA dG Bind(NS) Covalent
MMGBSA dG Bind(NS) Hbond
MMGBSA dG Bind(NS) Lipo
MMGBSA dG Bind(NS) Packing
MMGBSA dG Bind(NS) Solv GB
MMGBSA dG Bind(NS) vdW
```
More details on the meaning and calculation methods for these output fields
can be found for [Glide](https://www.schrodinger.com/kb/1027) and
[Prime MMGBSA](https://www.schrodinger.com/kb/1875). I focused primarily on the
`glide gscore` and `MMGBSA dG Bind` variables and sorted by the latter.
1. Additionally, we need to export all of the 2D structure images for each
carboxylic acid from the original library. Import the original acid library
structure file if it's not already in your project.
1. Select all the acid entries in the workspace
1. Select the `Window` menu item ––> `2D Viewer`.
1. Shift-select all the acids then click `Export` ––> `Export to PNG`
1. Create a folder to hold all the images and save it.
1. These can then be upload to Google Cloud Storage, and shared publicly via
the Google Cloud Console. You could also host them using github as they are now,
if this repository remains public.
1. I loaded the spreadsheet into a Google Drive sheet (excel doesn't support
images in cells). Using the Entry Name field you can convert that to an acid
"ID" number which should correspond to the number attached to the exported
structure images.
1. Once the images are loaded into a table with each acid, VLOOKUP and other
similar "excel" functions can be utilized to manipulate the data.
1. Additionally, the acid structures can be exported in
[SMILES (`.smi`) format](https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system),
which stands for Simplified molecular-input line-entry system and represents
the 2D structure of molecules. This
[can be converted](http://www.webqc.org/molecularformatsconverter.php) to
various other formula representation standards, Molecular Weight, etc. which
can be added to the data table and allow for sorting of similar compounds.

My results data table for CAL PDZ are available here:
[RWPTS(X-K)I Virtual Screening Results](https://docs.google.com/spreadsheets/d/1QsGFdNXZ9uxQNUd8bgr-QRWKyXIml03Ninsr090tUzU/edit?usp=sharing). I compiled all of the data and also searched the library for acids similar
to the top hits which had poor binding affinity. This was in an attempt to
demonstrate the specificity of this method in distinguishing modified  
peptides that have high binding affinity from similar ones which have a poor
affinity.


## Results
My results for CAL PDZ screening thus far are preliminary, as they are
completely untested with empirical experimentation. However, four acids were
chosen to be synthesized after the coupling protocol was developed. These
targets were the second and third best binders based on the Prime MMGBSA
prediction. Additionally, they had similar counterparts which were predicted
to have poor binding. Speak to Professor Spaller to get access to my results
output data.

Interestingly, most of the top hits displayed similarities in binding mode
and/or structure. Many of the top hits were also modified amino acids. This
opens the obvious question of coupling not only a single acid to the Lysine
residue, but potentially a series of amino acids in a branched form. The
preliminary setup for screening these branched peptides has been setup in
the Peptide Library directory. This could be expanded to both natural and
unnatural amino acids which could be coupled in this type of synthesis in a
similar manner to normal fmoc
[SPPS procedures](https://en.wikipedia.org/wiki/Peptide_synthesis#Solid-phase_synthesis).
Before investigating further, these preliminary results should be verified
experimentally, as well as additional top targets which have not been
synthesized yet.
