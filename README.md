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


## Localizer parameters

List of paramaters (located in `script`: `variable`) that can be modified:

- **Number of runs** (`sst.m`: `blockinfo.run_num`): 2 runs
- **Number of mini blocks per category per run** (`sst.m`: `blockinfo.miniblock_num`) : 4
- **Stimuli presented per mini block** (`sst.m`: `blockinfo.stim_per_miniblock`): 10
- **Proportion of trials per mini block that are 1-back repeats** (`sst.m`: `blockinfo.repfreq`): 1/3
- **Duration of each stimulus presentation** (`localizer_task.m`: `stimTime`): .6 seconds
- **Duration of fixation between stimuli** (`localizer_task.m`: `nullTime`): 1 second
- **Duration of rest fixation between mini blocks** (`sst_run.m`: `S.restTime`): 10 seconds
- **Duration of lead-in time between trigger and stimulus onset** (`sst_run.m`: `S.leadIn`): 12 seconds, discard 6 volumes

**Total Run Time**: ((1.6*10*4*5)+ (10*4*5) + 12 + 12)/60 =  9.0667 minutes

**Categories**: faces, tools, fruits/vegetables, animals, virtual environment scenes

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

Make sure Eprime trigger USB is plugged into laptop. I use the Wagner lab USB splitter (in 2nd Wagner lab drawer in CNI) to plug into the closest USB port on the left side of Ari; both the Responses USB and the Eprime trigger USB are plugged into the USB splitter. I've been using the 5-button white/black response box, which you need to sync with the FORP box by selecting (manual, USB): 1x5 D, HID NAR No5.

Once you've entered in the inputs for the `sst.m` script, an instruction screen will come up. If running in the scanner, you should:

1. Prep scan on console (drop down from Scan button)
2. Once prep scan done, Scan should be highlighted on console; hit "g" on the keyboard
3. Hit Scan on the scanner console
4. Hit "g" on the keyboard; this should trigger the scanner
....
 
 At the end of the block, the reminder for the next block will appear (if more than 1 block total); follow same instructions above.
 
 
