package kex;

import kex.Notification;
import kha.Canvas;
import kha.Font;
import kha.graphics2.Graphics;

typedef NotificationUiOpts = {
	final font: Font;
}

class NotificationUi {
	public function new( opts: NotificationUiOpts ) {
		this.font = opts.font;
	}

	var font: Font;
	var notifications: Array<Notification> = [];

	public function error( message: String ) {
		trace('[ERROR]: $message');
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
		for (n in notifications) {
			if (n.active) {
				drawMessageContent(g2, w, h, n);
			}
		}
	}

	function prepare( n: Notification, message: String )
		n.layout(font, message);

	function drawMessageContent( g2: Graphics, ww, wh, n: Notification ) {
		var content = n.content;
		var height = content.height;
		var top = (wh - height) * 0.5;
		var y = 0.0;
		var x = (ww - content.width) * 0.5;

		g2.color = n.colorScheme.hlColor;
		g2.fillRect(0, top, ww, 1);
		g2.color = n.colorScheme.bgColor;
		g2.fillRect(0, top + 1, ww, height);
		g2.color = n.colorScheme.shadowColor;
		g2.fillRect(0, top + height + 1, ww, 1);
		g2.color = kha.Color.White;
		g2.font = font;
		g2.fontSize = n.fontSize;

		for (i in 0...content.lines.length) {
			var line = content.lines[i];
			var lineTop = top + y;
			g2.drawString(line.content, x, lineTop);
			y += content.lineHeight;
		}
	}
}
