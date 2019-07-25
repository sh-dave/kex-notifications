package kex;

import haxe.ds.Option;
import kex.text.TextLayout;
import kex.text.TextLayouter;

typedef NotificationOpts = {
	final colorScheme: ColorScheme;
	final fontSize: Int;
	final ?traceErrors: Bool;
}

class Notification {
	public static var ErrorColorScheme = {
		bgColor: kha.Color.fromBytes(0xb5, 0x04, 0x00, 0xff),
		hlColor: kha.Color.fromBytes(0xff, 0x0a, 0x00, 0xff),
		shadowColor: kha.Color.fromBytes(0x80, 0x00, 0x00, 0xff),
	}

	public var content(default, null): Option<TextLayout> = None;
	public var active(default, null) = false;
	public var colorScheme(default, null): ColorScheme;
	public final fontSize: Int;

	var traceErrors: Bool;
	var message: String;

	public function new( message: String, opts: NotificationOpts ) {
		this.message = message;
		this.colorScheme = opts.colorScheme;
		this.fontSize = opts.fontSize;
		this.active = true;
		this.traceErrors = opts.traceErrors;
	}

	public function layout( font: kha.Font, maxWidth: Int ) {
		var fontInfo = {
			width: font.width.bind(fontSize, _),
			height: font.height.bind(fontSize),
		}

		this.content = Some(new TextLayouter({ maxCharactersPerLine: 120 }).layout(message, fontInfo, maxWidth));
		active = true;
		return this;
	}
}
