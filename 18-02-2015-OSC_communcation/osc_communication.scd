OSCdef.trace(true)


(
OSCdef(\demo,
	{
	|msg, time, addr, recv|
		"time: % \n".postf(time);
		"msg: % \n".postf(msg);
		(\degree: msg[1], \dur : 1).play;
	msg.postln;

},"/foo",
recvPort:57100)
)


Nick : 10.0.9.105

n = NetAddr.new("10.0.9.185",57100);
n.sendMsg("/foo", 0.3)

{
n.sendMsg("/foo", 3, 0.3);
	0.5.wait
}.fork

algorithms 2005/6
2 keys algorithm