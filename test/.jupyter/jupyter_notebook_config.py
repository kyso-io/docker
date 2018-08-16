
c = get_config()
c.NotebookApp.ip = u'0.0.0.0'
c.NotebookApp.token = u''
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.tornado_settings = {
  'headers': {
    'Content-Security-Policy': 'frame-ancestors *',
    'static_url_prefix': '/static/'
  }
}
c.Application.log_level = 'DEBUG'

c.Session.debug = True
