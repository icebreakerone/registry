
import os.path
from http.server import SimpleHTTPRequestHandler, HTTPServer

# TODO: Do content negotiation, not just blindly appending .html to paths underneath the handler

class HackyHandler(SimpleHTTPRequestHandler):
    def translate_path(self, path):
      p = super().translate_path(path)
      if not os.path.exists(p):
        p = p + '.html'
      return p

if __name__ == "__main__":        
    server = HTTPServer(("0.0.0.0", 7070), HackyHandler)
    print("Test server started http://0.0.0.0:7070")

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass

    server.server_close()
    print("Server stopped.")