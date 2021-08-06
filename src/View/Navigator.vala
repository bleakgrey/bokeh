using Gtk;

public class App.View.Navigator : Adw.Bin {

	protected ScrolledWindow scroller;
	protected CenterBox center_box;

	construct {
		center_box = new CenterBox () {
			valign = Align.CENTER,
			halign = Align.CENTER
		};
		scroller = new ScrolledWindow ();
		scroller.child = center_box;
		this.child = scroller;
	}

	public Navigator (Gtk.Widget target) {
		center_box.set_center_widget (target);
	}

}
