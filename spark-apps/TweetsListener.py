import tweepy
from tweepy import OAuthHandler
from tweepy import StreamingClient
# from tweepy.streaming import StreamListener
import socket
import json

# Set up your credentials
consumer_key='M8OWddpoM4S3OgZtdzpKU1Nlv'
consumer_secret='WhSzgVGRVM9hjVP2KK2OMKxP7rCoZ2L0yVLYJ6xsJNTQ3YuY34'
access_token ='1793203752964595712-BtrFOTeeN6cpPjTZCPiI8fSdQawGbs'
access_secret='F7pbaF1UTqAUL4itSEtGS7vFb49p5GsFdovm7i0ZVWRTq'
bearer_token='AAAAAAAAAAAAAAAAAAAAAHqttwEAAAAAyVlWnphydRA5%2F6OcQ6ZHcw64sag%3DhALnUHcyNC98JYavSX5Zh1XRvPf66IxxrK1rSLDiNVLwovVmYh'


class TweetsListener(StreamingClient):

  def __init__(self, csocket):
      self.client_socket = csocket

  def on_data(self, data):
      try:
          msg = json.loads( data )
          print( msg['text'].encode('utf-8') )
          self.client_socket.send( msg['text'].encode('utf-8') )
          return True
      except BaseException as e:
          print("Error on_data: %s" % str(e))
      return True

  def on_error(self, status):
      print(status)
      return True

def sendData(c_socket):
  auth = OAuthHandler(consumer_key, consumer_secret)
  auth.set_access_token(access_token, access_secret)

  twitter_stream = StreamingClient(auth, TweetsListener(c_socket))
  twitter_stream.filter(track=['ether'])

if __name__ == "__main__":
  s = socket.socket()         # Create a socket object
  host = "127.0.0.1"     # Get local machine name
  port = 5554                 # Reserve a port for your service.
  s.bind((host, port))        # Bind to the port

  print("Listening on port: %s" % str(port))

  s.listen(5)                 # Now wait for client connection.
  c, addr = s.accept()        # Establish connection with client.

  print( "Received request from: " + str( addr ) )

  sendData( c )