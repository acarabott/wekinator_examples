// SynthDef to analyse audio signal for amplitude
(
SynthDef(\amplitudeAnalysis, {|in=0, rate=60|
	var input = SoundIn.ar(in);        // get the audio signal
	var amp = Amplitude.kr(input);     // analyse the amplitude
	var trig = Impulse.kr(rate);       // trigger for how often to send data

	SendReply.kr(trig, '/amp', [amp]); // send the data back to sclang
                                     // '/amp' is the OSC address to listen for
}).add;
);

// an instance of the Synth
~mySynth = Synth(\amplitudeAnalysis);

// The network address and port to send OSC data to
// The port should match the one set in Wekinator
~wekNetAddr = NetAddr("127.0.0.1", 6448);

// The listener for the analysis data
// Receives messages from the audio server, sends them to Wekinator

(
OSCdef(\listener, {|msg|
	var amp = msg[3]; // get the amplitude data from the message
	~wekNetAddr.sendMsg("/wek/inputs", amp);
}, '/amp'); // notice this key '/amp' matches that in our SynthDef
);

// change the rate of messages, you should see Wekinator's OSC In LED flash
~mySynth.set(\rate, 1);

/*
Analysis UGens to check out:
Pitch
Tartini
MFCC
KeyTrack
BeatTrack2
Chromagram
Onsets
SensoryDissonance
SpecCentroid
SpecFlatness
ZeroCrossings
*/