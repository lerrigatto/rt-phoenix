// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("ping", {})
channel.join()
  .receive("ok", resp => { console.log("Joined ping successfully", resp) })
  .receive("error", resp => { console.log("Unable to join ping", resp) })

export default socket

console.log("sending a ping")
channel.push("ping")
  .receive("ok", (resp) => console.log("received", resp.ping))

let authSocket = new Socket("/auth_socket", {
  params: { token: window.authToken }
})

authSocket.onOpen(() => console.log("authSocket connected"))
authSocket.connect()

const recurringChannel = authSocket.channel("recurring")

recurringChannel.on("new_token", (payload) => {
  console.log("received a new token: ", payload)
})

recurringChannel.join()

const dupeChannel = socket.channel("dupe")

dupeChannel.on("number", (payload) => {
  console.log("new number: ", payload)
})

dupeChannel.join()

let statsSocket = new Socket("/stats_socket", {})
statsSocket.onOpen(() => console.log("statsSocket connected"))
statsSocket.connect()

const statsChannelInvalid = statsSocket.channel("invalid")
statsSocketInvalid.join()
  .receive("error", () => {
    statsChannelInvalid.leave()
    console.log("leaving invalid channel")
  })

const statsChannelValid = statsSocket.channel("valid")
statsSocketValid.join()

for (let i=0; i < 5; i++) {
  statsChannelValid.push("ping")
  console.log("ping sent")
}
