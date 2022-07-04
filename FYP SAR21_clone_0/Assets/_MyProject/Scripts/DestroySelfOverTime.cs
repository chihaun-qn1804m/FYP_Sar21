using System.Collections;
using System.Collections.Generic;
using UnityEngine;
 
public class DestroySelfOverTime : MonoBehaviour
{
    public GameObject sphereCollider;
    private void Start()
    {
        Destroy(sphereCollider, 0.1f);
       Destroy(gameObject, 1.5f);
    }
}