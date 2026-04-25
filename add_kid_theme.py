import urllib.request, json

url = 'https://mnptrblqvocfkwntfmof.supabase.co/rest/v1/themes'
data = json.dumps([{'id': 'kid', 'name': '幼儿', 'icon': '🎈', 'color': '#F97316', 'description': '乘法口诀、拼音、生活常识、儿歌等幼儿知识'}])
req = urllib.request.Request(url, data=data.encode(), headers={
    'apikey': 'sb_publishable_zFcq1rfWxViECIE8sPyylw_xlWp-TfQ',
    'Authorization': 'Bearer sb_publishable_zFcq1rfWxViECIE8sPyylw_xlWp-TfQ',
    'Content-Type': 'application/json',
    'Prefer': 'resolution=merge-duplicates'
})
req.get_method = lambda: 'POST'
try:
    with urllib.request.urlopen(req) as r:
        print('OK:', r.status, r.read().decode()[:100])
except Exception as e:
    print('Error:', e)
