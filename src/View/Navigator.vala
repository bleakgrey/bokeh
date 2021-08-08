using Gtk;

public class App.View.Navigator : Adw.Bin {

	protected View.Canvas target { get; set; }

	protected ScrolledWindow scroller;
	protected CenterBox center_box;

	construct {
		center_box = new CenterBox () {
			valign = Align.CENTER,
			halign = Align.CENTER
		};
		scroller = new ScrolledWindow () {
			overlay_scrolling = true
		};
		scroller.child = center_box;
		this.child = scroller;
	}

	public Navigator (View.Canvas target) {
		this.target = target;
		this.center_box.set_center_widget (target);
	}

	public void on_visible_rect_changed () {
		return_if_fail (target != null);

		var rect = Graphene.Rect ();
		var x = this.scroller.get_hadjustment ().value;
		var y = this.scroller.get_vadjustment ().value;

		var w = scroller.get_width ();
		var h = scroller.get_height ();

		rect.init ((float) x, (float) y, w, h);

		target.visible_rect = rect;
		//warning (@"pos($(rect.get_x()),$(rect.get_y())) / size ($(rect.size.width),$(rect.size.height))");
	}

	public override void snapshot (Snapshot snapshot) {
		on_visible_rect_changed ();
		base.snapshot (snapshot);
	}

}
