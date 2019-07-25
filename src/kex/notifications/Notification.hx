package kex.notifications;

import haxe.ds.Option;
import kex.text.TextLayout;

class Notification {
	public var content: Option<TextLayout> = None;
	public var message: String;
	public var active: Bool;
	public var sticky: Bool;
	public final colorScheme: ColorScheme;
	public final fontSize: Int;

	public function new( message: String, style: NotificationStyle, active, sticky ) {
		this.message = message;
		this.colorScheme = style.colorScheme;
		this.fontSize = style.fontSize;
		this.active = active;
		this.sticky = sticky;
	}
}
