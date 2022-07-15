using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class deleteCollider : MonoBehaviour
{
    public Collider objectToDestory;

    public void delete(){
        Destroy(objectToDestory);
    }
}
