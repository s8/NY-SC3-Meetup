s = Server.local
o = Server.local.options
o.device = "Soundflower (2ch)"
s.boot
s.quit


// basic ideas
// - envelope
// - spectrum

// ====================================
// Subtractive
// ====================================
{Out.ar([0,1],
	RLPF.ar(
		Saw.ar(200,0.5),
		MouseX.kr(40,10000),
		MouseY.kr(1.0,0.01)
))}.play;

{Out.ar(0,
	MoogVCF.ar(
	Saw.ar(200,0.5),
	MouseX.kr(40,10000),
	MouseY.kr(0.01,1.0)
))}.play;

{Out.ar(1,
	BMoog.ar(
	Saw.ar(200,0.5),
	MouseX.kr(40,10000),
	MouseY.kr(0.01,1.0)
))}.play;

// LFO
{var env, vco, lfo, vcf;

	// vco = Saw.ar(200,0.5);
	vco = SinOsc.ar(200,0.0,0.5);
	lfo = SinOsc.ar(MouseX.kr(0.1,30), 0.0, 1000, 1000);
	vcf = MoogVCF.ar(vco, lfo, MouseY.kr(0.01,1.0));

	Out.ar(0,vcf);
}.play;


// filtering noise into sinewave
{BPF.ar(
	WhiteNoise.ar([0.5,0.5]),
	440, MouseX.kr(0.0,1.0)
)}.play

// Filter bank
{ DynKlank.ar(`[
	[800, 1071, 1153, 1723],
	nil,
	[1, 1, 1, 1]
],
	WhiteNoise.ar(0.01))
}.play;

// ====================================
// additive
// ====================================

// a bunch of sine waves
(
{
	var base_freq = 45.midicps, num_bands = 100;
	// base_freq = MouseX.kr(30,300);
	Mix.new(
		Array.fill(num_bands,{
			arg i;
			SinOsc.ar(
				// (i*MouseY.kr(0.1,10.1)+1)*base_freq,
				(i*5+1)*base_freq,
				rrand(-2pi,2pi),
				0.5/(i+1)**0.5
			)
	})).dup*0.2
}.play)

// Sine oscillator bank
(
{
	var freqs, amps, phases, num_bands = 100, base_freq = 45.midicps;

	// base_freq = MouseX.kr(30,300);
	freqs = Array.fill(num_bands,{|i| (i*5+1)*base_freq});
	phases = Array.fill(num_bands,{|i| rrand(-2pi, 2pi)*MouseY.kr(0.0, 1.0)});
	amps = Array.fill(num_bands, {|i| 0.5/(i+1)**MouseX.kr(0.1,3.0)});

    DynKlang.ar(`[
		freqs,
        amps,
		phases
		]).dup*0.2
}.play;
)


// ====================================
// FM
// ====================================
// commerical - Yamaha DX 7, native Insturments FM7/8

{
	var car, freq_mod_01, freq_mod_02, phase_mod;

	freq_mod_02 = SinOsc.ar(333, 0.0, 200);
	freq_mod_01 = SinOsc.ar(350 + freq_mod_02,0.0,20);

	car = SinOsc.ar(220 + freq_mod_01,0.0,0.5).dup;

}.play



{SinOsc.ar(400 + SinOsc.ar(MouseX.kr(2,2000,1), 0, MouseY.kr(1,1000)), 0, 0.5)!2}.play

// the same as above - with explanations:
(
{
SinOsc.ar(400 // the carrier and the carrier frequency
	+ SinOsc.ar(MouseX.kr(2,2000,1), // the modulator and the modulator frequency
		0, 						// the phase of the modulator
		MouseY.kr(1,1000) 			// the modulation depth (index)
		),
0,		// the carrier phase
0.5)		// the carrier amplitude
}.play

)

// as you can see, FM synthesis is a good example of a chaotic, non-linear function


// for phase modulation, check out the PMOsc
// phase modulation and frequency modulation is very very similar

{ PMOsc.ar(MouseX.kr(300,900), 600, 3, 0, 0.1) }.play; // modulate carfreq

{ PMOsc.ar(300, MouseX.kr(300,900), 3, 0, 0.1) }.play; // modulate modfreq

{ PMOsc.ar(300, 550, MouseX.kr(0,20), 0, 0.1) }.play; // modulate index




// FM
{PMOsc.ar(1000, 1367, 12, mul: EnvGen.kr(Env.perc(0, 0.5), Impulse.kr(1)))}.play

// compared to the Additive synthesis:
(
{
Mix.ar(
 SinOsc.ar((1000 + (1367 * (-20..20))).abs,  // we're generating 41 oscillators (see *)
  mul: 0.1*EnvGen.kr(Env.perc(0, 0.5), Impulse.kr(1)))
)}.play
)


// ====================================
// Granular
// ====================================
TGrains

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)

(
{
    var trate, dur, clk, pos, pan, rate, num_chan = 10;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
	clk = Dust.kr(trate*Array.fill(num_chan,{rrand(0.1,1.0)}));
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
	rate = Array.fill(num_chan,{|i| (i+1)**MouseY.kr(0.01,3.0)});
    pan = WhiteNoise.kr(0.6);
	Splay.ar(TGrains2.ar(2, clk, b, rate, pos, dur, pan, 0.1));
}.scope(zoom: 4);
)

// ====================================
// Ring modulation
// ====================================

{SinOsc.ar(1000, 0.0,  SinOsc.ar(500,0.0, MouseX.kr(0,1.0), MouseY.kr(0.0,3.0))).dup*0.1}.play

// ====================================
// Wave shaping
// ====================================

// ====================================
// Wavetable
// ====================================
// general midi

(
s = Server.local;
// allocate and fill tables 0 to 7
8.do({ arg i;
    var n, a;
    // allocate table
    s.sendMsg(\b_alloc, i, 1024);
    // generate array of harmonic amplitudes
    n = (i+1)**2;
    a = Array.fill(n, { arg j; ((n-j)/n).squared.round(0.001) });
    // fill table
    s.performList(\sendMsg, \b_gen, i, \sine1, 7, a);
});
)

(
SynthDef("help-VOsc",{ arg out=0, bufoffset=0;
    var x;
    // mouse x controls the wavetable position
    x = MouseX.kr(0,7);
    Out.ar(out,
        VOsc.ar(bufoffset+x, [120,121], 0, 0.3)
    )
}).play(s,[\out, 0, \bufoffset, 0]);
)

(
8.do({ arg i;
    var a;
    s.sendMsg(\b_alloc, i, 1024); // allocate table
    // generate array of harmonic amplitudes
    a = Array.fill(i, 0) ++ [0.5, 1, 0.5];
	a.postln;
    // fill table
    s.performList(\sendMsg, \b_gen, i, \sine1, 7, a);
});
)

(
8.do({ arg i;
    var a;
    s.sendMsg(\b_alloc, i, 1024); // allocate table
    // generate array of harmonic amplitudes
    a = Array.fill(32,0);
    12.do({ arg i; a.put(32.rand, 1) });
	a.postln;
    // fill table
    s.performList(\sendMsg, \b_gen, i, \sine1, 7, a);
});
)

(
8.do({ arg i;
    var a;
    s.sendMsg(\b_alloc, i, 1024); // allocate table
    // generate array of harmonic amplitudes
    n = (i+1)**2;
    a = Array.fill(n, { arg j; 1.0.rand2 });
    // fill table
    s.performList(\sendMsg, \b_gen, i, \sine1, 7, a);
});
)

// ====================================
// Karplus-Strong
// ====================================
(
{
	var burstEnv, att = 0, dec = 0.001;
	var burst, delayTime, delayDecay = 0.5;
	var midiPitch = 69; // A 440
	var pluck;
	delayTime = midiPitch.midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
	burst = PinkNoise.ar(burstEnv);
	pluck = CombL.ar(burst, delayTime, delayTime,
		delayDecay, add: burst);
	Out.ar(0, [burst, pluck])
}.play
)

(
    {Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), 440.reciprocal, 440.reciprocal, 10,
        coef:MouseX.kr(-0.999, 0.999))
    }.play(s)
)

// ====================================
// Physical Modeling / Waveguides
// ====================================

(
SynthDef(\help_dwgplucked, { |out=0, freq=440, amp=0.5, gate=1, c3=2, pan=0|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
    var son = DWGPlucked.ar(freq, amp, gate,0.1,1,c3,inp);
    DetectSilence.ar(son, 0.00001, doneAction:2);
	// Out.ar(out, Pan2.ar(son * 0.1, pan));
	Out.ar(out, [inp, son]*0.1);
}).add;
)

//Use it.
(
a = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.new([0, 0.75, 2, 3.5, 4, 5, 6, 7, 8, 9, 10, 11]),
    "Custom"
);

Pbind(
    \instrument, \help_dwgplucked,
    \scale ,a,
	// \delta , Pseq([1,0.5,0.5,0.5,0.5,0.5,0.5,1,0.5,0.5,1,1]*0.25,inf),
	\delta, 10,
    \dur, 10,
	// \degree, Pseq([1,8,8,8,8,8,8,-6,Prand([9,10,11],1),1,7,8]-8, inf),
	\degree, 1,
    \amp , Pwhite(0.2,0.8),
    //\c3 , Pseq([Pseq([1400],24),Pseq([300],24)],inf),
    \pan , Pwhite(-1,1),
).play;
)




// ====================================
// Chaos
// ====================================

//FitzHughNagumo
{Out.ar(0,Pan2.ar(0.1*FitzHughNagumo.ar(Impulse.kr(100),MouseX.kr(0.0001,1,'exponential'),MouseY.kr(0.0001,1,'exponential'),0.5,0.1,SinOsc.kr(10,0,0.3),SinOsc.kr(10,0,0.8)),0.0))}.play

//GENDY storm
(
{
var n;
n=15;

0.5*Mix.fill(n,{
var freq, numcps;

freq= rrand(130,160.3);
numcps= rrand(2,20);
Pan2.ar(Gendy3.ar(6.rand,6.rand,10.0.rand,10.0.rand,freq*exprand(1.0,2.0), 10.0.rand, 10.0.rand, numcps, SinOsc.kr(exprand(0.02,0.2), 0, numcps/2, numcps/2), 0.5/(n.sqrt)), 1.0.rand2)
});
}.play
)

// FNSine
{ FBSineC.ar(SampleRate.ir, 1, 0, XLine.kr(1, 2, 10), 0.1) * 0.2 }.play(s);

