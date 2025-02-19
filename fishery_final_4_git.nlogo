globals [
  harvest-count        ; fish caught by fisheries
  ; birth-rate of the fish population
  ; initial-fish-count is initial number of fish in the population
  ; k is carrying capacity
  ; harvest-rate is the rate at which fish are caught per tick
]



to setup
  ca

  ; set the harvest count to the initial values
  set harvest-count 0

  ; set up the patches, color them blue for aesthetics
  ask patches [
    set pcolor 96.5
  ]

  ; create the fish
  create-turtles initial-fish-count [
    set color 25
    set shape "fish"
    setxy random-xcor random-ycor      ; randomize fish locations
    set size 5
  ]

  reset-ticks
end



; the go procedure. Runs forever when you hit the go button, runs only once when you hit the step button
to go
  tick

  plot-graphs       ; plot the figures on the interface

  reproduce         ;fish reproduce
  natural-death     ;fish die naturally if there are more than the environment can support (carrying capacity)
  harvest           ;catch fish

  ask turtles [ swim ] ;have the fish swim around for visual purposes

  ;run simulation for 200 ticks or until all the fish are harvested
  if (ticks >= 200) or (count turtles = 0)
   [ stop ]
end



; fish reproduce
to reproduce
  ask turtles [
    ; fish generate a number and reproduce if that number is less than the reproduciton rate
    if random-float 1.0 < reproduction-rate
       [ hatch 1 ]
  ]
end



; a fisher catches a fish and removes it from the population
to harvest
  ask turtles [
    if random-float 1.0 < harvest-rate
    [  ;increment the harvest-count and remove the fish if the fish is caught
       set harvest-count (harvest-count + 1)
       die
     ]
  ]
end



; fish can naturally die if the number of them alive exceeds the carrying-capacity
to natural-death
  let fish-count count turtles
  ; fish only naturally die if the population exceeds or reaches the carrying capacity
  if fish-count <= carrying-capacity
    [ stop ]

  ; if the number of fish is greater than the carrying capacity, calculate the chance of death
  let chance-of-death (fish-count - carrying-capacity) / fish-count

  ; randomly "roll a dice" to determine if the fish will die
  ask turtles
  [
    if random-float 1.0 < chance-of-death
      [ die ]
  ]
end



; fish swim around the fishery. A turtle procedure for exclusively visual purposes.
to swim
  ; randomly turn and move forwards
  rt random-float 30 - random-float 30
  fd 1
end



to plot-graphs
  ; plot the fish living and caught on the same plot, for comparisons
  set-current-plot "Living and Caught Fish Over Time"
  set-current-plot-pen "alive-pen"
  plot count turtles                 ; plot the number of fish alive
  set-current-plot-pen "caught-pen"
  plot harvest-count                 ; plot the number of fish caught

  ; plot the fish alive plot
  set-current-plot "Living Fish Over Time"
  set-current-plot-pen "default"
  plot count turtles                  ; plot fish alive
  set-current-plot-pen "pen-1"
  plot carrying-capacity              ; plot carrying capacity

  ; plot the fish caught plot
  set-current-plot "Fish Caught Over Time"
  set-current-plot-pen "default"
  plot harvest-count                   ; plot fish caught
end
@#$#@#$#@
GRAPHICS-WINDOW
454
26
912
485
-1
-1
3.0
1
10
1
1
1
0
1
1
1
0
149
0
149
0
0
1
ticks
30.0

BUTTON
92
125
167
158
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
191
125
268
158
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
291
125
366
158
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
19
27
220
60
carrying-capacity
carrying-capacity
0
250
223.0
1
1
fish
HORIZONTAL

SLIDER
19
76
219
109
initial-fish-count
initial-fish-count
0
250
223.0
1
1
fish
HORIZONTAL

SLIDER
239
76
440
109
harvest-rate
harvest-rate
0
1
0.43
0.01
1
NIL
HORIZONTAL

PLOT
13
339
229
489
Living and Caught Fish Over Time
ticks
fish
0.0
30.0
0.0
50.0
true
false
"" ""
PENS
"caught-pen" 1.0 0 -2674135 true "" ""
"alive-pen" 1.0 0 -15582384 true "" ""
"pen-2" 1.0 0 -13840069 true "" ""

SLIDER
238
27
439
60
reproduction-rate
reproduction-rate
0
1
0.76
0.01
1
NIL
HORIZONTAL

PLOT
16
183
230
333
Living Fish Over Time
Ticks
Fish Alive
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""
"pen-1" 1.0 0 -13840069 true "" ""

PLOT
238
183
446
333
Fish Caught Over Time
Ticks
Fish Caught
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

MONITOR
241
340
335
385
total caught
harvest-count
17
1
11

MONITOR
350
340
440
385
fish alive
count turtles
17
1
11

@#$#@#$#@
# Fishery Population Dynamics Model ODD Description
This file describes the model of fisheries and harvest rates on the total population. The file uses the markup language used by NetLogo's Info tab starting with NetLogo version 5.0.

## Purpose
The model was designed to explore questions about fisheries and the ideal harvesting threshold. Fisheries aim to maximize profit while minimizing the impact on population biomass. Under what conditions do the interactions of fish and fishing over time lead to the depletion of fish or extinction of fish within a population? How does variability in the harvesting rate affect the existing population of fish? 

## Entities, State Variables, and Scales
The model has one entity: fish. The patches make up a square grid landscape of 150 × 150 patches. The location of each fish is not important in the model. Patch size is not specific because the model is generic. Simulations will last 200 timesteps or until complete fish population extinction. The length of one timestep represents one generation and should be as long as it would take for a fish to reproduce or die. 

## Process Overview and Scheduling
There are three processes in the model: reproduction, harvesting, and natural death. On each time step, each fish has a chance of reproducing or being harvested. Natural death is a random chance for any fish to die when the population is over the carrying capacity. The order in which the fish execute these actions is unimportant because there are no interactions among the fish.

## Design Concepts
The basic principle addressed by this model is determining the point at which harvesting is too great for fish populations to continue. In other words, what is the maximum harvest that does not lead to fish extinction? This concept is modeled via the simple assumption that when the harvesting rate exceeds the reproduction rate, the fish population will diminish to the point of extinction. This assumption is based on known predator-prey relationships, wherein if the prey species is depleted by the predator faster than the prey can replenish themselves, the prey will go to extinction. There is no learning in the model. Sensing is not important in this model. The fish have adjustable sliders that impact carrying-capacity, ranging from 0 to 250; initial-fish-count, ranging from 0 to 250; reproduction-rate, ranging from 0.00 to 1.0; and harvest-rate, ranging from 0.00 to 1.0. Fisheries are able to change their quota for fish harvested in real life, which is represented by the harvest-rate slider. There is no direct interaction between fish in the model, but natural fish interaction is assumed in their reproduction. To allow observation of the two processes, we use a visual display of patches (sea) and fish that reproduce and die. The go button runs the model. Fish move randomly while the simulation is running to allow visualization of the population. Running counts are displayed of the number of fish alive in the population and the total number of fish harvested. 


## Initialization
The setup button initializes the fishery. A user-defined amount of fish is set with the slider and they are further initialized by having initial locations spread across the map.The fish are initialized by creating the amount that has been user-defined via a slider and setting their initial location randomly across the world. Carrying capacity, reproduction rate, and harvest rate are also preset by the user via slider.

## Input Data
The model has four inputs: the fishery (or environment) carrying capacity, the reproduction rate of the fish, the initial fish count of fish in the population, and the harvest rate of the fish. The carrying-capacity slider sets a limit to the overall fish population the environment can support. The reproduction-rate slider sets the average number of offspring the fish have in a generation. The initial-fish-count slider sets the initial count of fish in the population. The harvest-rate slider represents the chance each fish has of being caught and removed from the population in each generation. 

## Submodels
The model has three submodels: one for natural death, one for harvest rate, and one for reproduction rate. Natural death simulates natural mortality among fish within the population, particularly when population size exceeds carrying capacity. It calculates the chance of fish dying naturally if the population exceeds carrying capacity and randomly selects fish to die based on this chance. Harvest rate simulates the harvesting of fish by a fisher, impacting the population size. For example, a harvest rate of 0.5 would mean each fish has a 50% chance of being harvested. If the number generated by random-float is less than harvest-rate, then the fish has been caught. The reproduction rate submodel simulates the reproductive behavior of fish within the population. It operates by checking each fish's eligibility to reproduce based on a specified reproduction rate. For each fish, the submodel generates a random number including 0 and then compares it to the reproduction rate. Suppose the random number is less than the reproduction rate, indicating that the fish is eligible to reproduce. In that case, using the 'hatch' command, the fish produces one new offspring adjacent to its current position. This process iterates through each fish in the population, effectively increasing the population size by one for each eligible fish.


## CREDITS AND REFERENCES

NetLogo. (n.d.). NetLogo User Manual. Retrieved from http://ccl.northwestern.edu/netlogo/docs/.

Wilensky, U. (1997). NetLogo Simple Birth Rates model. 
http://ccl.northwestern.edu/netlogo/models/SimpleBirthRates. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.     

Wilensky, U. (1997). NetLogo Wolf Sheep Predation model. http://ccl.northwestern.edu/netlogo/models/WolfSheepPredation. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.  
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
