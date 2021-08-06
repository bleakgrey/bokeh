using Gtk;

namespace App {

	public static Library library;
	public static Window.Main? main_window;

	public class Instance : Gtk.Application {

		construct {
			application_id = Build.DOMAIN;
			flags = ApplicationFlags.HANDLES_OPEN;
		}

		public static int main (string[] args) {
			Intl.setlocale ();
			Gtk.init ();
			var gtk_settings = Gtk.Settings.get_default ();
			gtk_settings.gtk_theme_name = "Adwaita-dark";

			library = new Library ("/home/user/Documents/Apps/bokeh/data/library");

			var app = new Instance ();
			return app.run (args);
		}

		protected override void startup () {
			base.startup ();
			main_window = new Window.Main ();
			add_window (main_window);
		}

		protected override void activate () {
			base.activate ();
		}

		public override void open (File[] files, string hint) {
			base.open (files, hint);
			main_window.load_project (files[0]);
		}

	}

}
