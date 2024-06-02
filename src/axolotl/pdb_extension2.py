import pdb,sys,bdb
import os
try:
    import remote_pdb
except ImportError:
    print('You need to install remote-pdb: pip install remote-pdb')
    sys.exit(1)
import errno
import logging
import os
import re
import time
import socket
import sys
import threading
from pdb import Pdb

class RemotePdb(remote_pdb.RemotePdb):
    """
    RemotePdb(host='0.0.0.0', port=4444).set_trace()

    Then run: telnet 127.0.0.1 4444 or nc -C 127.0.0.1 4444
    """
    active_instance = None

    def __init__(self, host, port, patch_stdstreams=False, quiet=False):
        self._quiet = quiet
        self.listen_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.listen_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
        self.listen_socket.bind((host, port))
        if not self._quiet:
            print("RemotePdb session open at %s:%s, waiting for connection ..." % self.listen_socket.getsockname())
        self.listen_socket.listen(1)
        self.connection = None
        self.address = None
        self.handle = None

        self._start_listener_thread()

        self.backup = []
        if patch_stdstreams:
            for name in (
                    'stderr',
                    'stdout',
                    '__stderr__',
                    '__stdout__',
                    'stdin',
                    '__stdin__',
            ):
                self.backup.append((name, getattr(sys, name)))
                setattr(sys, name, self.handle)
        RemotePdb.active_instance = self

    def _start_listener_thread(self):
        listener_thread = threading.Thread(target=self._accept_connection)
        listener_thread.daemon = True
        listener_thread.start()

    def _accept_connection(self):
        self.connection, self.address = self.listen_socket.accept()
        if not self._quiet:
            print("RemotePdb accepted connection from %s." % repr(self.address))
        self.handle = remote_pdb.LF2CRLF_FileWrapper(self.connection)
        Pdb.__init__(self, completekey='tab', stdin=self.handle, stdout=self.handle)

    def valid(self, ):
        if self.handle is None:
            while self.handle is None:
                print(" \033[91m RemotePdb is not connected yet. ", "RemotePdb session open at %s:%s, waiting for connection ... \033[0m" % self.listen_socket.getsockname())
                time.sleep(5)

    def set_trace(self, frame=None):
        self.valid()
        if frame is None:
            frame = sys._getframe().f_back
        try:
            pdb.Pdb.set_trace(self, frame)
        except IOError as exc:
            if exc.errno != errno.ECONNRESET:
                raise

    def post_mortem(self, t=None):
        self.valid()
        # handling the default
        if t is None:
            # sys.exc_info() returns (type, value, traceback) if an exception is
            # being handled, otherwise it returns None
            t = sys.exc_info()[2]
        if t is None:
            raise ValueError("A valid traceback must be passed if no "
                            "exception is being handled")
        
        self.reset()
        self.interaction(None, t)

if not os.getenv(f'pdb{os.environ.get("LOCAL_RANK", 0)}'):
    _pdb = RemotePdb('127.0.0.1', 16457+int(os.environ.get('LOCAL_RANK', 0)))
    os.environ[f'pdb{os.environ.get("LOCAL_RANK", 0)}'] = str(16457+int(os.environ.get('LOCAL_RANK', 0)))
    pdb.set_trace = _pdb.set_trace
    pdb.post_mortem = _pdb.post_mortem
    # then we nc -C 127.0.0.1 16457
print(int(os.environ.get('LOCAL_RANK', 0)))

