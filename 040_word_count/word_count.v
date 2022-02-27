// A word count like in the Coding Challenge #40 by
// the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os

text := os.read_file('data/rainbow.txt') or {
	eprintln('failed to read the file: $err')
	return
}

mut m := map[string]int{} // a map with `string` keys and `int` values

// Split at any punctuation.
words := text.split_any(":()[] ,;.?!\n")

for word in words {
	if m[word] == 0 {
		m[word] = 1
	} else {
		m[word]++
	}
}

// A map is not sorted. Have to sort the keys
// separately and use the sorted array of keys
// for iteration.
mut keys := m.keys()
keys.sort()

for k in keys {
	v := m[k]
	println('$k $v')
}

