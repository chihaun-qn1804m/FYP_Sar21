using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

[System.Serializable]
public class DefaultRoom{
    public string Name;
    public int sceneIndex;
    public int maxPlayer;
}
public class NetworkManagerPhoton : MonoBehaviourPunCallbacks
{
    // Start is called before the first frame update
    public List<DefaultRoom> defaultRooms;
   public GameObject roomUI;
   public GameObject loading;
    public void ConnectToServer()
    {
        Debug.Log("testtt");
        PhotonNetwork.ConnectUsingSettings();
        Debug.Log("Try Connect to Server...");
        loading.SetActive(true);
    }

    public override void OnConnectedToMaster()
    {
        Debug.Log("Connected to server.");
        base.OnConnectedToMaster();
        PhotonNetwork.JoinLobby();

    }
    public override void OnJoinedLobby()
    {
        base.OnJoinedLobby();
        Debug.Log("We join the lobby");
        loading.SetActive(false);
        roomUI.SetActive(true);
    }

    public void InitialiazeRoom(int defaultRoomIndex) {
        DefaultRoom roomSettings = defaultRooms[defaultRoomIndex];
        //Load Scene
        PhotonNetwork.LoadLevel(roomSettings.sceneIndex);
        //Create Room
        RoomOptions roomOptions = new RoomOptions();
        roomOptions.MaxPlayers = (byte)roomSettings.maxPlayer;
        roomOptions.IsVisible = true;
        roomOptions.IsOpen = true;

        PhotonNetwork.JoinOrCreateRoom(roomSettings.Name, roomOptions, TypedLobby.Default);
    }
    public override void OnJoinedRoom()
    {
        Debug.Log("Joined a Room");
        base.OnJoinedRoom();
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)
    {
        Debug.Log("A new player joined the room");
        base.OnPlayerEnteredRoom(newPlayer);
    }
}
