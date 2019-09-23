def setNote(note_value, octave)
  note_value = note_value.to_i if note_value.is_a? Symbol
  note_value = note_value.to_sym.to_i if note_value.is_a? String
  (note_value%12+12)+octave*12
end

def getProgression(root, progression, key = :maj)

  note_dictionary = {:maj => {"Ib" => [root-1, :maj],
                              "I" => [root, :maj],
                              "Is" => [root + 1, :maj],

                              "IIb" =>[root + 1, :minor],
                              "II" => [root + 2,:minor],
                              "IIs" => [root + 3, :minor],

                              "IIIb" => [root + 3, :minor],
                              "III" => [root + 4, :minor],
                              "IIIs" => [root + 5, :minor],

                              "IVb" => [root + 4, :maj],
                              "IV" => [root + 5, :maj],
                              "IVs" => [root + 6, :maj],

                              "Vb" => [root + 6, :maj],
                              "V" => [root + 7, :maj],
                              "Vs" => [root + 8, :maj],

                              "VIb" => [root + 8, :minor],
                              "VI" => [root + 9, :minor],
                              "VIs" => [root + 10, :minor],

                              "VIIb" => [root + 10, :dim],
                              "VII" => [root + 11, :dim],
                              "VIIs" => [root + 12, :dim]},

                     :minor => {"Ib" => [root-1, :minor],
                                "I" => [root, :minor],
                                "Is" => [root + 1, :minor],

                                "IIb" =>[root + 1, :dim],
                                "II" => [root + 2,:dim],
                                "IIs" => [root + 3, :dim],

                                "IIIb" => [root + 2, :maj],
                                "III" => [root + 3, :maj],
                                "IIIs" => [root + 4, :maj],

                                "IVb" => [root + 4, :minor],
                                "IV" => [root + 5, :minor],
                                "IVs" => [root + 6, :minor],

                                "Vb" => [root + 6, :minor],
                                "V" => [root + 7, :minor],
                                "Vs" => [root + 8, :minor],

                                "VIb" => [root + 7, :maj],
                                "VI" => [root + 8, :maj],
                                "VIs" => [root + 9, :maj],

                                "VIIb" => [root + 9, :maj],
                                "VII" => [root + 10, :maj],
                                "VIIs" => [root + 11, :maj]}}

  #delete whitespacs and split all progression elements (still with options)
  progression_elements = progression.gsub(/\s+/, '').split(/[\-\_]/)

  #get the chord base string of every element (e.g. IVs8)
  chord_base_string = progression_elements.map{|el|el.scan(/[IVsb]+\d?/)[0]}

  #filter the octave value of every progression chord base
  octave_option = chord_base_string.map{|element|element.scan(/\d/)[0]}

  #filter the chord base wihtout octave
  base_string = chord_base_string.map{|element| element.scan(/[sbIV]+/)[0]}
  #convert every base string to the chord root as integer value
  base_note = base_string.map{|element| note_dictionary[key][element][0]}
  #look if there is a octave and set value
  base_note = base_note.each_with_index.map do |n,i|
    if octave_option[i] == nil
      n
    else
      setNote(n, octave_option[i].to_i)
    end
  end

  #get an array with options for every chord
  options = progression_elements.map! do |element|
    #are there elemtens in ()
    element = element.scan(/\(.+\)/)[0]
    if element
      element = element.delete("()")
      element.split(",")
    end
  end

  #filter the invert values for every chord from options
  #delete invert values, so that you have only chord options (e.g. "maj") in options array
  invert_values=[]
  options.each do |element|
    if element == nil
      invert_values << 0
    else
      if element.grep(/i\d/).empty? == false
        invert = element.grep(/i\d/)[0].delete("i").to_i
        #insert invert value
        invert_values << invert
        #delete string with invert value
        element.delete(element.grep(/i\d/)[0])
      else
        invert_values << 0
      end
    end
  end

  chord_options=[]
  options.each_with_index do |element,idx|
    if element == nil or element.empty?
      chord_options << note_dictionary[key][base_string[idx]][1]
    else
      chord_options << element[0]
    end
  end

  final_progression = []
  final_progression = base_note.each_with_index.map do |n,i|
    chord(n, chord_options[i], invert: invert_values[i])
  end

  return final_progression.ring
end
