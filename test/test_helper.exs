Mox.defmock(RiotClientBehaviourMock, for: RiotPoll.HTTP.RiotClientBehaviour)
Application.put_env(:riot_poll, :riot_api_client, RiotClientBehaviourMock)

ExUnit.start()
