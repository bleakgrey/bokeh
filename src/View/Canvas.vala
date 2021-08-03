using Gtk;

public class App.View.Canvas : Adw.Bin {

	public File? file { get; set; }

	protected Picture picture;

	construct {
		notify["file"].connect (on_file_changed);

		picture = new Picture () {
			halign = Align.CENTER,
			valign = Align.CENTER
		};
		child = picture;
	}

	void on_file_changed () {
		picture.file = file;
	}

}
