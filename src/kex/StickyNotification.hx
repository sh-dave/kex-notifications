package kex;

import kex.Notification;
import kex.Notifications;

class StickyNotification extends Notification {
	var nui: NotificationUi;

	public function new( nui: NotificationUi, opts: NotificationOpts ) {
		super(opts);
		this.nui = nui;
	}

	public function alert( message: String ) {
		trace('[alert] $message');
		@:privateAccess nui.prepare(this, message);
	}

	public function resolve() {
		trace('[/alert] $message');
		active = false;
	}
}
