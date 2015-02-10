// basic syntax
// - mul, add arguments



SynthDef(\test_saw, {|freq=440,amp=0.1,gate=1,out=0|
	var sig, env;

	env = EnvGen.kr(Env.asr(0.1,amp,1.1),gate, doneAction:2);
	sig = env * Saw.ar(freq,1,0);

	Out.ar(out,sig)

}).load(s)


s = Server.internal.boot
Server.default = Server.internal
s.default

// ---------------
// EQUIVALENT CODE
// ---------------
a = {SinOsc.ar}.play // check the helpfile for the function .play method
a.free;
// ---------------
SynthDef(\sin_test, {
	Out.ar(0, Linen.kr * SinOsc.ar)
}).load(s);
a = Synth(\sin_test);
a.free
//================
n = s.nextNodeID;
s.sendMsg(\s_new, \sin_test, n, 0, 1); // "/s_new", "/sin_test"
s.sendMsg(\n_set, n, \gate, 0);
s.sendMsg(\n_free, n)

