//###################################################
// this document is a collection of remarkable (to my taste) SC demos
// assembled in one place for convinience
//###################################################


//===================================================
// SC 140 - Nathaniel Virgo
//---------------------------------------------------
//http://supercollider.sourceforge.net/sc140/
//===================================================
play{p=PinkNoise.ar(1!2);BRF.ar(p+Blip.ar(p+2,400),150,2,0.1)+LPF.ar(FreeVerb2.ar(*LPF.ar(p+0.2*Dust.ar(0.1),60)++[1,1,0.2,1e4]).tanh,2000)}


//###################################################
// Mitchell Sigman (2011) Steal this Sound. Milwaukee, WI: Hal Leonard Books
// implementations by Nick Collins
// http://www.sussex.ac.uk/Users/nc81/index.html
//###################################################

//start here
(
//make sure server is booted if you want to hear any sound!
s.boot;

//bpm 120 assumed in the following, impacting on some delay recipes.
TempoClock.default.tempo = 2;
)



//===================================================
// Goldfrapp - Number One
//---------------------------------------------------
// http://youtu.be/gzfaJRDfveo
//===================================================

(
SynthDef(\plastickystrings,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 5900 lfowidth= 0.01 cutoff= 12000 rq=0.5 pan=0.0|

	var lfo, saw, filter, env;
	lfo = LFTri.ar(lforate,Rand(0,2.0));
	saw = Saw.ar(freq*(1.0+(lfowidth*lfo)),0.5);
	filter = BHiPass.ar(saw,freq,rq); 	//or using cutoff
	env = EnvGen.ar(Env.adsr(0.4,0.0,1.0,1.0),gate,doneAction:2);
	Out.ar(out,Pan2.ar(filter*env*amp,pan));

}).add;


SynthDef(\choruseffect2, {|out =0 gate= 1|
	var source = In.ar(out,2);
	var chorus;
	var env = Linen.kr(gate, 0.1, 1, 0.1, 2);

	chorus= Mix.fill(17, {
		var maxdelaytime= rrand(0.005,0.02);
		DelayC.ar(source, maxdelaytime,LFNoise1.kr(Rand(4.5,10.5),0.25*maxdelaytime,0.75*maxdelaytime) )
	});

	XOut.ar(out,env,0.5*chorus);

}).add;
)

//goldfrapp number 1 riff
(
Pfx(
	Ppar([
		Pbind(
			\instrument, \plastickystrings,
			\amp, 0.2,
			[\midinote,\dur],Pseq([[72,1.5],[68,6.5],[72,1.5],[68,1.5],[61,5.0]],inf),
			\lfowidth,Pn(Pseries(0.0,0.001,16),inf),
			\lforate,5900, //5.9?
			\rq,Pn(Pseries(0.9,-0.05,8),inf)
		),
		Pbind(
			\instrument, \plastickystrings,
			\amp, 0.3,
			[\midinote,\dur],Pseq([[44,8.0],[37,8.0]],inf),
			\lfowidth,Pn(Pseries(0.0,0.001,16),inf),
			\lforate,5.9,
			\rq,0.9
		),
	]),
	\choruseffect2
).play
)

//===================================================
// Radiohead - Everything In Its Right Place
//---------------------------------------------------
// http://youtu.be/VrpGhEVyrk0
//===================================================

(
SynthDef(\everythingrhodes,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 4.85 lfowidth= 0.5 cutoff= 2000 rq=0.5 pan = 0.0|

	var pulse, filter, env;
	pulse = Pulse.ar(freq*[1,33.5.midiratio],[0.2,0.1],[0.7,0.3]);
	env = EnvGen.ar(Env.adsr(0.0,1.0,0.8,3.0),gate,doneAction:2);
	//keyboard tracking filter cutoff
	filter = BLowPass4.ar(pulse,(cutoff*(env.squared))+200+freq,rq);
	Out.ar(out,Pan2.ar(Mix(filter)*env*amp,pan));

}).add;


//chorus and compression
SynthDef(\choruscompresseffect, {|out =0 gate= 1|
	var source = In.ar(out,2);
	var chorus;
	var env = Linen.kr(gate, 0.1, 1, 0.1, 2);

	chorus= Splay.ar(Array.fill(4,{
		var maxdelaytime= rrand(0.005,0.02);
		DelayC.ar(source[0], maxdelaytime,LFNoise1.kr(Rand(0.1,0.6),0.25*maxdelaytime,0.75*maxdelaytime) )
	}));

	chorus = Compander.ar(4*(source + chorus),source,0.4,1,4);

	XOut.ar(out,env,chorus);

}).add;

)

(
Pfx(
	Pbind(
		\instrument,\everythingrhodes,
		\midinote,Pseq([12,8,7,0,[-12,4,12],[-12,4,12],[-12,4,12],[-11,5,12],[-11,5,12],[-9,7,12],7]+48,inf),
		\dur,Pseq([0.5,0.5,0.5,0.5,1.5,1.0,1.0,1.0,1.0,2.0,0.5],inf),
		\cutoff,Pstutter(11,Pn(Pseries(500,500,4),inf))
	),
	\choruscompresseffect
).play
)


//===================================================
// Depeche Mode - World In My Eyes
//---------------------------------------------------
// http://youtu.be/nhZdL4JlnxI
//===================================================

TempoClock.default.tempo = 123/60;

(
SynthDef(\fatvelocitybass,{|out= 0 freq = 440 amp = 0.1 gate=1 cutoff= 12000 rq=0.25 lagTime=0.01 pan = 0.0|

	var lfo, osc, filter, env;

	var basefreq =  ((freq.lag(lagTime).cpsmidi)+[0,11.95,31.03]).midicps;

	osc = Saw.ar(basefreq,[0.5,0.4,0.1])+PinkNoise.ar(Line.kr(1.0,0,0.03));

	env = EnvGen.ar(Env.adsr(0.01,1.0,1.0,0.25),gate,doneAction:2);

	filter = BLowPass4.ar(osc,100+((amp.squared)*(freq+cutoff)),rq);

	Out.ar(out,Pan2.ar(Mix(filter)*env*amp*0.8,pan));

}).add
)

(
PmonoArtic(
	\fatvelocitybass,
	\midinote,Pseq([13,18,3,1,3,1,3,1,4,1,3]+36,inf),
	\dur,Pseq([0.5,0.5,0.5,0.5,1.0,0.5,1.5,0.5,1.0,0.5,1.0],inf),
	\amp,Pseq([0.7,1.0,0.5,0.6,0.4,0.7,0.8,0.3,0.6,0.4,0.7],inf),
	\cutoff,3000,
	\rq,0.1
).play
)


//===================================================
// DAF - Der Mussolini
// implementation by Rukano: http://sccode.org/1-J
//---------------------------------------------------
// http://youtu.be/eYcUGO-ISXQ
//===================================================
// approx 63 bpm
TempoClock.default.tempo = 63/60;
(
SynthDef(\daf_bass,{ |out, freq=440, sustain=1, gate=1, amp=0.1|
	var snd, env, fenv, harm;
	harm = [1,1.01,2,2.02,3.5,4.01,5.501];
	harm = harm ++ (harm*2);
	snd = SinOsc.ar(freq*harm).sum.distort * 2;
	snd = snd + SinOsc.ar(freq / [1, 2]).sum!2;
	env = EnvGen.kr(Env.adsr(0.001,0.2,0.9,0.25), gate, amp, doneAction:2);
	snd = snd * env;
	OffsetOut.ar(out, (snd!2));
}).add;
)
(
Pdef(\m_2,
	Pbind(
		\instrument, \daf_bass,
		\scale, Scale.minor,
		\octave, [2,3], // try out [2,3] or [3,4] for octave bass leetness
		\ctranspose,Pseq([ Pn(-1,16*4), Pn(1,16*2) ], inf),
		\degree, Pseq([1, 4, 1, 10, 1, 8, 1, 1, 8, 1, 8, 1, 8, 7, 1, 8]-1,inf),
		\legato, Pwhite(0.75, 0.8),
		\dur, 0.2,
		\amp, 0.01
	)
).play;
)

