class_name sfx
extends RefCounted

const MIX_RATE := 22050


## A short tone with a linear fade-out.Square waves sound retro.
static func tone(frequency: float, duration: float, volume: float = 0.3, square: bool = false) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	var sample_count := int(MIX_RATE * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	for i in sample_count:
		var t := float(i) / float(MIX_RATE)
		var envelope := 1.0 - t / duration
		var wave := sin(TAU * frequency * t)
		if square:
			wave = signf(wave)
		data.encode_s16(i * 2, int(clampf(wave * envelope * volume, -1.0, 1.0) * 32767.0))
	stream.data = data
	return stream


## A short noise burst, good for impacts.
static func noise(duration: float, volume: float = 0.25) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	var sample_count := int(MIX_RATE * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	for i in sample_count:
		var envelope := 1.0 - float(i) / float(sample_count)
		var wave := randf_range(-1.0, 1.0)
		data.encode_s16(i * 2, int(clampf(wave * envelope * volume, -1.0, 1.0) * 32767.0))
	stream.data = data
	return stream
