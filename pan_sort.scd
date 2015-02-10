SynthDef(\panned_sine, {|freq=440,pan=0,amp=0.1,out=0,gate=1|
	var sig, env;

	env = EnvGen.kr(Env([0.1,1.0,0.1],[1,1]),gate,amp,doneAction:2);
	sig = env * FSinOsc.ar(freq,0,1);
	Out.ar(out,Pan2.ar(sig,pan));
}).load(s)


a = {Synth(\panned_sine,[\freq,{rrand(220,550)},\pan,{rrand(-1.0,1.0)},\amp,{rrand(0.01,0.1)}])};

(
{
	var random_array = Array.fill(20, {rrand(-1.0,1.0)});

	random_array.do{|i|
		(i.asString).postln;
		Synth(\panned_sine,[\freq, {rrand(220,550)},\pan, i,\amp,{rrand(0.01,0.1)}]);
		0.1.wait;
	}
}.fork
)


(
{
	var sine_array, sine_synth;

	sine_synth = {Synth(\panned_sine,
		[
			\freq,{rrand(220,550)},
			\pan,{rrand(-1.0,1.0)},
			\amp,{rrand(0.01,0.1)}
		])
	};

	= Array.fill(20, {Synth})

}.fork
)