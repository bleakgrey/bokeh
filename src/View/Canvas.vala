using Gtk;

public class App.View.Canvas : Adw.Bin {

	public Project? project { get; set; }

	Picture picture;

	construct {
		notify["project"].connect (on_project_changed);

		picture = new Picture () {
			halign = Align.CENTER,
			valign = Align.CENTER
		};
		child = picture;
	}

	void on_project_changed () {
		picture.file = project == null ? null : project.source_file;
	}

}
