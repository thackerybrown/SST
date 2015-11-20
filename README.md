# SST
Spatial Stress Test

## Dependencies
felix (from Waglerlab Github)

## Directory structure
`sst.m`: main script
`data`: output data
`scripts`: scripts for running tasks
`stimuli`: stimuli for item test
`loc_stimuli`: localizer stimuli
`orderfiles`: files generated per participant to determine order of stimuli

## Running the Localizer

In the matlab console, run the following:
`> cd ~/Experiments/SST`
`> sst`

This will start the main script, and prompt you for some inputs:

### Inputs
**What is the subject ID?** (enter in some code that will become the folder name in the data directory)
`> sst99`

**Use existing stim file? (1=yes,0=no)** (If you've run other tasks on this subject, the order files will have been created; you can keep those by saying yes)
`> 1`

**itemTest(1), quest(2), loc-prac(3), loc-scan(4)?** (Enter 3 if you're doing localizer practice, or 4 if it's the scan task)
`> 4`

**Response mapping (1, 2)?** (1 if the subject is an odd number, 2 if even; this counterbalances the response key mapping)
`> 1`

**Enter block number:** (1 if starting at first block, or another number if need to restart the script mid-task)
`> 1`

**inside scanner(1) or outside(2)?** (1 if scan task and want to trigger scanner + use button box, 2 if behavioral out of scanner)
`> 1`

**control(1) or stress(2)?** (Just hit 1 here, since no shock in the localizer)
`> 1`

**What are the experimenter's initials? (e.g., SG):** (Enter in initials to receive email w/session time when completed; the initial-email mapping needs to be set in `sst_run.m`)
`> SG`

### Sync with scanner

Once you've entered in the inputs, an instruction screen will come up. If scanning, you should:

1. Prep scan
2. Once Scan is highlighted, hit "g" on the keyboard
3. Hit Scan on the scanner console
4. Hit "g" on the keyboard; this should trigger the scanner
