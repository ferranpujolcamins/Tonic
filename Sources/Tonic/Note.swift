import Foundation

struct Note: Equatable {

    /// Base name for the note
    var letter: Letter = .C

    /// Semitone shift for the letter
    var accidental: Accidental = .natural

    /// Range from -1 to 7
    var octave: Int = 4

    init(letter: Letter = .C, accidental: Accidental = .natural, octave: Int = 4) {
        self.letter = letter
        self.accidental = accidental
        self.octave = octave
    }

    init(noteNumber: UInt8) {
        let letters: [Letter] = [.C, .C, .D, .D, .E, .F, .F, .G, .G, .A, .A, .B]
        letter = letters[Int(noteNumber % 12)]

        let accidentals: [Accidental] = [.natural, .sharp, .natural, .sharp, .natural, .natural, .sharp, .natural, .sharp, .natural, .sharp, .natural]
        accidental = accidentals[Int(noteNumber % 12)]
        octave = Int(Double(noteNumber) / 12) - 1
    }

    /// MIDI Note 0-127 starting at C
    var noteNumber: Int8 {
        return Int8((octave + 1) * 12) + Int8(letter.baseNote) + accidental.rawValue
    }

    /// The way the note is described in a musical context (usually a key or scale)
    var spelling: String {
        return "\(letter)\(accidental)"
    }

    func semitones(to: Note) -> Int {
        abs(Int(noteNumber - to.noteNumber))
    }

    func shift(_ shift: Interval) -> Note {
        var newNote = Note(letter: .C, accidental: .natural, octave: 0)
        let newLetterIndex = (letter.rawValue + (shift.degree - 1))
        let newLetter = Letter(rawValue: newLetterIndex % Letter.allCases.count)!
        let newOctave = octave + (newLetterIndex >= Letter.allCases.count ? 1 : 0)
        for accidental in Accidental.allCases {
            newNote = Note(letter: newLetter, accidental: accidental, octave: newOctave)
            if newNote.noteNumber == Int8(noteNumber) + Int8(shift.semitones) {
                return newNote
            }
        }
        fatalError()
    }
}
