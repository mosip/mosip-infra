server = 'minibox.mosip.net' 
user = '110127'
password = 'Techno@123'

sub_pkts = ['id', 'evidence', 'optional']

pkt_conf = {
    'id_schema':  '0.1',
    'rid': "10002100740000220200801104237",  # Created and give by server
    'creation_date' : '2020-08-01T10:42:37.000Z', # Generate fresh
    'prereg_id' : '', # Eg. '37029479274360'
    'machine_id': '10074',
    'center_id': '10002',
    'officer_id': '110119',
    'date_time' : '2020-08-01T10:42:37.000+05:30', # Create fresh
    'city': 'Kenitra',
    'province': 'Kenitra',
    'zone': 'Ben Mansour',
    'region' : 'Rabat Sale Kenitra'
}
    
pkt_prefix = pkt_conf['rid']
pkt_dir = 'data/packet1'
template_dir = pkt_dir + '/template'
unenc_dir = pkt_dir + '/unencrypted'
enc_dir = pkt_dir + '/encrypted'


