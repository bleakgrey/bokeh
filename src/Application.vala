using Gtk;

namespace App {

	public static Library library;

	public class Instance : Gtk.Application {

		construct {
			application_id = Build.DOMAIN;
			flags = ApplicationFlags.HANDLES_OPEN;
		}

		public static int main (string[] args) {
			Gtk.init ();

			library = new Library ("/home/user/Documents/Apps/bokeh/data/library");

			var app = new Instance ();
			return app.run (args);
		}

		protected override void startup () {
			base.startup ();
			add_window (new Window.Main ());
		}

		protected override void activate () {
			base.activate ();
		}

		public override void open (File[] files, string hint) {
			base.open (files, hint);
		}

	}

}
