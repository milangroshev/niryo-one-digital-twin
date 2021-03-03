import sys
import zenoh
from zenoh import Zenoh, Value


def main(address, selector):
    # client configuration
    conf = {
        'mode': 'client',
        'peer': '{}'.format(address),
    }

    print("Openning session...")
    zenoh = Zenoh(conf)

    print("New workspace...")
    workspace = zenoh.workspace()

    # getting the data from zenoh, it can come from a storage or an eval
    print("Get Data from '{}'...".format(selector))
    
    output_data = []
    for data in workspace.get(selector):
        _, _, m, s, n = data.path.split('/')
        m = int(m)
        s = int(s)
        n = int(n)
        output_entry = {'m': m, 's': s, 'n': n, 
                        'value': data.value.get_content(), 'timestamp': data.timestamp}
        output_data.append(output_entry)
    
    sorted_output_data = sorted(output_data, key=lambda k: k['n']) 

    for data in sorted_output_data:
        print(data)

    zenoh.close()


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage {} <address of zenoh router> <key selector>")
    main(sys.argv[1], sys.argv[2])

