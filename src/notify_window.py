from gi.repository import Adw
from gi.repository import Gtk
import sys


def printerr(*args):
    print(*args, file=sys.stderr)

def printinfo(*args):
    print(*args, file=sys.stdout)

@Gtk.Template(resource_path='/io/github/aerocyber/sitemarker/notify_window.ui')
class NotifyWindow(Adw.Window):
    __gtype_name__ = 'NotifyWindow'

    info_label = Gtk.Template.Child()

    def __init__(self, message, **kwargs):
        super().__init__(**kwargs)
        self.info_label.set_text(message)
