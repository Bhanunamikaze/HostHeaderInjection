import http.server
import ssl
import urllib.parse
import cgi

class MyHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urllib.parse.urlparse(self.path)
        message_parts = [
            'CLIENT VALUES:',
            f'client_address={self.client_address!r}',
            f'requestline={self.requestline!r}',
            f'path={self.path!r}',
            f'real path={parsed_path.path!r}',
            f'query={parsed_path.query!r}',
            f'REQUEST HEADERS:',
            f'{self.headers!r}',
            'SERVER VALUES:',
            f'server_version={self.server_version!r}',
            f'sys_version={self.sys_version!r}',
            f'protocol_version={self.protocol_version!r}',
        ]
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        self.wfile.write('\n'.join(message_parts).encode('utf-8'))
        print(f'\nGET Response:\n{str(self.headers)}\n')

    def do_POST(self):
        ctype, pdict = cgi.parse_header(self.headers['content-type'])
        if ctype == 'multipart/form-data':
            postvars = cgi.parse_multipart(self.rfile, pdict)
        elif ctype == 'application/x-www-form-urlencoded':
            length = int(self.headers['content-length'])
            postvars = urllib.parse.parse_qs(self.rfile.read(length), keep_blank_values=1)
        else:
            postvars = {}
        message_parts = [
            'CLIENT VALUES:',
            f'client_address={self.client_address!r}',
            f'requestline={self.requestline!r}',
            f'path={self.path!r}',
            f'REQUEST HEADERS:',
            f'{self.headers!r}',
            'POST VALUES:'
        ]
        for key, value in postvars.items():
            message_parts.append(f'{key}={value}')
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        self.wfile.write('\n'.join(message_parts).encode('utf-8'))
        print(f'\nPOST Response:\n{str(self.headers)}\n')
        print(f'POST Response Data:\n{str(postvars)}\n')

    def log_message(self, format, *args):
        print(f'{self.address_string()} - - [{self.log_date_time_string()}] {format % args}')

def run(server_class=http.server.HTTPServer, handler_class=MyHandler):
    server_address = ('localhost', 443)
    httpd = server_class(server_address, handler_class)
    httpd.socket = ssl.wrap_socket(httpd.socket,
                                   certfile='new/server.crt',keyfile="new/server.key", 
                                   server_side=True)
    print(f'Starting httpd on {server_address}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()
