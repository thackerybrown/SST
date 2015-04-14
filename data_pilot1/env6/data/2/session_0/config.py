# Copyright (c) 2007-2012, Michael J. Kahana.
#
# This file is part of PandaEPL.
#
# PandaEPL is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 2.1 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author: Alec Solway
# URL: http://memory.psych.upenn.edu/PandaEPL

##########################
# Core PandaEPL settings.#
##########################

FOV = 75

# Movement.
linearAcceleration  = 100# set >= fullForward speed for ~"instant" acceleration
fullForwardSpeed    = 5
fullBackwardSpeed   = 0# set to 0 for no backward motion 
turningAcceleration = 85
fullTurningSpeed    = 85
turningLinearSpeed  = 0.25 # Factor

maxTurningLinearSpeed          = 7.0
minTurningLinearSpeedReqd      = 1.0
minTurningLinearSpeed          = 1.5
minTurningLinearSpeedIncrement = 0.5 

#environment 1
##initialPos   = Point3(-41, 14, 0.5)
#environment 2
##initialPos   = Point3(-14, 50, 0.5)
#environment 3
##initialPos   = Point3(-14, 41, 0.5)
#environment 4
##initialPos   = Point3(-23, 41, 0.5)
#environment 5
##initialPos   = Point3(-50, 5, 0.5)
#environment 6
initialPos   = Point3(-14, 50, 0.5)
#initialPos   = Point3(-50, -4, 0.5)
initialHead = [0.0]

avatarRadius = 0.5
cameraPos    = Point3(0, 0, 0.5)
friction     = 0.4
movementType = 'walking' # car | walking

laterPos = [Point3(-32,50,0.5)]#Env 6 avatar reposition locs
laterHead = [0.0]

# Instructions.
instructSize    = 0.075
#instructFont    = '/usr/share/fonts/truetype/freefont/FreeSans.ttf'; # Linux
#instructFont    = '/Library/Fonts/Microsoft/Times New Roman.ttf';    # Mac OS X
instructFont    = '/c/Windows/Fonts/times.ttf';                      # Windows
instructBgColor = Point4(0, 0, 0, 1)
instructFgColor = Point4(1, 1, 1, 1)
instructMargin  = 0.06
instructSeeAll  = False

################################
# Experiment-specific settings.#
################################
#shops
shopDir = '../models/stores/'
shopLocs = [[-23,-4,0],[-50,50,-90],[13,5,0]]
shopZ    = 0.1
numShops = len(shopLocs)


# Goal objects.
storeDir  = '../models/goals/'

#environment 6
storeLocs = [[-23,-24,90],[4,12,90],[-34,14,90]] #[x, y, orientation]
storeZ    = 0.5#z (vertical) coordinate shared by all goals
numStores = len(storeLocs)

# Buildings.
buildingDir  = '../models/buildings/'    
#environment 1
##buildingLocs = [[-50,50],[-50,41],[-50,32],[-32,41],[-32,32],[-23,41],[-23,32], # [x, y] bldg1
##                [-50,14],[-50,5],[-32,14],[-32,5],[-23,14],[-23,5],#bldg2
##                [-50,-13],[-41,-13],[-32,-13],[-23,-13],[-23,-22],[-23,-31],#bldg3
##                [-5,5],[-5,-4],[-5,-13],[-5,-31], [4,-31],#bldg4
##                [13,-31],[22,-31],[31,-31],[31,-22],[31,-13],[31,-4],[31,5],#bldg5
##                [-5,50],[-5,41],[-5,32],[13,32],[4,50],[13,50],[22,50],#bldg6
##                [31,50],[31,41],[31,32],[31,23],[31,14],[-5,14],[4,14],[13,14]]#bldg7

#environment 2
##buildingLocs = [[-50,50],[-50,41],[-50,32],[-50,23],[-50,14],[-41,50],[-32,50], # [x, y] bldg1
##                [-32,14],[-23,14],[-23,23],[-14,23],[-14,14],[-14,5],#bldg2
##                [-14,41],[-5,41],[4,41],[4,32],[4,23],#bldg3
##                [4,5],[13,5],[4,-4],[4,-13], [13,-4], [13,-13], [-5,-13], [-5,-22],#bldg4
##                [-14,-13],[-23,-13],[-32,-13],[-32,-4],[-41,-4],#bldg5
##                [-50,-22],[-50,-31],[-41,-31],[-32,-31],[-23,-31],#bldg6
##                [22,50],[22,41],[22,32],[22,23],[31,23],#bldg 7
##                [31,14],[31,5],[31,-4],[31,-13],[31,-22], [31,-31]]#bldg 8

###environment 3
##buildingLocs = [[-50,50],[-41,50],[-32,50],[-50,41],[-50,32],[-41,32],[-50,23],[-41,23], # [x, y] bldg1
##                [-23,50],[-14,50],[-5,50],[4,50],[-23,32],[-14,32],[-5,32],[4,32],[-23,23],#bldg2
##                [13,50],[22,50],[31,50],[31,41],[31,32],[31,23],[31,14],#bldg3
##                [4,14],[4,5],[13,5],[31,5],[31,-4],[31,-13],#bldg4
##                [31,-22],[31,-31],[22,-31],[13,-31],[4,-31],[-5,-31],[-14,-31],[-23,-31],#bldg5
##                [-32,-31],[-41,-31],[-50,-31],[-50,-22],[-41,-4],[-41,5],[-32,-4],[-32,5],#bldg6
##                [13,-13],[4,-13],[-5,-13],[-14,-13],[-23,-13],[-14,-4],[-23,-4],[-23,5]]#bldg 7


#environment 6
buildingLocs = [[-50,23],[-50,14],[-41,14],[-32,41],[-32,32], # [x, y] bldg1 #[-50,50],
                [-50,-31],[-41,-31],[-41,-4],[-41,-13],[-23,-13],#bldg2  #[-23,-4],
                [-14,-4],[-14,-13],[-14,-31],[-5,-4],[-5,-31],[4,5],[4,-4],[13,-4],#bldg3  #[13,5],
                [4,-22],[13,-22],[22,-22],[31,-22],[31,-13],#bldg4
                [31,-4],[31,5],[31,14],[22,23],[13,23],#bldg5
                [31,32],[31,41],[31,50],[22,50],[4,41],#bldg6
                [-23,14],[-14,14],[-14,41],[-5,41],[-5,32],[-5,23]]#bldg 7


buildingZ    = 0.25#z (vertical) coordinate shared by all buildings
numBuildings = len(buildingLocs)

# Barriers.
barrierDir  = '../models/barriers/'   
##barrierLocs = [[-46,50],[-46,41],[-46,32],[-46,23],[-46,14],[-46,5],[-46,-4],[-36,14],[-36,5],
##[-36,41],[-36,32],[-19,41],[-19,32],[-19,14],[-19,5],[-19,-13],[-19,-22],[-9,-13],
##[-9,-4],[-9,5],[-9,14],[-9,32],[-9,41],[-9,50],[-1,41],[-1,32],[-1,5],[-1,-4],
##[-1,-13],[9,-22],[9,-13],[9,-4],[9,32],[17,32],[17,14],[27,41],[27,32],[27,23],
##[27,14],[27,5],[-41,55],[-32,55],[-23,55],[-14,55],[-32,45],[-23,45],[-32,28],
##[-23,28],[-32,18],[-23,18],[-32,1],[-23,1],[-32,-9],[-23,-9],[-41,-9],[-14,-27],
##[-5,-27],[4,-27],[-5,-17],[-5,18],[-5,28],[4,18],[13,18],[13,28],[13,36],[13,46],
##[4,46],[22,46],[22,0],[13,0],[13,10],[4,10]]

###10-unit barriers (1 building size)
##barrier1Locs = [[-32,36],[-41,28],[-32,18],[-50,10],[-50,-18],[-41,-8],[-5,-26],[-14,1],[4,19],[22,19],[-18,41],[-36,32],[-36,14],[-27,23],[-18,5],[-27,-4],[-45,-4],[-46,-22],[-36,-13],[-19,-31],[9,-31],[-9,-22],[-1,-22]]
##numBarriers1 = len(barrier1Locs)
###20-unit barriers
##barrier2Locs = [[-9,37],[-18,27],[-27,10],[-37,0],[9,9],[9,-17],[18,-27],[0,28],[-27,45],[0,1],[-46,19]]
##numBarriers2 = len(barrier2Locs)
###etc..
##barrier3Locs = [[-5,45],[-14,-9],[-33,-27],[-21,-17],[-5,-35],[-10,14],[8,32],[17,-4],[-55,-4]]
##numBarriers3 = len(barrier3Locs)
##
##barrier4Locs = [[18,37]]
##numBarriers4 = len(barrier4Locs)
##
##barrier5Locs = [[-5,55],[27,-4]]
##numBarriers5 = len(barrier5Locs)


###10-unit barriers (1 building size)
##barrier1Locs = [[-32,46],[-23,19],[22,19],[-5,10],[13,9],[-14,0],[-19,23],[-9,14],[8,14],[-19,5],[0,5],[17,5],[-10,-4],[17,-13],[-27,-13],[-37,-22],[8,32]]
##numBarriers1 = len(barrier1Locs)
###20-unit barriers
##barrier2Locs = [[-45.5,19],[-0.5,18],[-36.5,-8],[-45.5,-18],[-27.5,-27],[8.5,1],[-45,0.5],[-27,27.5]]
##numBarriers2 = len(barrier2Locs)
###etc..
##barrier3Locs = [[-5,28],[-32,9],[4,-9],[-37,32],[18,32]]#for horizontals: on north side use y+4, on south side use y-4
##numBarriers3 = len(barrier3Locs)
##
##barrier4Locs = [[-9.5,36],[-55,0.5]]
##numBarriers4 = len(barrier4Locs)
##
##barrier5Locs = [[-5,46],[4,-27],[-5,-17],[27,-4]]
##numBarriers5 = len(barrier5Locs)


###10-unit barriers (1 building size)
##barrier1Locs = [[-14,37],[-14,9],[4,10],[-5,0],[13,-8],[-10,41],[0,32],[0,14],[-10,5],[9,-22]]
##numBarriers1 = len(barrier1Locs)
###20-unit barriers
##barrier2Locs = [[-36.5,45],[-36.5,9],[-36.5,-17],[-45.5,-27],[-9.5,-17],[17.5,-18],[8.5,36],[-28,36.5],[-18,45.5],[27,36.5],[9,0.5],[-1,-8.5]]
##numBarriers2 = len(barrier2Locs)
###etc..
##barrier3Locs = [[-14,27],[-45,32],[-45,-4],[-28,-4],[-18,-4]]#for horizontals: on north side use y+4, on south side use y-4
##numBarriers3 = len(barrier3Locs)
##
##barrier4Locs = [[-36.5,55],[8.5,46],[-55,36.5]]
##numBarriers4 = len(barrier4Locs)
##
##barrier5Locs = [[-23,19],[-14,-27],[27,5],[17,14],[-55,-4]]
##numBarriers5 = len(barrier5Locs)


##barrier1Locs = [[-14,28],[13,0],[22,-9],[31,1],[-46,-13],[-28,-13],[-18,32],[-18,14],[17,-4],[26,-13]]
##numBarriers1 = len(barrier1Locs)
###20-unit barriers
##barrier2Locs = [[-36.5,27],[-36.5,1],[-36.5,-9],[-36.5,-17],[-9.5,18],[-9.5,0],[17.5,-17],[8.5,36],[-55,27.5],[-10,36.5],[0,27.5],[9,-8.5]]
##numBarriers2 = len(barrier2Locs)
###etc..
##barrier3Locs = [[-45,14],[-28,14],[-18,-13],[-1,-13],[17,23],[36,-13]]#for horizontals: on north side use y+4, on south side use y-4
##numBarriers3 = len(barrier3Locs)
##
##barrier4Locs = [[-36.5,37],[8.5,46],[-0.5,10]]
##numBarriers4 = len(barrier4Locs)
##
##barrier5Locs = [[-32,-27],[13,-27],[-55,-4],[27,23]]
##numBarriers5 = len(barrier5Locs)

barrier1Locs = [[-32,45],[-32,28],[-41,18],[-23,18],[4,37],[13,27],[-5,19],[-41,0],[-41,-17],[-5,-27],[-37,14],[-27,14],[-10,14],[8,41],[9,23],[0,5],[-10,-13],[0,-22]]
numBarriers1 = len(barrier1Locs)
#20-unit barriers
barrier2Locs = [[-45.5,10],[-18.5,10],[-18.5,-17],[8.5,55],[8.5,9],[17.5,19],[-36,36.5],[-28,36.5],[-1,27.5],[-45,-8.5],[-37,-8.5],[-27,-8.5],[17,0.5]]
numBarriers2 = len(barrier2Locs)
#etc..
barrier3Locs = [[-5,45],[-14,0],[4,-8],[13,-18],[-18,32],[18,41]]#for horizontals: on north side use y+4, on south side use y-4
numBarriers3 = len(barrier3Locs)

barrier4Locs = [[-46,36.5],[-55,-8.5],[27,0.5]]
numBarriers4 = len(barrier4Locs)

barrier5Locs = [[-23,55],[-32,-27]]
numBarriers5 = len(barrier5Locs)


##barrierOrs = [[90],[90],[90],[90],[90],[90],[90],[90],[90],
##[90],[90],[90],[90],[90],[90],[90],[90],[90],
##[90],[90],[90],[90],[90],[90],[90],[90],[90],[90],
##[90],[90],[90],[90],[90],[90],[90],[90],[90],[90],
##[90],[90],[360],[360],[360],[360],[360],[360],[360],
##[360],[360],[360],[360],[360],[360],[360],[360],[360],
##[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],
##[0],[0],[0],[0],[0],[0]]

barrierZ    = -0.7#z (vertical) coordinate shared by all buildings



# Terrain, sky.
#terrainModel  = './models/towns/db_TownHospital3.bam'
#terrainModel  = './models/towns/simpletown1_11x11.egg'
#terrainModel  = '../models/building_blox/arena1_11x11.egg'
#terrainModel2 = '../models/building_blox/arena2_11x11.egg'
terrainModel6 = '../models/building_blox/arena6_11x11.egg'
terrainCenter = Point3(0,0,0)
skyModel      = '../models/sky/sky.bam'
skyScale      = 1.6

# Gameplay.
numDeliveries  = 20
startingScore  = 100
deliveryBonus  = 50
scoreDecrement = 1
scoreDecrementInterval = 1000 # in ms

# Heads-up display.
scorePos   = Point3(0.83,0,1)
scoreSize  = 0.1
scoreColor = Point4(1,0,0,1)

assignmentPos   = Point3(-1,0,1)
assignmentSize  = 0.1
assignmentColor = Point4(1,0,0,1)

# (Non-default) command keys.
keyboard = Keyboard.getInstance()
keyboard.bind("exit", ["escape", "q"])
keyboard.bind("toggleDebug", ["escape", "d"])
keyboard.bind("toggleFog", "f")
keyboard.bind("toggleLighting", "l")
keyboard.bind("recordSound", "r")
keyboard.bind("playSound", "p")
keyboard.bind("stopSound", "s")

joystick = Joystick.getInstance()
joystick.bind("toggleDebug", "joy_button0")

# Instructions.
instructionFile        = './instructions.txt'
deliveryMadeText       = 'Congratulations! You found: %s.'
assignmentText         = 'Pick up: %s.'
experimentCompleteText = 'You have successfully completed all of the quests in this town.'

# Lighting.
initialLightingScheme   = 0
darkAmbientLightColor   = Point3(0.2,0.2,0.2)
brightAmbientLightColor = Point3(0.8,0.8,0.8)
directionalLightColor   = Point3(1,1,1)
directionalLightOrient  = Point3(270,0,0)
pointLightColor         = Point3(0.8,0.8,0.8)
pointLightPos           = initialPos
pointLightAttenuation   = Point3(0,0,0.01)
spotlightColor          = Point3(0.8,0.8,0.8)
spotlightPos            = initialPos
spotlightFallof         = 0.01 
spotlightHorzFov        = 50

# Fog.
initialFogScheme  = 0
expFogColor       = Point3(0.4,0.4,0.4)
expFogDensity     = 0.04

