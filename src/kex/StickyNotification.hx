package kex;

import kex.Notification;
import kex.NotificationUi;

class StickyNotification extends Notification {
	public function new( opts: NotificationOpts ) {
		super('', opts);
		active = false;
	}

	public function alert( message: String ) {
		if (traceErrors) {
			trace('[alert] $message');
		}

		this.message = message;
		this.active = true;
	}

	public function resolve() {
		if (traceErrors) {
			trace('[/alert] $message');
		}

		active = false;
	}
}
