package kex.notifications;

import kha.Canvas;
import kha.Color;
import kha.Font;
import kha.graphics2.Graphics;
import kex.text.*;

typedef NotificationUiOpts = {
	final font: Font;
	final fontSize: Int;
	final traceErrors: Bool;
	final ?maxCharactersPerLine: Int;
}

class NotificationUi {
	public static final ErrorColorScheme: ColorScheme = {
		bgColor: Color.fromBytes(0xb5, 0x04, 0x00, 0xff),
		hlColor: Color.fromBytes(0xff, 0x0a, 0x00, 0xff),
		shadowColor: Color.fromBytes(0x80, 0x00, 0x00, 0xff),
	}

	final font: Font;
	final fontSize: Int;
	final traceErrors: Bool;
	final maxCharactersPerLine: Int;

	var notifications: Array<Notification> = [];

	public function new( opts: NotificationUiOpts ) {
		this.font = opts.font;
		this.fontSize = opts.fontSize;
		this.traceErrors = opts.traceErrors;
		this.maxCharactersPerLine = opts.maxCharactersPerLine != null ? opts.maxCharactersPerLine : 120;
	}

	inline function getStyle( ?opts: NotificationStyle ) : NotificationStyle
		return opts != null
			? opts
			: {
				colorScheme: ErrorColorScheme,
				fontSize: fontSize,
			}

	public function error( message: String, ?style: NotificationStyle ) {
		if (traceErrors) {
			trace('[ERROR]: $message');
		}

		notifications.push(new Notification(message, getStyle(style), true, false));
	}

	public function createSticky( ?style: NotificationStyle ) : NotificationHandle {
		var n = new Notification('', getStyle(style), false, true);
		notifications.push(n);
		return n;
	}

	public function stick( h: NotificationHandle, message: String ) {
		var n: Notification = h;
		n.message = message;
		n.content = None;
		n.active = true;
		n.sticky = true;

		if (traceErrors) {
			trace('[alert] ${n.message}');
		}
	}

	public function resolveSticky( h: NotificationHandle ) {
		var n: Notification = h;
		n.active = false;

		if (traceErrors) {
			trace('[/alert] ${n.message}');
		}
	}

	public function clearMessages( ?clearSticky = false ) {
		notifications = notifications.filter(n -> n.sticky ? !clearSticky : false);
	}

	public function render( canvas: Canvas ) {
		var g2 = canvas.g2;
		g2.begin(false);
			draw(g2, canvas.width, canvas.height);
		g2.end();
	}

	function draw( g2: Graphics, w, h ) {
		var y = 4.0;

		for (n in notifications) {
			if (n.active) {
				y = drawMessageContent(g2, w, h, y, n);
				y += 4;
			}
		}
	}

	function drawMessageContent( g2: Graphics, ww, wh, y, n: Notification ) : Float {
		switch n.content {
			case None:
				layout(n, font, ww);
				return drawMessageContent(g2, ww, wh, y, n);
			case Some(content):
				var height = content.height;
				var x = (ww - content.width) * 0.5;

				g2.color = n.colorScheme.hlColor;
				g2.fillRect(0, y, ww, 1);
				g2.color = n.colorScheme.bgColor;
				g2.fillRect(0, y + 1, ww, height);
				g2.color = n.colorScheme.shadowColor;
				g2.fillRect(0, y + height + 1, ww, 1);
				g2.color = Color.White;
				g2.font = font;
				g2.fontSize = n.fontSize;

				for (i in 0...content.lines.length) {
					var line = content.lines[i];
					g2.drawString(line.content, x, y);
					y += content.lineHeight;
				}

				return y;
		}
	}

	function layout( n: Notification, font: Font, maxWidth: Int ) {
		var fontInfo = {
			width: font.width.bind(fontSize, _),
			height: font.height.bind(fontSize),
		}

		n.content = Some(new TextLayouter({ maxCharactersPerLine: maxCharactersPerLine }).layout(n.message, fontInfo, maxWidth));
	}
}
