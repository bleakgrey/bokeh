public class App.Layer : Object {

	public string name { get; set; default = _("New Layer"); }

	public bool removable { get; set; default = true; }
	public bool togglable { get; set; default = true; }

	public virtual void on_added () {}
	public virtual void on_removed () {}

}
