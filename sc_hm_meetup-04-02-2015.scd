// SuperCollider meetup @ HackManhattan
// 4th February 2015

// Usefull Links
//----------------------------------
// - http://supercollider.github.io
// - http://supercollider.sourceforge.net
// - http://audiosynth.com
// - http://supercollider.sourceforge.net/sc140/
// - http://sccode.org


// About & History
//----------------------------------
// - author: James McCartney
// - SuperCollider is a state of the art, realtime sound synthesis server as well as an interpreted Object Oriented language which is based on Smalltalk but with C language family syntax. The language functions as a network client to the sound synthesis server.
// - ICMC 1996 paper: http://www.audiosynth.com/icmc96paper.html
// - SuperCollider is free software published under the GNU GPL

// !!! SAFETY !!!
//----------------------------------
// when SC blows - it has NO RESPECT for your volume control settings
{HPF.ar(Saw.ar, 10000, 1)}.play
{HPF.ar(Saw.ar, -1000, 1)}.play
// working with closed headphones - No-No
// if you absolutely have to - keep the headphones shifted from your ears when you execute code, and only move them over ears when code is running already

// Application examples / inspiration-copy-paste sources
//------------------------------------------------------
// - steal this sound - http://bit.ly/1FgJNdf
// - running on embedded platforms: raspberryPi / beagleBone
// - live coding: http://toplap.org/kid-algorithm/


// SC architecture basics
//----------------------------------
// SC Language << OSC communication >> SC Server
// server
	- SynthDefs and Synths
	- Busses
	- Groups
	- Buffers
- version control: Quarks
	- Quarks.gui
	- recompile library and helpfile base?

## Other clients
	Clojure: http://overtone.github.io
	Scale: http://www.sciss.de/scalaCollider/
	Ruby: https://github.com/maca/scruby
	Haskell: https://github.com/kaoskorobase/hsc3-server
	Javascript: https://github.com/crucialfelix/supercolliderjs

## getting around & Syntax examples
- keyboard shortcuts
	- execute statement
	- boot server
	- get help
- basic syntax

	- if statement
	- case / switch statement
	- for / while loops
	- function definition

## SC-specific features
	multichannel expansion
	Patterns

## Learning resources
- mailing list
- Built-in Getting Started tutorial
- Mark Polishook tutorial
- Practical guide to patterns
- Eli Fieldsteel youtube channel
- Andy Farnell's tutorials
- David Michael Cottle
- Supercollider book
- Stelios Manousakis' series http://modularbrains.net/dx490a/
- notable github repos:
	- https://github.com/supercollider-quarks


## Possible future goals/directions
	live coding jam at BC
	algorithmic composition for monthly music hackathon
	sc tweets / youtube vide analysis?
	general sound synthesis tutorials?
	JITLib tutorials?
	Clojure?


