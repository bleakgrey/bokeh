public class App.Project : Object {

	protected Window.Main? window { get; set; }

	public Gdk.Texture source { get; set; }
	public File file { get; set; }

	public GLib.ListStore layers { get; set; default = new GLib.ListStore (typeof(Layer)); }

	public Project (File file) {
		this.file = file;
	}

	public void load (Window.Main win) {
		message ("Loading project: "+file.get_path ());

		this.source = Gdk.Texture.from_file (file);

		this.window = win;
		window.project = this;

		add_layer (new SourceLayer (){
			name = _("Source File"),
			removable = false,
			togglable = false
		});

		// DEBUG STUFF, REMOVE LATER
		// add_layer (new ShaderLayer (){
		// 	shader_name = "vignette"
		// });
		// add_layer (new ShaderLayer (){
		// 	shader_name = "vignette"
		// });
		// add_layer (new ShaderLayer (){
		// 	shader_name = "vignette"
		// });
		// add_layer (new ShaderLayer (){
		// 	shader_name = "invert"
		// });
	}

	public void add_layer (Layer layer) {
		//layers.append (layer);
		layers.insert (0, layer);
		layer.on_added (window);
	}

	public void remove_layer (Layer layer) {
		uint pos = 0;
		layers.find (layer, out pos);
		layers.remove (pos);

		layer.on_removed ();
	}

}
