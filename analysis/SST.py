print 'v2'

palette = {'no response': 'gray', 
		  'foil': 'violet',
		  'safe': 'mediumturquoise',
		  'threat': 'darkorange',
		  'pilot': 'cadetblue',
		  'control': 'seagreen', 
		  'stress': 'crimson',
		  'half1': 'royalblue',
		  'half2': 'slategray',
		  'control-fmri': 'lightgreen', 
		  'stress-fmri': 'lightred',
		  'face': 'orange',
		  'tool': 'mediumpurple',
		  'animal': 'dodgerblue',
		  'food': 'mediumseagreen'
		  }
              
envs = ['env1', 'env2', 'env3', 
		'env4', 'env5', 'env6',
		'env7', 'env8', 'env9', 
		'env10', 'env11', 'env12']

subjinfo_file = 'subj_info.csv'

shortcut_file = 'building_coords.csv'

goals = {'env1': {'face': 'George_Clooney', 'food': 'lettuce', 'animal': 'zebra'},
		 'env2': {'face': 'Mark_Zuckerberg', 'tool': 'scissors', 'food': 'cucumber'},
		 'env3': {'face': 'Emma_Watson', 'animal': 'brown_bear', 'tool': 'screwdriver'},
		 'env4': {'face': 'Natalie_Portman', 'animal': 'alligator', 'tool': 'saw'},
		 'env5': {'face': 'Benedict_Cumberbatch', 'animal': 'flamingo', 'food': 'watermelon'},
		 'env6': {'face': 'Taylor_Swift', 'animal': 'cow', 'tool': 'tape_measure'},
		 'env7': {'face': 'Jim_Parsons', 'animal': 'giraffe', 'tool': 'drill'},
		 'env8': {'face': 'Beyonce', 'animal': 'puppy', 'food': 'oranges'},
		 'env9': {'face': 'Paul_McCartney', 'food': 'banana', 'tool': 'wrench'},
		 'env10': {'face': 'Katy_Perry', 'animal': 'duck', 'food': 'grapes'},
		 'env11': {'face': 'Johnny_Depp', 'tool': 'hammer', 'food': 'carrot'},
		 'env12': {'face': 'Zooey_Deschanel', 'tool': 'stapler', 'food': 'apple'}
		 }
		 