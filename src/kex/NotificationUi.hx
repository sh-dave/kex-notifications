package kex;

import kex.Notification;
import kha.graphics2.Graphics;

typedef NotificationUiOpts = {
	public var font: kha.Font;
}

class NotificationUi {
	public function new( opts: NotificationUiOpts ) {
		this.font = opts.font;
	}

	var font: kha.Font;
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

	public function render( canvas: kha.Canvas ) {
		var g2 = canvas.g2;
		g2.begin(false);
			draw(g2);
		g2.end();
	}

	public function draw( g2: Graphics ) {
		for (n in notifications) {
			if (n.active) {
				drawMessageContent(g2, n);
			}
		}
	}

	function prepare( n: Notification, message: String )
		n.layout(font, message);

	function drawMessageContent( g2: Graphics, n: Notification ) {
		var content = n.content;
		var ww = kha.System.windowWidth();
		var wh = kha.System.windowHeight();
		var height = content.height;
		var top = (wh - height) * 0.5;
		var y = 0.0; // TODO (DK) better name
		var x = (ww - content.width) * 0.5; // TODO (DK) better name

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
