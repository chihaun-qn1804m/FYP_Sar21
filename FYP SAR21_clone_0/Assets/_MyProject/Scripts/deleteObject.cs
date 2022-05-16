using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class deleteObject : MonoBehaviour
{
    public GameObject objectToDestory;

    void delete(){
        Destroy(objectToDestory);
    }
}
