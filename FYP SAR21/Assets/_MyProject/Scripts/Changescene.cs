using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class Changescene : MonoBehaviour
{
   public GameObject network;

    private void OnTriggerEnter(Collider other)
    {   
    
       network.GetComponent<NetworkManagerPhoton>().InitialiazeRoom(0, other);
    }
}
