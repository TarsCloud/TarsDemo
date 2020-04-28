import requests

STATUS_ACTIVE = 'active'

class TestUtils():
    def __init__(self, app_name, web_url):
        self._tree_node_id = ''
        self._app_name = app_name
        self._web_url = web_url
        self._init_tree_node_id()

    # get tree node id of test application
    def _init_tree_node_id(self):
        url = '{0}/api/tree'.format(self._web_url)
        try:
            resp = requests.get(url)
            resp.encoding = 'utf-8'
            if resp.ok is True and resp.status_code == 200:
                apps = resp.json()
                for app in apps['data']:
                    if app['name'] == self._app_name:
                        self._tree_node_id = app['id']
            if self._tree_node_id == '':
                raise Exception('Get application tree node failed.')
        except BaseException:
            return exit(255, "Failed to read application tree node")

    # get server list which contains server details and current status
    def _get_server_list(self):
        url = '{0}/api/server_list'.format(self._web_url)
        data = {'tree_node_id': self._tree_node_id}
        try:
            resp = requests.get(url, data)
            resp.encoding = 'utf-8'
            resp.encoding = 'utf-8'
            if resp.ok is True and resp.status_code == 200:
                resp = resp.json()
                return resp['data']
            return []
        except BaseException:
            return []
    
    # check if server is ready for test
    def is_server_activated(self, server_name):
        servs = self._get_server_list()
        for serv in servs:
            if serv['server_name'] == server_name:
                return serv['present_state'] == STATUS_ACTIVE
        return False