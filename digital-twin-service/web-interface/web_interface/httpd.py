#!/usr/bin/python3

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import sys
import time
import requests
import socket
import threading

from aiohttp import web

IP = '127.0.0.1'
PORT = 5005
loss="0"
#executing_command = False
#
#def exec_ros_cmd_status():
#  global executing_command
#  try:
#    status, addr = s.recvfrom(1024)
#    executing_command = False
#  except:
#    executing_command = False

async def http_handler(request):
  if request.rel_url.path == "/":
    return web.FileResponse("index.html")
  else:
    return web.FileResponse("imgs/" + request.rel_url.path[1:])

async def wshandle(request):
#  global executing_command
  global loss

  ws = web.WebSocketResponse()

  while(True):
    try:
      await ws.prepare(request)
      async for message in ws:
        print("[HTTPD] Message:", message)
        str_split = message.data.split(',')
        str_split = [x.rstrip() for x in str_split]
    
#        if executing_command == False:
        if str_split[0] == "start-replay":
          requests.post("http://replay:5000/lastminute", timeout=1)

        elif str_split[0] == "stop-replay":
          requests.delete("http://replay:5000/lastminute", timeout=1)

        elif str_split[0] == "start-remote":
          print("start-remote")
          requests.post("http://niryo-one-interface:9999/start", json={"loss_rate":loss}, timeout=1)
        
        elif str_split[0] == "stop-remote":
          print("stop-remote")
          requests.post("http://niryo-one-interface:9999/stop", json={"loss_rate":loss},timeout=1)
   
        elif str_split[0] == "joystick":
          print("pkt-loss presssed")
          print(message.data.encode())

        elif str_split[0] == "control" or str_split[0] == "moveit" or str_split[0] == "interface" or str_split[0] == "calibration" or str_split[0] == "joystick":
#          executing_command = True
          s.sendto(message.data.encode(), (IP, PORT))
#            # FIXME: Big hammer here...to be fixed properly...and use mutexes
#            threading.Thread(target = exec_ros_cmd_status).start()
    except RuntimeError:
      return ws
    except:
#      executing_command = False
      pass


if __name__=="__main__":
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

  app = web.Application()
  if sys.version_info > (3, 5, 3):
    app.add_routes([web.get("/", http_handler),
                    web.get("/arm-topview.png", http_handler),
                    web.get("/bottom-topview.png", http_handler),
                    web.get("/bottom-sideview.png", http_handler),
                    web.get("/middle-sideview.png", http_handler),
                    web.get("/top-sideview.png", http_handler),
                    web.get("/gripper-sideview-open.png", http_handler),
                    web.get("/gripper-sideview-closed.png", http_handler),
                    web.get("/rotate.png", http_handler),
                    web.get("/niryo-one-web", wshandle),
					web.get("/5G-Dive_rgb_horizontal.png",http_handler)])
  else:
    app.router.add_get("/", http_handler)
    app.router.add_get("/arm-topview.png", http_handler)
    app.router.add_get("/bottom-topview.png", http_handler)
    app.router.add_get("/bottom-sideview.png", http_handler)
    app.router.add_get("/middle-sideview.png", http_handler)
    app.router.add_get("/top-sideview.png", http_handler)
    app.router.add_get("/gripper-sideview.png", http_handler)
    app.router.add_get("/rotate.png", http_handler)
    app.router.add_get("/niryo-one-web", wshandle)
    app.router.add_get("/5G-Dive_rgb_horizontal.png",http_handler)

  web.run_app(app)

