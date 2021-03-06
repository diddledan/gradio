/* This file is part of Gradio.
 *
 * Gradio is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Gradio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Gradio.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gdk;

namespace Gradio{
	public class Collection : GLib.Object, Gd.MainBoxItem{
		private string _name;
		private string _id;
		private string _uri;
		private bool _pulse;
		private int64 _mtime;

		private Cairo.Surface _icon;
		private Thumbnail _thumbnail;

		public StationModel station_model;

		public string id {
			get{return _id;}
		}

		public string name {
			get{return _name;}
		}

		public string uri {
			get{return _uri;}
		}

		public string primary_text {
			get{
				return _name;
			}
		}

		public string secondary_text {
			get{return "";}
		}

		public bool pulse {
			get{return _pulse;}
		}

		public int64 mtime {
			get{return _mtime;}
		}

		public Cairo.Surface icon {
			get{
				if(_thumbnail == null){
					_thumbnail = new Thumbnail.for_collection(Settings.icon_zoom, this);
					_thumbnail.updated.connect(() => {
						_icon = _thumbnail.surface;
						notify_property("icon");
					});
					_thumbnail.show_empty_box();
					return _icon;
				}
				return _icon;
			}
		}

		public Collection(string n, string i){
			_name = n;
			_id = i;

			station_model = new StationModel();

			App.window.icon_zoom_changed.connect(() => {
				update_thumbnail();
			});
		}

		private void update_thumbnail(){
			if(_thumbnail != null && this != null){
				_thumbnail.set_zoom(Settings.icon_zoom);
			}
		}

		public void add_station(RadioStation station){
			station_model.add_station(station);
		}

		public void remove_station(RadioStation station){
			station_model.remove_station(station);
		}

		public void show_details(){
			App.window.details_box.set_collection(this);
		}
	}
}
