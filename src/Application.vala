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
			Build.print_info ();

			Gtk.init ();
			var gtk_settings = Gtk.Settings.get_default ();
			gtk_settings.gtk_theme_name = "Adwaita-dark";

			library = new Library ("/home/user/Documents/Apps/bokeh/data/library");

			var app = new Instance ();
			return app.run (args);
		}

		protected override void startup () {
			base.startup ();
			setup_actions ();

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

		protected void setup_actions () {
			var about_action = new SimpleAction ("about", null);
			about_action.activate.connect (v => {
				show_about_dialog ();
			});

			add_action (about_action);
			set_accels_for_action ("app.about", { "F1" });
		}

		protected void show_about_dialog () {
			var dialog = new AboutDialog () {
				transient_for = this.get_active_window (),
				modal = true,

				logo_icon_name = Build.DOMAIN,
				program_name = Build.NAME,
				version = Build.VERSION,
				website = Build.SUPPORT_WEBSITE,
				website_label = _("Report an issue"),
				license_type = License.GPL_3_0_ONLY,
				copyright = Build.COPYRIGHT,
				system_information = Build.SYSTEM_INFO
			};

			dialog.authors = Build.get_authors ();
			//dialog.artists = Build.get_artists ();
			dialog.translator_credits = Build.TRANSLATOR != " " ? Build.TRANSLATOR : null;
			dialog.present ();
		}

	}

}
