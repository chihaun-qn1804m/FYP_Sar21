using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class Changescene : MonoBehaviour
{
   public GameObject room0;
   public GameObject room1;
   public GameObject room2;

    private void OnTriggerEnter(Collider other)
    {   
        Debug.Log("test");
    }
}
