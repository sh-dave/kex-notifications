package kex;

import kex.text.TextLayout;
import kex.text.TextLayouter;

typedef NotificationOpts = {
	colorScheme: ColorScheme,
}

class Notification {
	public static var ErrorColorScheme = {
		bgColor: kha.Color.fromBytes(0xb5, 0x04, 0x00, 0xff),
		hlColor: kha.Color.fromBytes(0xff, 0x0a, 0x00, 0xff),
		shadowColor: kha.Color.fromBytes(0x80, 0x00, 0x00, 0xff),
	}

	public var content(default, null): TextLayout;
	public var active(default, null) = false;
	public var colorScheme(default, null): ColorScheme;

	public var fontSize = 24; // TODO (DK) via config; not public

	var message: String;

	public function new( opts: NotificationOpts ) {
		this.colorScheme = opts.colorScheme;
	}

	public function layout( font: kha.Font, message: String ) {
		this.message = message;

		var areaWidth = kha.System.windowWidth() * 0.8; // TODO (DK) via config

		var fontInfo = {
			width: font.width.bind(fontSize, _),
			height: font.height.bind(fontSize),
		} // TODO (DK) via config

		this.content = new TextLayouter().layout(message, fontInfo, areaWidth);
		active = true;
		return this;
	}
}
