# Sonic-ChordProgression
function for Sonic Pi to create a chordprogression (ring of different chords)

# Syntax
```ruby
getProgression(root_note, progression_string, :key)
```
for example:
```ruby
getProgression(60, 'I-IV-V-VI', :maj) # => (ring (ring 60, 64, 67), (ring 65, 69, 72), (ring 67, 71, 74), (ring 69, 72, 76))
                                      #     ring (C maj,             F maj,             G maj,            a min) 
```
## Syntax - Elements
- root: can be a integer (60), symbbol (:C4) or String ('C4')
- progression_string
    - roman numerals fom I to VII
    - optional: s or b for sharp or flatten e.g. ```IIs```
    - optional: number for the octave e.g. ```IIs2``` or ```II6```
    - optional: invert-parameter (e.g. i2 for second inversion of the chord) or chordname (e.g. 'sus2') in round brackets e.g. ```II(sus2, i3)```

# Usage
1) clone or download the repository
2) ```require 'path/to/progression_gen.rb'```
3) create a progression like ```progression = getProgression(60, 'I-IV(i4)-V(add9, i2)-IV')```

# ToDo
- improve code
