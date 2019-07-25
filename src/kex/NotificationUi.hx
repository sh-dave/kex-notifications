package kex;

import kex.Notification;
import kha.Canvas;
import kha.Font;
import kha.graphics2.Graphics;

typedef NotificationUiOpts = {
	final font: Font;
	final traceErrors: Bool;
}

class NotificationUi {
	public final traceErrors: Bool;

	public function new( opts: NotificationUiOpts ) {
		this.font = opts.font;
		this.traceErrors = opts.traceErrors;
	}

	var font: Font;
	var notifications: Array<Notification> = [];

	public function error( message: String ) {
		if (traceErrors) {
			trace('[ERROR]: $message');
		}

		var n = new Notification({ colorScheme: Notification.ErrorColorScheme });
		prepare(n, message);
		notifications.push(n);
	}

	public function createSticky( opts: NotificationOpts ) : StickyNotification {
		var n = new StickyNotification(this, { colorScheme: opts.colorScheme });
		notifications.push(n);
		return n;
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

	function prepare( n: Notification, message: String )
		n.layout(font, message);

	function drawMessageContent( g2: Graphics, ww, wh, y, n: Notification ) : Float {
		var content = n.content;
		var height = content.height;
		var x = (ww - content.width) * 0.5;

		g2.color = n.colorScheme.hlColor;
		g2.fillRect(0, y, ww, 1);
		g2.color = n.colorScheme.bgColor;
		g2.fillRect(0, y + 1, ww, height);
		g2.color = n.colorScheme.shadowColor;
		g2.fillRect(0, y + height + 1, ww, 1);
		g2.color = kha.Color.White;
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
