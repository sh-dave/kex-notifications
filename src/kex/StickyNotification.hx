package kex;

import kex.Notification;
import kex.NotificationUi;

class StickyNotification extends Notification {
	var nui: NotificationUi;

	public function new( nui: NotificationUi, opts: NotificationOpts ) {
		super(opts);
		this.nui = nui;
	}

	public function alert( message: String ) {
		if (nui.traceErrors) {
			trace('[alert] $message');
		}

		@:privateAccess nui.prepare(this, message);
	}

	public function resolve() {
		if (nui.traceErrors) {
			trace('[/alert] $message');
		}

		active = false;
	}
}
